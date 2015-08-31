//
//  ViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/17/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "EventsViewController.h"
#import "AddEventViewController.h"
#import "EventDetailTableViewController.h"
#import "LoginViewController.h"
#import "UserEventTableViewCell.h"
#import "UserEvent.h"
#import "HistoryEvent.h"
#import "Landmark.h"
#import "Trip.h"
//#import "ParseQueryManager.h"

@interface EventsViewController () <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    NSLog(@"viewdidload, mapsVC: %@", self.trip);
    self.mapView.delegate = self;
    [self.mapView showsUserLocation];
    [self.mapView showsBuildings];
    self.mapLocation = [[CLLocation alloc] initWithLatitude:self.trip.location.latitude longitude:self.trip.location.longitude];
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapLocation.coordinate, MKCoordinateSpanMake(1.0, 1.0))];

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
    [self searchForAndLoadLandmarks];

}

-(void)queryAndLoadTripEvents {
    if (self.trip != nil) {
        PFQuery *query = [UserEvent query];
        [query whereKey:@"belongsToTrip" equalTo:self.trip];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"successfully received %lu events", (unsigned long)objects.count);

                for (UserEvent *event in objects) {
                    MKPointAnnotation *annot = [MKPointAnnotation new];
                    annot.coordinate = CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude);
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
    } else {
        NSLog(@"eventsVC: self.trip (%@) is nil", self.trip);
    }
}

-(void)queryAndLoadHistoryEvents {
    PFQuery *histQuery = [HistoryEvent query];
    [histQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);

            for (HistoryEvent *event in objects) {
                MKPointAnnotation *annot = [MKPointAnnotation new];
                annot.coordinate = CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude);
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
    request.region = MKCoordinateRegionMake(self.mapLocation.coordinate, MKCoordinateSpanMake(1.0, 1.0));
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


#pragma mark - MKMapView methods
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
        if (userEvent.location.latitude == annot.coordinate.latitude && userEvent.location.longitude == annot.coordinate.longitude) {
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
        if (histEvent.location.latitude == annot.coordinate.latitude && histEvent.location.longitude == annot.coordinate.longitude) {
            self.selectedHistoryEvent = histEvent;
            if (self.historyEvents.lastObject) {
                break;
            }
            if (self.selectedHistoryEvent == nil) {
                self.isHistoryEvent = false;
            }
        }
    }
    EventDetailTableViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Personal Events & Landmarks";
    } else {
        return @"Historical Events & Landmarks";
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.userEvents.count;
    } else {
    return self.landmarks.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"UserCellID"];
        userCell.textLabel.text = [self.userEvents[indexPath.row]name];
        return userCell;
    } else {
        UITableViewCell *landmarkCell = [tableView dequeueReusableCellWithIdentifier:@"LandmarkCellID"];
        landmarkCell.textLabel.text = [self.landmarks[indexPath.row]name];
        return landmarkCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailTableViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    detailVC.userEvent = self.userEvents[indexPath.row];
    detailVC.trip = self.trip;
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
    [self queryAndLoadTripEvents];
}

- (IBAction)logOutButtonTapAction:(UIBarButtonItem *)sender {
    [PFUser logOut];
    LoginViewController *login = [LoginViewController new];
    [self presentViewController:login animated:true completion:nil];
}

@end
