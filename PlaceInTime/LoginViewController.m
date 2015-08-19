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
#import "MapViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                NSLog(@"signed in as %@", [session userName]);
                self.userLoggedIn = true;
//                self.userLoggedIn = true;
//                MapViewController *mapVC = [MapViewController new];
//                mapVC.userLoggedIn = self.userLoggedIn;
//                NSLog(@"%i", mapVC.userLoggedIn);
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

-(IBAction)onMapViewPressed:(UILongPressGestureRecognizer *)sender {
    if (self.userLoggedIn) {
        [self.delegate loginViewController:self willRecognizeLongPress:sender];
    }
}

@end