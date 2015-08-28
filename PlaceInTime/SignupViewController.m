//
//  SignupViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/27/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "RootViewController.h"
#import "UserInfo.h"

@interface SignupViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property PFUser *user;
@property BOOL textFieldsComplete;
@property BOOL passwordConfirmed;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.89374, -87.63533), MKCoordinateSpanMake(0.5, 0.5)) animated:false];
    self.signupButton.enabled = false;
}

-(void)checkForTextFieldsComplete {
    if ([self.usernameTextField hasText] && [self.passwordTextField hasText] && [self.confirmPasswordTextField hasText] && [self.emailTextField hasText] && [self.nameTextField hasText]) {
        self.textFieldsComplete = true;
    }
    if (self.textFieldsComplete == true) {
        [self.signupButton setEnabled:true];
    }
}

-(void)checkForConfirmedPassword {
    if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        self.passwordConfirmed = true;
    }
}

-(void)displayAlertWithErrorString:(NSString *)errorString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - Navigation
#pragma mark -

- (IBAction)onUsernameTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
}

- (IBAction)onPasswordTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
    [self checkForConfirmedPassword];
}

- (IBAction)onConfirmPasswordTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
    [self checkForConfirmedPassword];
}

- (IBAction)onEmailTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
}

- (IBAction)onNameTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
}


- (IBAction)onSignupButtonPressed:(UIButton *)sender {
    if (self.passwordConfirmed == false) {
        [self displayAlertWithErrorString:@"Please make sure your passwords are identical!"];
    } else {
        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"user - %@ logged in", user.username);
                UserInfo *userInfo = [UserInfo object];
                userInfo.name = self.nameTextField.text;
                [userInfo saveInBackgroundWithBlock:nil];
                NSLog(@"userinfo - %@ saved", userInfo.name);
                [self dismissViewControllerAnimated:true completion:nil];
//                [self.navigationController popViewControllerAnimated:true];

//                LoginViewController *lvc = [LoginViewController new];
//                [lvc dismissViewControllerAnimated:true completion:nil];
//                [self performSegueWithIdentifier:@"signup" sender:self];
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
    }
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"signup"]) {
//        LoginViewController *loginVC = segue.destinationViewController;
//        loginVC.usernameTextField.text = self.user.username;
//        loginVC.passwordTextField.text = self.user.password;
//        loginVC.mapView.region = self.mapView.region;
//        loginVC.user = self.userInfo;
//    }
//}


@end
