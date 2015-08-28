//
//  LoginViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/27/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "LoginViewController.h"
#import "RootViewController.h"
#import "SignupViewController.h"

@interface LoginViewController () <MKMapViewDelegate>

@property BOOL textFieldsComplete;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.89374, -87.63533), MKCoordinateSpanMake(0.5, 0.5)) animated:false];
    self.loginButton.enabled = false;
}

-(void)checkIfTextFieldsComplete {
    if ([self.usernameTextField hasText] && [self.passwordTextField hasText]) {
        self.textFieldsComplete = true;
    }
    if (self.textFieldsComplete == true) {
        self.loginButton.enabled = true;
    }
}

#pragma mark - Navigation
#pragma mark -

- (IBAction)onUsernameTextFieldChanged:(UITextField *)sender {
    [self checkIfTextFieldsComplete];
}

- (IBAction)onPasswordTextFieldChanged:(UITextField *)sender {
    [self checkIfTextFieldsComplete];
}

- (IBAction)onLoginButtonPressed:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"user - %@ logged in", user.username);
            RootViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"navVC"];
            [self presentViewController:rvc animated:true completion:nil];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (IBAction)onCreateAccountButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"createAccount" sender:self];
}

- (IBAction)onRetrievePasswordButtonPressed:(UIButton *)sender {
    NSLog(@"workin on it");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RootViewController *rvc = segue.destinationViewController;
    rvc.user = self.user;
}

@end
