//
//  EventDetailTableViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/30/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "EventDetailTableViewController.h"

@interface EventDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property UserEvent *event;

@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.event.location.latitude longitude:self.event.location.longitude];
    [self reverseGeocode:location];
    [self.navigationItem setTitle:self.event.name];
    self.dateLabel.text = self.event.date;
    self.descriptionTextView.text = self.event.textDescription;
}


-(void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.lastObject;
        NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@ %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
        self.locationLabel.text = address;
    }];
}

#pragma mark - Table view data source
#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    switch (indexPath.row) {
        case 0: {
            NSLog(@"first cell");
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            self.locationLabel.text = self.event.locationString;
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            self.dateLabel.text = self.event.dateString;
            break;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
            NSLog(@"image gallery here eventually");
            break;
        }
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4"];
            NSLog(@"second cell");
            break;
        }
        case 4: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell5"];
            NSLog(@"second cell");
            break;
        }
        case 5: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell6"];
            NSLog(@"second cell");
            break;
        }
        default:
            break;
    }
    
    return cell;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
