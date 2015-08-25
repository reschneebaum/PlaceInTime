//
//  HistoryEvent.m
//  PlaceInTime
//
//  Created by Quinn Harney on 8/21/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "HistoryEvent.h"
#import <Parse/PFObject+Subclass.h>

@implementation HistoryEvent

@dynamic name;
@dynamic textDescription;
@dynamic latitude;
@dynamic longitude;
@dynamic date;
@dynamic bgColor;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"HistoryEvent";
}

-(void)assignColor {
    if (self) {
        self.bgColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    }
}

@end

