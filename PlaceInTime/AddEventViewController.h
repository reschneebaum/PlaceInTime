//
//  AddEventViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/18/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddEventViewController : UIViewController

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property PFObject *event;

@end
