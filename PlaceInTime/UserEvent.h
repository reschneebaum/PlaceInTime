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
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *textDescription;
@property (nonatomic, strong) NSString *user;
@property float valence;
@property float latitude;
@property float longitude;

+(NSString *)parseClassName;

@end
