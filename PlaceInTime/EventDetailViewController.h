//
//  EventDetailViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/21/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEvent.h"

@interface EventDetailViewController : UIViewController

@property CLLocationCoordinate2D location;
@property NSArray *landmarks;
@property UserEvent *point;

@end
