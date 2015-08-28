//
//  ParseQueryManager.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/28/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ParseQueryManager.h"
//#import "Trip.h"

@implementation ParseQueryManager

-(NSArray *)queryAndLoadEventsToMap:(MKMapView *)mapView forTrip:(Trip *)trip {
    NSMutableArray *temp = [NSMutableArray new];
    PFQuery *query = [UserEvent query];
    [query whereKey:@"belongsToTrip" equalTo:trip];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"successfully received %lu events", (unsigned long)objects.count);

            for (UserEvent *event in objects) {
                MKPointAnnotation *annot = [MKPointAnnotation new];
                annot.coordinate = CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude);
                annot.title = event.name;
                annot.subtitle = event.date;
                [mapView addAnnotation:annot];
                [temp addObject:event];
            }
        }
    }];
    NSArray *events = [NSArray arrayWithArray:temp];
    return events;
}

@end
