//
//  EventDetailViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/21/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/Parse.h>
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

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    NSError *error = [NSError new];
    [self determineEventClassWithError:error];
    if (!error) {
        [self assignPointValues];
    } else {
        NSLog(@"uh oh");
    }
}

-(id)determineEventClassWithError:(NSError *)error {
    if (self.userEvent != nil) {
        return self.userEvent;
    } else if (self.landmark != nil) {
        return self.landmark;
    } else if (self.histEvent) {
        return self.histEvent;
    } else {
        return error;
    }
}

-(void)assignPointValues {
    if (self.isUserEvent) {
        NSLog(@"%@", self.userEvent);
        self.descriptionTextView.text = self.userEvent.textDescription;
        self.nameLabel.text = self.userEvent.name;
        self.dateLabel.text = self.userEvent.date;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.userEvent.location.latitude longitude:self.userEvent.location.longitude];
        [self reverseGeocode:location];
    }
    if (self.isLandmark) {
        NSLog(@"%@", self.landmark);
        self.descriptionTextView.text = self.landmark.textDescription;
        self.nameLabel.text = self.landmark.name;
        self.dateLabel.text = self.landmark.date;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.landmark.latitude longitude:self.landmark.longitude];
        [self reverseGeocode:location];
    }
    if (self.isHistoryEvent) {
        NSLog(@"%@", self.histEvent);
        self.descriptionTextView.text = self.histEvent.textDescription;
        self.nameLabel.text = self.histEvent.name;
        self.dateLabel.text = self.histEvent.date;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.histEvent.location.latitude longitude:self.histEvent.location.longitude];
        [self reverseGeocode:location];
    }
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
