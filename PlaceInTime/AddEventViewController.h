//
//  AddEventViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/18/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEvent.h"

@interface AddEventViewController : UIViewController

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property UserEvent *event;
@property CLLocationCoordinate2D location;

@end
