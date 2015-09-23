//
//  Trip.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <Parse/Parse.h>

@interface Trip : PFObject<PFSubclassing>

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) PFUser *createdBy;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) PFGeoPoint *location;

+(NSString *)parseClassName;
+(void)queryCurrentTrip;
+(void)queryTripsCreatedByCurrentUser:(NSArray *)trips;

@end