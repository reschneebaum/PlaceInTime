//
//  LoginViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/18/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EventsViewController.h"

@protocol LoginViewControllerDelegate <NSObject>

-(void)isUserLoggedIn:(BOOL)userLoggedIn;

@end

@interface LoginViewControllerOld : UIViewController

@property (nonatomic, assign) id <LoginViewControllerDelegate> delegate;
@property CLLocationCoordinate2D userEventLocation;
@property CLLocation *currentLocation;
@property BOOL userLoggedIn;

@end
