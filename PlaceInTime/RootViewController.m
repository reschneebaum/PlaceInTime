//
//  RootViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/24/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "RootViewController.h"
#import "EventsViewController.h"
#import "TripsViewController.h"
#import "AddTripViewController.h"
#import "LoginViewController.h"

@interface RootViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSArray *options;
@property NSArray *segues;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.options = [[NSArray alloc] initWithObjects:@"View/Edit My Trips", @"Start a New Trip", @"Share Trips", @"Download Available Trips", nil];

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Logout"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(logOutButtonTapAction:)];

    self.navigationItem.rightBarButtonItem = logoutButton;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    if ([PFUser currentUser]) {
//        self.navigationItem.prompt = [NSString stringWithFormat:NSLocalizedString(@"Welcome, %@!", nil), [[PFUser currentUser] username]];
//    } else {
//        NSLog(@"error");
//    }
//}
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


#pragma mark - UITableView Data Source methods
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *segues = @[@"myTrips", @"newTrip", @"sharedTrips", @"downloadTrips"];
    [self performSegueWithIdentifier:segues[indexPath.row] sender:nil];
}


#pragma mark - Navigation
#pragma mark -

- (IBAction)logOutButtonTapAction:(UIBarButtonItem *)sender {
    [PFUser logOut];
//    LoginViewController *login = [LoginViewController new];
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"%@", [PFUser currentUser]);
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newTrip"]) {
        AddTripViewController *avc = segue.destinationViewController;
        avc.user = self.user;
    } else {
        TripsViewController *tvc = segue.destinationViewController;
        tvc.user = self.user;
    }
}

@end
