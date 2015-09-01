//
//  EventDetailTableViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/30/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "EventDetailTableViewController.h"

@interface EventDetailTableViewController ()

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.userEvent.name);

    [self configureView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.userEvent.location.latitude longitude:self.userEvent.location.longitude];
    [self reverseGeocode:location];
    [self.navigationItem setTitle:self.userEvent.name];
    NSLog(@"%@", self.userEvent.name);
}


-(void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@ %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
        self.locationLabel.text = address;
    }];
}

-(void)configureView {
    self.dateLabel.text = self.userEvent.date;
    self.descriptionTextView.text = self.userEvent.textDescription;

}

#pragma mark - Table view data source
#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
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
