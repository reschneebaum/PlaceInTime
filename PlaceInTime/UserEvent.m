//
//  UserEvent.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/19/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "UserEvent.h"

@implementation UserEvent

@dynamic name;
@dynamic textDescription;
@dynamic user;
@dynamic valence;
@dynamic date;
@dynamic dateString;
@dynamic belongsToTrip;
@dynamic location;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"UserEvent";
}

@end
