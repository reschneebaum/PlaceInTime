//
//  Route.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/31/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <Parse/Parse.h>

@interface Route : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *createdBy;
@property float startingLatitude;
@property float startingLongitude;
@property float destinationLatitude;
@property float destinationLongitude;

+(NSString *)parseClassName;

@end
