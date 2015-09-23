//
//  TripsViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "UserInfo.h"

@interface TripsViewController : UIViewController

@property NSArray *trips;
@property Trip *trip;
@property UserInfo *user;

@end
