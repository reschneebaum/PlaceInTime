//
//  UserInfo.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/27/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "UserInfo.h"

@implementation UserInfo

@dynamic name;
@dynamic trips;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"UserInfo";
}

@end
