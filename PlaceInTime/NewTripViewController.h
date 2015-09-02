//
//  NewTripViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/26/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface NewTripViewController : UIViewController

@property CLLocation *userLocation;
@property Trip *trip;

@end
