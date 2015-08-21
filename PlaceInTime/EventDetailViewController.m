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
#import "EventDetailViewController.h"
#import "UserEvent.h"

@interface EventDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property UserEvent *event;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%f, %f", self.location.latitude, self.location.longitude);
}

-(void)loadSelectedEvent {
    PFQuery *query = [PFQuery queryWithClassName:@"UserEvent"];
    [query whereKey:@"latitude" equalTo:@"self.location.latitude"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            if (objects.count > 1) {
                NSLog(@"error!");
            } else {
                self.event = objects.firstObject;
                self.descriptionTextView.text = self.event.textDescription;
                self.navigationItem.title = self.event.name;
                self.dateLabel.text = self.event.date;
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];


}

- (IBAction)onDismissButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
