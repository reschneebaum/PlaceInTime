//
//  EventDetailViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/21/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "EventDetailViewController.h"
#import "EventsViewController.h"
#import "UserEvent.h"
#import "HistoryEvent.h"
#import "Landmark.h"

@interface EventDetailViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property UserEvent *event;
@property HistoryEvent *histEvent;
@property Landmark *landmark;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkIfObjectPassedByTableView];
}

-(void)checkIfObjectPassedByTableView {
    if (self.point != nil) {
        NSLog(@"object passed by tableview");
        self.descriptionTextView.text = self.point.textDescription;
        self.nameLabel.text = self.point.name;
        self.dateLabel.text = self.point.date;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.point.latitude longitude:self.point.longitude];
        [self reverseGeocode:location];
    } else {
        [self checkForLandmark];
        if (self.landmark != nil) {
            self.descriptionTextView.text = self.landmark.textDescription;
            self.nameLabel.text = self.landmark.name;
            self.dateLabel.text = self.landmark.date;
            CLLocation *location = [[CLLocation alloc] initWithLatitude:self.landmark.latitude longitude:self.landmark.longitude];
            [self reverseGeocode:location];
        } else {
            NSLog(@"not a landmark");
            [self checkForUserEvent];
            if (self.event == nil) {
                NSLog(@"not a user event");
                [self checkForHistoryEvent];
            }
        }
    }
}

-(void)checkForLandmark {
    for (Landmark *landmark in self.landmarks) {
        if (landmark.latitude == self.location.latitude && landmark.longitude == self.location.longitude) {
            self.landmark = landmark;
            NSLog(@"%@", self.landmark);
        } else {
            self.landmark = nil;
        }
    }
}

-(void)checkForUserEvent {
    PFQuery *query = [UserEvent query];
    [query whereKey:@"latitude" equalTo:@(self.location.latitude)];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            if (objects.count > 1) {
                NSLog(@"error!");
            } else if (objects.count == 1) {
                self.event = objects.firstObject;
                NSLog(@"%@", self.event);
                self.descriptionTextView.text = self.event.textDescription;
                self.nameLabel.text = self.event.name;
                self.dateLabel.text = self.event.date;
                CLLocation *location = [[CLLocation alloc] initWithLatitude:self.event.latitude longitude:self.event.longitude];
                [self reverseGeocode:location];
            } else {
                self.event = nil;
                NSLog(@"object is not a user event");
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)checkForHistoryEvent {
    PFQuery *histQuery = [HistoryEvent query];
    [histQuery whereKey:@"latitude" equalTo:@(self.location.latitude)];
    [histQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            if (objects.count > 1) {
                NSLog(@"error!");
            } else if (objects.count == 1) {
                self.histEvent = objects.firstObject;
                NSLog(@"%@", self.histEvent);
                self.descriptionTextView.text = self.histEvent.textDescription;
                self.nameLabel.text = self.histEvent.name;
                self.dateLabel.text = self.histEvent.date;
                CLLocation *location = [[CLLocation alloc] initWithLatitude:self.histEvent.latitude longitude:self.histEvent.longitude];
                [self reverseGeocode:location];
            } else {
                self.histEvent = nil;
                NSLog(@"object is not a history event");
            }
        }
    }];
}

-(void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.lastObject;
        NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@ %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
        self.locationLabel.text = address;
    }];
}

- (IBAction)onDismissButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
