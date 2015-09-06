//
//  NewTripViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/26/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "RootViewController.h"
#import "NewTripViewController.h"
#import "AddEventViewController.h"
#import "EventDetailTableViewController.h"
#import "LoginViewController.h"
#import "Landmark.h"

@interface NewTripViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property NSArray *landmarks;

@end

@implementation NewTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(self.userLocation.coordinate, MKCoordinateSpanMake(0.5, 0.5)) animated:true];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", self.trip.name]];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.2; //length of user press
    [self.mapView addGestureRecognizer:longPress];
}

-(void)searchForAndAddLandmarks {
    NSMutableArray *tempLandmarks = [NSMutableArray new];
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Landmarks";
    request.region = MKCoordinateRegionMake(self.userLocation.coordinate, MKCoordinateSpanMake(1.0, 1.0));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (MKMapItem *mapItem in response.mapItems) {
            Landmark *landmark = [Landmark new];
            landmark.name = mapItem.name;
            landmark.textDescription = @"";
            landmark.latitude = mapItem.placemark.coordinate.latitude;
            landmark.longitude = mapItem.placemark.coordinate.longitude;
            [tempLandmarks addObject:landmark];

            MKPointAnnotation *annot = [MKPointAnnotation new];
            annot.title = mapItem.name;
            NSLog(@"%@",annot.title);
            annot.coordinate = mapItem.placemark.coordinate;
            [self.mapView addAnnotation:annot];
        }
        self.landmarks = [NSArray arrayWithArray:tempLandmarks];
    }];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    MKPointAnnotation *newAnnotation = [MKPointAnnotation new];
    newAnnotation.coordinate = touchMapCoordinate;
    AddEventViewController *eventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eventVC"];
    eventVC.location = newAnnotation.coordinate;
    eventVC.trip = self.trip;
    [self presentViewController:eventVC animated:true completion:nil];
    [self.mapView addAnnotation:newAnnotation];
}


#pragma mark - MKMapViewDelegate methods
#pragma mark -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    if ([annotation isEqual:mapView.userLocation]) {
        return nil;
    }
    UIImage *image = [UIImage imageNamed:@"wind_rose"];
    CGRect cropRect = CGRectMake(0.0, 0.0, 35.0, 35.0);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cropRect];
    imageView.clipsToBounds = YES;
    imageView.image = image;
    pin.canShowCallout = true;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.leftCalloutAccessoryView = imageView;

    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPointAnnotation *annot = (MKPointAnnotation *)view.annotation;
    EventDetailTableViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    detailVC.location = annot.coordinate;
    [self presentViewController:detailVC animated:true completion:nil];
}

#pragma mark - Navigation
#pragma mark -


- (IBAction)onFinishButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    //    RootViewController *rootVC = [RootViewController new];
    //    [self presentViewController:rootVC animated:true completion:nil];
    [self performSegueWithIdentifier:@"saveSegue" sender:self];
}

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {
    NSLog(@"%@",self.trip);
    [self.trip delete];
    NSLog(@"%@",self.trip);
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"cancelSegue"]) {
        NSLog(@"%@", self.trip);
    } else if ([segue.identifier isEqualToString:@"saveSegue"]) {
        NSLog(@"trip saved");
    }
}

@end
