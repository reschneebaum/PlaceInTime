//
//  ParseQueryManager.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/28/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
//#import "Trip.h"
#import "UserEvent.h"
#import "HistoryEvent.h"
#import "UserInfo.h"

@interface ParseQueryManager : NSObject

-(NSArray *)queryAndLoadEventsToMap:(MKMapView *)mapView forTrip:(Trip *)trip;

@end
