//
//  UserEventAnnotation.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 9/1/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "UserEvent.h"

@interface UserEventAnnotation : MKPointAnnotation

@property int valence;
@property UserEvent *event;

@end
