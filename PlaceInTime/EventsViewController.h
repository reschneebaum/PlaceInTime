//
//  ViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/17/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEvent.h"
#import "HistoryEvent.h"
#import "Landmark.h"
#import "Trip.h"

@interface EventsViewController : UIViewController

@property NSMutableArray *points;
@property Trip *trip;
@property Landmark *selectedLandmark;
@property UserEvent *selectedUserEvent;
@property HistoryEvent *selectedHistoryEvent;
@property CLLocation *mapLocation;

@end

