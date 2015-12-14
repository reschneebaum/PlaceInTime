//
//  AddEventViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/18/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEvent.h"
#import "Trip.h"

@interface AddEventViewController : UIViewController <UITextFieldDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property CLLocationCoordinate2D location;
@property UserEvent *event;
@property Trip *trip;

@end
