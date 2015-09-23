//
//  Trip.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Trip.h"

@implementation Trip

@dynamic events;
@dynamic createdBy;
@dynamic name;
@dynamic date;
@dynamic dateString;
@dynamic imageString;
@dynamic locationString;
@dynamic location;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Trip";
}

+(void)queryTripsCreatedByCurrentUser:(NSArray *)trips {
    PFQuery *query = [Trip query];
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *tempTrips = [NSMutableArray new];
            NSLog(@"Successfully retrieved %lu trip(s).", (unsigned long)objects.count);
            for (Trip *trip in objects) {
                NSLog(@"%@", trip.objectId);
                [tempTrips addObject:trip];
            }
//            trips = [NSArray arrayWithArray:tempTrips];
//            NSLog(@"%@", trips.firstObject);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

+(void)queryCurrentTrip {

}

@end
