//
//  LoginViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/18/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController

@property CLLocationCoordinate2D userEventLocation;
@property CLLocation *currentLocation;
@property BOOL userLoggedIn;

@end
