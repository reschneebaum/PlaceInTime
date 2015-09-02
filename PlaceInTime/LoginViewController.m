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

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property BOOL textFieldsComplete;
@property (weak, nonatomic) IBOutlet UIButton *passwordButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.89374, -87.63533), MKCoordinateSpanMake(0.5, 0.5)) animated:false];
//    [self customizeButton:self.passwordButton];
//    [self customizeButton:self.createAccountButton];
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

-(void)customizeButton:(UIButton *)button {
    button.titleLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
    button.titleLabel.textColor = [UIColor colorWithRed:143/255 green:181/255 blue:191/255 alpha:1.0];
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [[UIColor colorWithRed:143/255 green:181/255 blue:191/255 alpha:1.0] CGColor];
    button.layer.cornerRadius = 5.0;
    button.layer.backgroundColor = [[UIColor whiteColor] CGColor];
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
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"navVC"];
            [self presentViewController:navVC animated:true completion:nil];
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
    [PFUser requestPasswordResetForEmailInBackground:@"email@example.com"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"login"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        RootViewController *rvc = (RootViewController *)navigationController.topViewController;
        rvc.user = self.user;
    }
}

-(IBAction)unwindOnCancel:(UIStoryboardSegue *)segue {
}

-(IBAction)unwindOnLogout:(UIStoryboardSegue *)segue {
}

@end
