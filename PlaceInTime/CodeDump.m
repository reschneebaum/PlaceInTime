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
 
 

 //
 //- (void)viewDidAppear:(BOOL)animated {
 //    [super viewDidAppear:animated];
 //
 //    if (![PFUser currentUser]) {
 //        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
 //        [logInViewController setDelegate:self];
 //
 //        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
 //        [signUpViewController setDelegate:self];
 //
 //        [logInViewController setSignUpController:signUpViewController];
 //
 //        [self presentViewController:logInViewController animated:YES completion:NULL];
 //    }
 //}
 //
 //
 //#pragma mark - PFLogInViewControllerDelegate
 //#pragma mark -
 //
 //- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
 //    if (username && password && username.length && password.length) {
 //        return YES; // Begin login process
 //    }
 //
 //    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
 //    return NO; // Interrupt login process
 //}
 //
 //- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
 //    [self dismissViewControllerAnimated:true completion:nil];
 //    [self.navigationController popToRootViewControllerAnimated:true];
 //}
 //
 //- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
 //    NSLog(@"Failed to log in...");
 //}
 //
 //- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
 //    NSLog(@"User dismissed the logInViewController");
 //}
 //
 //
 //#pragma mark - PFSignUpViewControllerDelegate
 //#pragma mark -
 //
 //- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
 //    BOOL informationComplete = true;
 //    for (id key in info) {
 //        NSString *field = [info objectForKey:key];
 //        if (!field || !field.length) { // check completion
 //            informationComplete = NO;
 //            break;
 //        }
 //    }
 //    // Display an alert if a field wasn't completed
 //    if (!informationComplete) {
 //        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
 //    }
 //    return informationComplete;
 //}
 //
 //- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
 //    [self dismissViewControllerAnimated:true completion:nil];
 //    [self.navigationController popToRootViewControllerAnimated:true];
 //}
 //
 //- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
 //    NSLog(@"Failed to sign up...");
 //}
 //
 //- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
 //    NSLog(@"User dismissed the signUpViewController");
 //}



 */
@end
