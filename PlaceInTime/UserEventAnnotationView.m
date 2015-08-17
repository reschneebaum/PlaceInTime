//
//  UserEventAnnotationView.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/17/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "UserEventAnnotationView.h"

@implementation UserEventAnnotationView

- (void)setEventEmotionValence {
    if ([self.valence isEqualToString:@"1"]) {
        NSLog(@"will set pin to blue color");
    } else if ([self.valence isEqualToString:@"2"]) {
        NSLog(@"will set pin to green color");
    } else if ([self.valence isEqualToString:@"3"]) {
        NSLog(@"will set pin to yellow color");
    } else if ([self.valence isEqualToString:@"4"]) {
        NSLog(@"will set pin to orange color");
    } else if ([self.valence isEqualToString:@"5"]) {
        NSLog(@"will set pin to red color");
    }
}

@end
