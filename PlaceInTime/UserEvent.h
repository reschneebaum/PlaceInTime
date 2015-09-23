//
//  UserEvent.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/19/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <Parse/Parse.h>
#import "Trip.h"

@interface UserEvent : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *textDescription;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) Trip *belongsToTrip;
@property float valence;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) NSString *imageString;

+(NSString *)parseClassName;

@end
