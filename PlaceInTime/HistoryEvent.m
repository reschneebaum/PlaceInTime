//
//  HistoryEvent.m
//  PlaceInTime
//
//  Created by Quinn Harney on 8/21/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "HistoryEvent.h"

@implementation HistoryEvent

@dynamic name;
@dynamic textDescription;
@dynamic latitude;
@dynamic longitude;
@dynamic date;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"HistoryEvent";
}

@end

