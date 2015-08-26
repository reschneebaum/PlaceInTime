//
//  ViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/17/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEvent.h"

@interface EventsViewController : UIViewController

@property UserEvent *event;
@property NSMutableArray *points;

@end

