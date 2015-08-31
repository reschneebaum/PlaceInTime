//
//  AddTripViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/26/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <MapKit/MapKit.h>
#import "AddTripViewController.h"
#import "EventsViewController.h"
#import "NewTripViewController.h"
#import "UserEvent.h"
#import "Trip.h"

@interface AddTripViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property CLLocationManager *locationManager;
@property CLPlacemark *locationPlacemark;
@property CLLocation *currentLocation;
@property CLLocation *userLocation;
@property Trip *trip;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation AddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.89374, -87.63533), MKCoordinateSpanMake(0.5, 0.5)) animated:false];
}

-(void)performForwardGeocoding {
    NSString *locationString = [NSString stringWithFormat:@"%@ %@ %@", self.cityTextField.text, self.stateTextField.text, self.countryTextField.text];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:locationString completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            NSLog(@"%@", placemarks.firstObject);
            self.locationPlacemark = placemarks.firstObject;
            [self createTrip];
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}

-(void)reverseGeocodeFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.lastObject;
        self.cityTextField.text = placemark.locality;
        self.stateTextField.text = placemark.administrativeArea;
        self.countryTextField.text = placemark.country;
        NSLog(@"%@", placemark.locality);
    }];
}

-(void)createTrip {
    if (![PFUser currentUser]) {
        NSLog(@"no user logged in");
    } else {
        Trip *newTrip = [Trip object];
        newTrip.createdBy = [PFUser currentUser];
        newTrip.location = [PFGeoPoint geoPointWithLocation:self.locationPlacemark.location];
        newTrip.date = [self.datePicker date];
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"dd MMM yyyy"];
        NSString *dateString = [dateFormat stringFromDate:newTrip.date];
        newTrip.name = [NSString stringWithFormat:@"%@, %@ - %@", self.cityTextField.text, self.countryTextField.text, dateString];
        [newTrip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"The object has been saved.");
                self.userLocation = [[CLLocation alloc] initWithLatitude:newTrip.location.latitude longitude:newTrip.location.longitude];
                [self performSegueWithIdentifier:@"tripDetail" sender:self];
            } else {
                NSLog(@"There was a problem, check error.description");
            }
        }];
    }
}

-(void)presentAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Blank Fields" message:@"Please be sure to complete all fields!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}


#pragma mark - CLLocationManagerDelegate methods
#pragma mark -

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 200 && location.verticalAccuracy < 200) {
            [self.locationManager stopUpdatingLocation];
            self.currentLocation = location;
            [self reverseGeocodeFromLocation:location];
        }
    self.userLocation = location;
    }
}

#pragma mark - Navigation
#pragma mark -

- (IBAction)onCurrentLocationButtonPressed:(UIButton *)sender {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (IBAction)onGoButtonPressed:(UIBarButtonItem *)sender {
    if (self.cityTextField.hasText && self.stateTextField.hasText && self.countryTextField.hasText) {
        [self performForwardGeocoding];
    } else {
        [self presentAlertController];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"tripDetail"]) {
        UINavigationController *navVC = segue.destinationViewController;
        NewTripViewController *newTripVC = (NewTripViewController *)navVC.viewControllers[0];
        newTripVC.userLocation = self.userLocation;
        NSLog(@"self - %@", self.userLocation);
        NSLog(@"%@", newTripVC.userLocation);
        newTripVC.trip = self.trip;
        newTripVC.navigationItem.title = self.trip.name;
    }
}

- (IBAction)onCancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}



@end
