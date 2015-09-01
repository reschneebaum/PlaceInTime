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
#import "EventDetailTableViewController.h"
#import "LoginViewController.h"
#import "UserEventTableViewCell.h"
#import "UserEvent.h"
#import "HistoryEvent.h"
#import "Landmark.h"
#import "Trip.h"
#import "UserEventAnnotation.h"
#import "LandmarkAnnotation.h"

@interface EventsViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property CLLocationManager *locationManager;
@property NSArray *userEvents;
@property NSArray *historyEvents;
@property NSArray *landmarks;
@property UserEvent *event;
@property BOOL isChicago;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.delegate = self;
    [self.mapView showsUserLocation];
    [self.mapView showsBuildings];
    self.mapLocation = [[CLLocation alloc] initWithLatitude:self.trip.location.latitude longitude:self.trip.location.longitude];
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapLocation.coordinate, MKCoordinateSpanMake(1.0, 1.0))];

    [self searchForAndLoadLandmarks];
    [self checkAndIfChicagoLoadHistoryEvents];
    [self combineLandmarksAndHistoryEventsAndSort];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.2; //length of user press
    [self.mapView addGestureRecognizer:longPress];

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Logout"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logOutButtonTapAction:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
}

-(void)viewWillAppear:(BOOL)animated {
    [self queryAndLoadTripEvents];

}

-(void)queryAndLoadTripEvents {
    if (self.trip != nil) {
        PFQuery *query = [UserEvent query];
        [query whereKey:@"belongsToTrip" equalTo:self.trip];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"successfully received %lu events", (unsigned long)objects.count);

                for (UserEvent *event in objects) {
                    UserEventAnnotation *userAnnot = [UserEventAnnotation new];
                    userAnnot.coordinate = CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude);
                    userAnnot.title = event.name;
                    userAnnot.subtitle = event.date;
                    [self.mapView addAnnotation:userAnnot];
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

-(void)checkAndIfChicagoLoadHistoryEvents {
    PFGeoPoint *chicago = [PFGeoPoint geoPointWithLatitude:41.8369 longitude:-87.6847];
    PFQuery *query = [UserEvent query];
    [query whereKey:@"location" nearGeoPoint:chicago];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            if (objects.count == 0) {
                self.isChicago = false;
                NSLog(@"location isn't in Chicago");
            } else {
                NSLog(@"location is in Chicago");
                self.isChicago = true;
                [self queryAndLoadHistoryEvents];
            }
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
                LandmarkAnnotation *annot = [LandmarkAnnotation new];
                annot.coordinate = CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude);
                annot.title = event.name;
                annot.subtitle = event.date;
                [self.mapView addAnnotation:annot];
            }
            self.historyEvents = [NSArray arrayWithArray:objects];
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

            LandmarkAnnotation *annot = [LandmarkAnnotation new];
            annot.title = mapItem.name;
            NSLog(@"%@",annot.title);
            annot.coordinate = mapItem.placemark.coordinate;
            [self.mapView addAnnotation:annot];
        }
        self.landmarks = [NSArray arrayWithArray:tempLandmarks];
        NSLog(@"%@", self.landmarks.firstObject);
    }];
}

-(void)combineLandmarksAndHistoryEventsAndSort {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.landmarks];
    if (self.historyEvents.count > 0) {
        [tempArray addObjectsFromArray:self.historyEvents];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:sortDescriptors];
    self.landmarks = [NSArray arrayWithArray:sortedArray];
    [self.tableView reloadData];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
    return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    UserEventAnnotation *newAnnotation = [UserEventAnnotation new];
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
    } else if ([annotation isKindOfClass:[UserEventAnnotation class]]) {
        UIImage *image = [UIImage imageNamed:@"path_map"];
        CGRect cropRect = CGRectMake(0.0, 0.0, 35.0, 35.0);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:cropRect];
        imageView.clipsToBounds = YES;
        imageView.image = image;
        pin.canShowCallout = true;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.leftCalloutAccessoryView = imageView;
    } else {
        UIImage *image = [UIImage imageNamed:@"wind_rose"];
        CGRect cropRect = CGRectMake(0.0, 0.0, 35.0, 35.0);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:cropRect];
        imageView.clipsToBounds = YES;
        imageView.image = image;
        pin.canShowCallout = true;
//        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.leftCalloutAccessoryView = imageView;
    }
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake (0,0,320,30)];
//    labelHeader.font = [UIFont fontWithName:@"Avenir Next" size:20];
//    labelHeader.textColor = [UIColor whiteColor];
//    [headerView addSubview:labelHeader];
//    if (section == 0) {
//        [headerView setBackgroundColor:[UIColor whiteColor]];
//        labelHeader.text = @"Personal Events & Landmarks";
//    } else if (section == 1) {
//        [headerView setBackgroundColor:[UIColor whiteColor]];
//        labelHeader.text = @"Historical Events & Landmarks";
//    } else {
//        [headerView setBackgroundColor:[UIColor clearColor]];
//    }
//    return headerView;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
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
        userCell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
        userCell.detailTextLabel.text = [self.userEvents[indexPath.row]dateString];
        userCell.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next" size:12];
//        userCell.imageView.image = [UIImage imageNamed:self.userEvents[indexPath.row]imageString];
        return userCell;
    } else {
        UITableViewCell *landmarkCell = [tableView dequeueReusableCellWithIdentifier:@"LandmarkCellID"];
        landmarkCell.textLabel.text = [self.landmarks[indexPath.row]name];
        return landmarkCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    self.event = self.userEvents[indexPath.row];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
 }



 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }


 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
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

-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        EventDetailTableViewController *detailVC = segue.destinationViewController;
        detailVC.userEvent = self.event;
        detailVC.trip = self.trip;
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
