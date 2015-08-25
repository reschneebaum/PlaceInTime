//
//  HistoryEvent.h
//  PlaceInTime
//
//  Created by Quinn Harney on 8/21/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/Parse.h>

@interface HistoryEvent : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *textDescription;
@property float latitude;
@property float longitude;
@property UIColor *bgColor;

+(NSString *)parseClassName;

-(void)assignColor;

@end
