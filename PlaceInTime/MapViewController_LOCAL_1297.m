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
#import "EventDetailViewController.h"
#import "UserEvent.h"
#import "HistoryEvent.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, LoginViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *point;
@property CLLocation *currentLocation;
@property MKMapItem *mapLocation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self loadHistoryEvents];
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
    self.mapView.hidden = false;
    self.tableView.hidden = true;

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.2; //length of user press
    [self.mapView addGestureRecognizer:longPress];
}

-(void)viewWillAppear:(BOOL)animated {

    PFQuery *query = [PFQuery queryWithClassName:@"UserEvent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                MKPointAnnotation *annot = [MKPointAnnotation new];
                annot.coordinate = CLLocationCoordinate2DMake([object[@"latitude"]doubleValue], [object[@"longitude"]doubleValue]);
                annot.title = object[@"name"];
                annot.subtitle = object[@"date"];
                [self.mapView addAnnotation:annot];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    PFQuery *histQuery = [PFQuery queryWithClassName:@"HistoryEvent"];
    [histQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                MKPointAnnotation *annot = [MKPointAnnotation new];
                annot.coordinate = CLLocationCoordinate2DMake([object[@"latitude"]doubleValue], [object[@"longitude"]doubleValue]);
                annot.title = object[@"name"];
                annot.subtitle = object[@"date"];
                [self.mapView addAnnotation:annot];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self searchForAndAddLandmarks];
}

-(void)loadHistoryEvents{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"timeplaces" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
    NSLog(@"%@", array);

    for (NSDictionary *dictionary in array) {
        HistoryEvent *event = [HistoryEvent object];
        event.name = dictionary[@"name"];
        event.date = [NSString stringWithFormat:@"%@", dictionary[@"date"]];
        event.textDescription = @"";
        event.latitude = [dictionary[@"latitude"] floatValue];
        event.longitude = [dictionary[@"longitude"] floatValue];
        [event saveInBackground];
        MKPointAnnotation *annot = [MKPointAnnotation new];
        annot.coordinate = CLLocationCoordinate2DMake(event.latitude, event.longitude);
        annot.title = event.name;
        annot.subtitle = event.date;
        [self.mapView addAnnotation:annot];
    }
}

-(void)searchForAndAddLandmarks {
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Landmarks";
    request.region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(1, 1));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (MKMapItem *mapItem in response.mapItems) {
            MKPointAnnotation *annot = [MKPointAnnotation new];
            annot.title = mapItem.name;
            NSLog(@"%@",annot.title);
            annot.coordinate = mapItem.placemark.coordinate;
            [self.mapView addAnnotation:annot];
        }
    }];
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
        newAnnotation.coordinate = touchMapCoordinate;
        AddEventViewController *eventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eventVC"];
        eventVC.location = newAnnotation.coordinate;
        [self presentViewController:eventVC animated:true completion:nil];
        [self.mapView addAnnotation:newAnnotation];
        NSLog(@"event: %g, %g", eventVC.location.latitude, eventVC.location.longitude);
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

    }
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
}-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPointAnnotation *annot = (MKPointAnnotation *)view.annotation;
    EventDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    detailVC.location = annot.coordinate;
    [self presentViewController:detailVC animated:true completion:nil];
}

#pragma mark - UITableView datasource methods
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = self.events[indexPath.row];

    return cell;
}


- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender {
    [self promptTwitterAuthentication];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    LoginViewController *loginVC = segue.destinationViewController;
//    loginVC.currentLocation = self.currentLocation;
//    AddEventViewController *eventVC = segue.destinationViewController;
//    eventVC.event = self.event;
//    EventDetailViewController *detailVC =segue.destinationViewController;
//}

- (IBAction)unwindFromCancelAction:(UIStoryboardSegue *)segue {
//    [self.mapView removeAnnotation:]
}

@end
