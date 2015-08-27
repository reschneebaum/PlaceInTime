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
@property BOOL userExists;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void)checkIfUserExistsFromUsername:(NSString *)username andPassword:(NSString *)password {
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"username" equalTo:username];
    [userQuery whereKey:@"password" equalTo:password];
    NSArray *users = [userQuery findObjects];
    if (users.count == 1) {
        self.userExists = true;
    } else if (users.count < 1) {
        NSLog(@"user doesn't exist!");
        [self displayAlertWithErrorString:@"Username and password are incorrect."];
    } else {
        NSLog(@"uh oh, multiple users?");
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

- (IBAction)onLoginButtonPressed:(UIButton *)sender {
}

- (IBAction)onCreateAccountButtonPressed:(UIButton *)sender {
}

- (IBAction)onRetrievePasswordButtonPressed:(UIButton *)sender {
}

@end
