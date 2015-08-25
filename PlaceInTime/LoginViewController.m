//
//  LoginViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/18/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <TwitterKit/TwitterKit.h>
#import "LoginViewController.h"
#import "AddEventViewController.h"
#import "EventsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.userLoggedIn = NO;

    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                NSLog(@"signed in as %@", [session userName]);
                self.userLoggedIn = true;
                [self checkForLoggedInUser];
                NSLog(@"%i", self.userLoggedIn);
                [self dismissViewControllerAnimated:true completion:nil];
            } else {
                NSLog(@"error: %@", [error localizedDescription]);
                self.userLoggedIn = false;
            }
        }];
    }];
    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];
}

-(void)checkForLoggedInUser {
    [self.delegate isUserLoggedIn:self.userLoggedIn];
}

@end