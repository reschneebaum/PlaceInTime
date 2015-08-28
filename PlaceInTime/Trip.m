//
//  Trip.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Trip.h"

@implementation Trip

@dynamic events;
@dynamic createdBy;
@dynamic name;
@dynamic date;
@dynamic location;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Trip";
}

@end
