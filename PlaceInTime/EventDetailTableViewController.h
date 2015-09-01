//
//  EventDetailTableViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/30/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEvent.h"
#import "HistoryEvent.h"
#import "Landmark.h"
#import "Trip.h"

@interface EventDetailTableViewController : UITableViewController

@property CLLocationCoordinate2D location;
@property Landmark *landmark;
@property HistoryEvent *histEvent;
@property UserEvent *userEvent;
@property Trip *trip;

@end
