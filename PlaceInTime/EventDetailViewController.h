//
//  EventDetailViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/21/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEvent.h"
#import "HistoryEvent.h"
#import "Landmark.h"

@interface EventDetailViewController : UIViewController

@property CLLocationCoordinate2D location;
@property Landmark *landmark;
@property HistoryEvent *histEvent;
@property UserEvent *userEvent;
@property BOOL isLandmark;
@property BOOL isUserEvent;
@property BOOL isHistoryEvent;

@end
