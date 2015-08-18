//
//  UserEvent.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/18/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Event : NSObject

@property NSString *name;
@property NSString *textDescription;
@property NSString *valence;
@property NSString *userID;
@property CLLocationCoordinate2D locationCoordinate;

@end
