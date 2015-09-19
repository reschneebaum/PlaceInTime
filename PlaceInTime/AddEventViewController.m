//
//  AddEventViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/18/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "AddEventViewController.h"
#import "EventsViewController.h"
#import "UserEvent.h"
#import "Trip.h"

@interface AddEventViewController () <CLLocationManagerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *bgMapView;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventDateTextField;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (weak, nonatomic) IBOutlet UISlider *eventValenceSlider;
@property (weak, nonatomic) IBOutlet UITextView *valenceDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property NSDateFormatter *dateFormat;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.bgMapView showsUserLocation];
    [self.bgMapView showsBuildings];
    [self initializeTextFieldInputView];
    [self configureStoryboardObjects];

}

-(void)getCurrentTrip {
    PFQuery *query = [Trip query];
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query whereKey:@"location" nearGeoPoint:[PFGeoPoint geoPointWithLatitude:self.location.latitude longitude:self.location.latitude]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"successfully received %lu trip(s)", (unsigned long)objects.count);
            self.trip = objects.firstObject;
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    }];
}

-(void)configureStoryboardObjects {
    self.eventDescriptionTextView.layer.cornerRadius = 10.0;
    self.eventDescriptionTextView.layer.borderWidth = 0.3;
    self.eventDescriptionTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.valenceDescriptionTextView.layer.cornerRadius = 10.0;
    self.valenceDescriptionTextView.layer.borderWidth = 0.3;
    self.valenceDescriptionTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.addButton.enabled = false;
    self.eventDescriptionTextView.delegate = self;
}

-(void)initializeTextFieldInputView {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    self.eventDateTextField.inputView = datePicker;
}

-(void)dateUpdated:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    self.eventDateTextField.text = [dateFormat stringFromDate:datePicker.date];
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
        [self.bgMapView setRegion:MKCoordinateRegionMake(self.currentLocation.coordinate, MKCoordinateSpanMake(.05, .05)) animated:false];
    }
}

- (IBAction)onEventNameChanged:(UITextField *)sender {
    if ([self.eventNameTextField hasText] && [self.eventDateTextField hasText] && [self.eventDescriptionTextView hasText]) {
        self.addButton.enabled = true;
    }
}

- (IBAction)onEventDateChanged:(UITextField *)sender {
    if ([self.eventNameTextField hasText] && [self.eventDateTextField hasText] && [self.eventDescriptionTextView hasText]) {
        self.addButton.enabled = true;
    }
}

-(IBAction)textViewDidChange:(UITextView *)textView {
    textView = self.eventDescriptionTextView;
    if ([self.eventNameTextField hasText] && [self.eventDateTextField hasText] && [self.eventDescriptionTextView hasText]) {
        self.addButton.enabled = true;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    textView = self.eventDescriptionTextView;
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return false;
    }
    return true;
}

- (IBAction)onAddButtonTapped:(UIButton *)sender {
    UserEvent *event = [UserEvent object];
    event.name = self.eventNameTextField.text;
    event.date = self.eventDateTextField.text;
    event.textDescription = self.eventDescriptionTextView.text;
    event.valence = self.eventValenceSlider.value;
    event.location = [PFGeoPoint geoPointWithLatitude:self.location.latitude longitude:self.location.longitude];
    event.belongsToTrip = self.trip;
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"The object has been saved.");
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            NSLog(@"There was a problem, check error.description");
        }
    }];
}

@end