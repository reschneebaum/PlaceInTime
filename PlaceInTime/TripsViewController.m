//
//  TripsViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "TripsViewController.h"

@interface TripsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.trips = [NSArray new];

}

#pragma mark - UITableViewDataSource methods
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    return cell;
}


#pragma mark - Navigation
#pragma mark -

@end
