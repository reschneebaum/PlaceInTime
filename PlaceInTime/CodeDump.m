//
//  CodeDump.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/26/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "CodeDump.h"

@implementation CodeDump

//  no-longer-used code, because just in case....

/*
 // from eventsVC

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
    //  associated delegation code (w/ above):
    LoginViewControllerDelegate


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

 -(void)sortAllMapObjects {
 [self.points addObjectsFromArray:self.userEvents];
 [self.points addObjectsFromArray:self.historyEvents];
 [self.points addObjectsFromArray:self.landmarks];
 NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true selector:@selector(localizedCaseInsensitiveCompare:)];
 NSArray *sortDescriptors = @[nameDescriptor];
 [self.points sortUsingDescriptors:sortDescriptors];
 }
 
 



 */
@end
