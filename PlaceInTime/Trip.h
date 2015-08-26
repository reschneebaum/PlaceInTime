//
//  Trip.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/Parse.h>

@interface Trip : PFObject<PFSubclassing>

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) PFUser *createdBy;
@property (nonatomic, strong) NSString *name;
@property float latitude;
@property float longitude;


+(NSString *)parseClassName;

@end