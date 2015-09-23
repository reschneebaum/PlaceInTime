//
//  Route.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/31/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Route.h"

@implementation Route

@dynamic createdBy;
@dynamic startingLatitude;
@dynamic startingLongitude;
@dynamic destinationLatitude;
@dynamic destinationLongitude;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Route";
}

@end
