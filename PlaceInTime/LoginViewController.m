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

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
    }];
    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];
}

- (IBAction)onTestButtonPress:(UIButton *)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddEventViewController *eventVC = segue.destinationViewController;
    eventVC.currentLocation = self.currentLocation;
}

@end