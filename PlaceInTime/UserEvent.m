//
//  UserEvent.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/19/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "UserEvent.h"
#import <Parse/PFObject+Subclass.h>

@implementation UserEvent

@dynamic name;
@dynamic textDescription;
@dynamic user;
@dynamic valence;
@dynamic latitude;
@dynamic longitude;
@dynamic date;
@dynamic bgColor;
@dynamic belongsToTrip;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"UserEvent";
}

-(void)assignColor {
    if (self) {
        self.bgColor = [UIColor colorWithRed:0.70 green:0.76 blue:0.85 alpha:1];
    }
}

@end
