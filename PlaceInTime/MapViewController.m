//
//  ViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/17/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import <TwitterKit/TwitterKit.h>
#import "MapViewController.h"
#import "LoginViewController.h"
#import "AddEventViewController.h"
#import "UserEvent.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, LoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *point;
@property CLLocation *currentLocation;
@property MKMapItem *mapLocation;
@property MKMapItem *sadPinLocation;
@property MKMapItem *neutralPinLocation;
@property MKMapItem *happyPinLocation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.mapView showsUserLocation];
    [self.mapView showsBuildings];
    self.mapView.delegate = self;
    self.mapView.layer.cornerRadius = 10.0;
    self.mapView.layer.borderWidth = 1.5;
    self.mapView.layer.borderColor = [[UIColor whiteColor]CGColor];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.2; //length of user press
    [self.mapView addGestureRecognizer:longPress];

    [self geocodeLocation:@"Wrigley field"];
    [self geocodeLocation:@"Willis Tower"];
    [self geocodeLocation:@"Chicago Board of Trade"];
    [self geocodeLocation:@"Uptown Theatre Chicago"];
    [self geocodeLocation:@"Merchandise Mart Chicago"];
    [self geocodeLocation:@"O'Hare International Airport"];
    [self geocodeLocation:@"Navy Pier"];
    [self geocodeLocation:@"Buckingham Fountain"];
    [self geocodeLocation:@"Chicago Riverwalk"];
    [self geocodeLocation:@"AON Center"];
}

-(void)promptTwitterAuthentication {
    UIAlertController *userEventAlert = [UIAlertController alertControllerWithTitle:@"Authenticate" message:@"Please authenticate your existence in order to add a new event to the map." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.delegate = self;
        [self presentViewController:loginVC animated:true completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
    }];
    [userEventAlert addAction:okAction];
    [userEventAlert addAction:cancelAction];
    [self presentViewController:userEventAlert animated:true completion:nil];
}

- (void)isUserLoggedIn:(BOOL)userLoggedIn {
    NSLog(@"isUserLoggedIn: %i", userLoggedIn);
    self.userLoggedIn = userLoggedIn;
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
    return;

    if (self.userLoggedIn) {
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        MKPointAnnotation *newAnnotation = [MKPointAnnotation new];
        UserEvent *event = [UserEvent object];
        newAnnotation.coordinate = touchMapCoordinate;
        newAnnotation.title = event.name;
        newAnnotation.subtitle = event.date;
        event.latitude = touchMapCoordinate.latitude;
        event.longitude = touchMapCoordinate.longitude;
        self.event = event;
        [self.mapView addAnnotation:newAnnotation];
        [self.event saveInBackground];
        NSLog(@"%f", self.event.latitude);
    }
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
        }
        [self.mapView setRegion:MKCoordinateRegionMake(self.currentLocation.coordinate, MKCoordinateSpanMake(.05, .05)) animated:true];
    }
}

#pragma mark - MKMapView methods
#pragma mark -

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    [self.mapView setRegion:MKCoordinateRegionMake(view.annotation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:view.annotation.coordinate addressDictionary:nil];
    self.mapLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    if ([annotation isEqual:mapView.userLocation]) {
        return nil;
    }
    if ([annotation isEqual:self.sadPinLocation]) {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
    if ([annotation isEqual:self.neutralPinLocation]) {
        pin.pinColor = MKPinAnnotationColorGreen;
    }
    if ([annotation isEqual:self.happyPinLocation]) {
        pin.pinColor = MKPinAnnotationColorRed;
    }
    pin.canShowCallout = true;
    pin.image = [UIImage imageNamed:@"star_gold"];
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender {
    [self promptTwitterAuthentication];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LoginViewController *loginVC = segue.destinationViewController;
    loginVC.currentLocation = self.currentLocation;
    AddEventViewController *eventVC = [AddEventViewController new];
    eventVC.event = self.event;
}

- (IBAction)onTestButtonPressed:(UIBarButtonItem *)sender {
     AddEventViewController *eventVC = [AddEventViewController new];
    eventVC.event = self.event;
    [self presentViewController:eventVC animated:true completion:nil];
}

- (IBAction)unwindFromCancelAction:(UIStoryboardSegue *)segue {

}

- (IBAction)unwindFromAddAction:(UIStoryboardSegue *)segue {

}

-(void)geocodeLocation:(NSString *)addressString{
    NSString *address = addressString;
    CLGeocoder *geocoder = [CLGeocoder new];

    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.title = addressString;
            annotation.subtitle = @"Chicago Landmark";
            annotation.coordinate = place.location.coordinate;
            [self.mapView addAnnotation:annotation];
        }
    }];

}



@end
