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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select a trip to view, add, or edit personal events, locations, and routes";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Trip *trip = self.trips[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", trip.locationString];
    cell.detailTextLabel.text = trip.dateString;
    if (trip.imageString != nil) {
        cell.imageView.image = [UIImage imageNamed:trip.imageString];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"path_map"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    self.trip = self.trips[indexPath.row];
    NSLog(@"tableview, tripsVC: %@", self.trip.location);
    [self performSegueWithIdentifier:@"viewTrip" sender:self];
//    EventsViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
//    mapVC.trip = self.trip;
//    [self.navigationController pushViewController:mapVC animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:160/255 green:205/255 blue:117/255 alpha:0.1];
        cell.backgroundColor = altCellColor;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
}

- (IBAction)logOutButtonTapAction:(UIBarButtonItem *)sender {
    [PFUser logOut];
    LoginViewController *login = [LoginViewController new];
    [self presentViewController:login animated:true completion:nil];
}


#pragma mark - Navigation
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    if ([segue.identifier isEqualToString:@"viewTrip"]) {
        EventsViewController *mapVC = segue.destinationViewController;
        mapVC.trip = self.trip;
    }
}

@end
