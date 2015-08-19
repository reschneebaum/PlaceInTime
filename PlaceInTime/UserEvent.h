//
//  UserEvent.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/19/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserEvent : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *textDescription;
@property (nonatomic, strong) NSString *user;
@property int valence;
@property float latitude;
@property float longitude;
@property NSDate *date;

+(NSString *)parseClassName;

@end
