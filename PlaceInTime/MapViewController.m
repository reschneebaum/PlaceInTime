//
//  ViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/17/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate>

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

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; //length of user press
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
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

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Directions" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *directionsAction = [UIAlertAction actionWithTitle:@"Get Directions" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
//        [self getDirectionsTo:mapItem];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:directionsAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
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

@end
