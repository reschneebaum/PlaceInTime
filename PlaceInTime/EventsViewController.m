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
#import <ParseUI/ParseUI.h>
#import "EventsViewController.h"
#import "AddEventViewController.h"
#import "EventDetailViewController.h"
#import "LoginViewController.h"
#import "UserEventTableViewCell.h"
#import "UserEvent.h"
#import "HistoryEvent.h"
#import "Landmark.h"
#import "Trip.h"

@interface EventsViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, PFLogInViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSArray *userEvents;
@property NSArray *historyEvents;
@property NSArray *landmarks;
@property BOOL isLandmark;
@property BOOL isUserEvent;
@property BOOL isHistoryEvent;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.mapView.delegate = self;
    [self.mapView showsUserLocation];
    [self.mapView showsBuildings];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.trip.latitude, self.trip.longitude), MKCoordinateSpanMake(.5, .5)) animated:1];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.2; //length of user press
    [self.mapView addGestureRecognizer:longPress];

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Logout"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logOutButtonTapAction:)];
    self.navigationItem.rightBarButtonItem = logoutButton;

    NSLog(@"%@", [PFUser currentUser][@"username"]);
}

-(void)viewWillAppear:(BOOL)animated {
    [self queryAndLoadTripEvents];
    [self queryAndLoadHistoryEvents];
}

-(void)queryAndLoadTripEvents {
    PFQuery *query = [UserEvent query];
    [query whereKey:@"belongsToTrip" equalTo:self.trip];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"successfully received %lu events", (unsigned long)objects.count);

            for (UserEvent *event in objects) {
                MKPointAnnotation *annot = [MKPointAnnotation new];
                annot.coordinate = CLLocationCoordinate2DMake(event.latitude, event.longitude);
                annot.title = event.name;
                annot.subtitle = event.date;
                [self.mapView addAnnotation:annot];
            }
            self.userEvents = [NSArray arrayWithArray:objects];
            [self.tableView reloadData];
            NSLog(@"%@", self.userEvents.firstObject);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)queryAndLoadHistoryEvents {
    PFQuery *histQuery = [HistoryEvent query];
    [histQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);

            for (HistoryEvent *event in objects) {
                MKPointAnnotation *annot = [MKPointAnnotation new];
                annot.coordinate = CLLocationCoordinate2DMake(event.latitude, event.longitude);
                annot.title = event.name;
                annot.subtitle = event.date;
                [self.mapView addAnnotation:annot];
            }
            self.historyEvents = [NSArray arrayWithArray:objects];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)searchForAndLoadLandmarks {
    NSMutableArray *tempLandmarks = [NSMutableArray new];
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Landmarks";
    request.region = MKCoordinateRegionMake(self.currentLocation.coordinate, MKCoordinateSpanMake(.5, .5));
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
    [self presentViewController:eventVC animated:true completion:nil];
    [self.mapView addAnnotation:newAnnotation];
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
    [self searchForAndLoadLandmarks];
}


#pragma mark - MKMapView methods
#pragma mark -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    if ([annotation isEqual:mapView.userLocation]) {
        return nil;
    }
    pin.canShowCallout = true;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPointAnnotation *annot = (MKPointAnnotation *)view.annotation;
    for (Landmark *landmark in self.landmarks) {
        if (landmark.latitude == annot.coordinate.latitude && landmark.longitude == annot.coordinate.longitude) {
            self.selectedLandmark = landmark;
            if (self.landmarks.lastObject) {
                break;
            }
            if (self.selectedLandmark == nil) {
                self.isLandmark = false;
            }
        }
    }
    for (UserEvent *userEvent in self.userEvents) {
        if (userEvent.latitude == annot.coordinate.latitude && userEvent.longitude == annot.coordinate.longitude) {
            self.selectedUserEvent = userEvent;
            if (self.userEvents.lastObject) {
                break;
            }
            if (self.selectedUserEvent == nil) {
                self.isUserEvent = false;
            }
        }
    }
    for (HistoryEvent *histEvent in self.historyEvents) {
        if (histEvent.latitude == annot.coordinate.latitude && histEvent.longitude == annot.coordinate.longitude) {
            self.selectedHistoryEvent = histEvent;
            if (self.historyEvents.lastObject) {
                break;
            }
            if (self.selectedHistoryEvent == nil) {
                self.isHistoryEvent = false;
            }
        }
    }
    EventDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    if (self.isLandmark) {
        detailVC.isLandmark = true;
        detailVC.landmark = self.selectedLandmark;
    } else if (self.isUserEvent) {
        detailVC.isUserEvent = true;
        detailVC.isUserEvent = self.selectedUserEvent;
    } else {
        detailVC.isHistoryEvent = true;
        detailVC.histEvent = self.selectedHistoryEvent;
    }
    detailVC.location = annot.coordinate;
    [self presentViewController:detailVC animated:true completion:nil];
}

#pragma mark - UITableView datasource methods
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [self.userEvents[indexPath.row]name];

    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    detailVC.userEvent = self.userEvents[indexPath.row];
    [self presentViewController:detailVC animated:true completion:nil];
}

- (IBAction)onSegmentedControlSwitched:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.tableView.hidden = true;
        self.mapView.hidden = false;
    } else {
        self.tableView.hidden = false;
        self.mapView.hidden = true;
    }
}

- (IBAction)unwindFromCancelAction:(UIStoryboardSegue *)segue {
//    [self.mapView removeAnnotation:]
}

- (IBAction)logOutButtonTapAction:(UIBarButtonItem *)sender {
    [PFUser logOut];
    LoginViewController *login = [LoginViewController new];
    [self presentViewController:login animated:true completion:nil];
}

@end
