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
#import <TwitterKit/TwitterKit.h>
#import "MapViewController.h"
#import "LoginViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

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

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; //length of user press
    [self.mapView addGestureRecognizer:lpgr];
//
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
}

-(void)promptSignInWhenPinDroppedAtLocation:(CLLocationCoordinate2D)eventLocation {
    UIAlertController *userEventAlert = [UIAlertController alertControllerWithTitle:@"Authenticate" message:@"Please authenticate your existence in order to add a new event to the map." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        LoginViewController *loginVC = [LoginViewController new];
        [self presentViewController:loginVC animated:true completion:nil];
//        [self.navigationController pushViewController:loginVC animated:YES];
        loginVC.userEventLocation = eventLocation;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [userEventAlert addAction:addAction];
    [userEventAlert addAction:cancelAction];
    [self presentViewController:userEventAlert animated:YES completion:nil];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
    newAnnotation.coordinate = touchMapCoordinate;
    [self promptSignInWhenPinDroppedAtLocation:touchMapCoordinate];
    [self.mapView addAnnotation:newAnnotation];

//  store & persist the following values:
//    double latitude = annot.coordinate.latitude;
//    double longitude = annot.coordinate.longitude;
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
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LoginViewController *loginVC = segue.destinationViewController;
    loginVC.currentLocation = self.currentLocation;
}

- (IBAction)unwindFromCancelAction:(UIStoryboardSegue *)segue {

}

- (IBAction)unwindFromAddAction:(UIStoryboardSegue *)segue {

}

@end
