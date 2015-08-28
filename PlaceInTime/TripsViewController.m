//
//  TripsViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "TripsViewController.h"
#import "EventsViewController.h"
#import "LoginViewController.h"
#import "Trip.h"

@interface TripsViewController () <UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *tripLocations;
@property NSIndexPath *indexPath;

@end

@implementation TripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self assignAndRetrieveUserTrips];

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Logout"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logOutButtonTapAction:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    self.tripLocations = [NSMutableArray new];
}


-(void)assignAndRetrieveUserTrips {
    PFQuery *query = [Trip query];
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *tempTrips = [NSMutableArray new];
            NSLog(@"Successfully retrieved %lu trip(s).", (unsigned long)objects.count);
            for (Trip *trip in objects) {
                NSLog(@"%@", trip.objectId);
                [tempTrips addObject:trip];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:trip.latitude longitude:trip.longitude];
                [self.tripLocations addObject:location];
            }
            self.trips = [NSArray arrayWithArray:tempTrips];
            [self.tableView reloadData];
            NSLog(@"%@", self.trips.firstObject);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


#pragma mark - UITableViewDataSource methods
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [self.trips[indexPath.row]name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.trip = self.trips[indexPath.row];
    NSLog(@"%f", self.trip.latitude);
    self.indexPath = indexPath;
    EventsViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
    [self.navigationController pushViewController:mapVC animated:true];
//    EventsViewController *mapVC = [EventsViewController new];
//    mapVC.trip = self.trip;
//    NSLog(@"%f", mapVC.trip.latitude);
}

- (IBAction)logOutButtonTapAction:(UIBarButtonItem *)sender {
    [PFUser logOut];
    LoginViewController *login = [LoginViewController new];
    [self presentViewController:login animated:true completion:nil];
}


#pragma mark - Navigation
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EventsViewController *mapVC = segue.destinationViewController;
    mapVC.location = self.tripLocations[self.indexPath.row];
    mapVC.trip = self.trip;
}

@end
