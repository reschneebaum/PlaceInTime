//
//  TripsViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//
//  Map icon created by BraveBros. from Noun Project
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "TripsViewController.h"
#import "AddTripViewController.h"
#import "EventsViewController.h"
#import "LoginViewController.h"
#import "Trip.h"
#import "UserEvent.h"

@interface TripsViewController () <UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *tripLocations;
@property NSIndexPath *indexPath;

@end

@implementation TripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Logout"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logOutButtonTapAction:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.tripLocations = [NSMutableArray new];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //  display welcome prompt if user logged in
    if ([PFUser currentUser]) {
        self.navigationItem.prompt = [NSString stringWithFormat:NSLocalizedString(@"Welcome, %@!", nil), [[PFUser currentUser] username]];
    } else {
        NSLog(@"error");
    }
    //  retrieve trips created by current user & populate tableview
    [self assignAndRetrieveUserTrips];
}


-(void)assignAndRetrieveUserTrips {
    PFQuery *query = [Trip query];
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *tempTrips = [NSMutableArray new];
            NSLog(@"Successfully retrieved %lu trip(s).", (unsigned long)objects.count);
            for (Trip *trip in objects) {
                [tempTrips addObject:trip];
            }
            self.trips = [NSArray arrayWithArray:tempTrips];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


#pragma mark - UITableView DataSource & Delegate methods
#pragma mark -

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select a Trip:";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

    header.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:18];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    Trip *trip = self.trips[indexPath.row];
    cell.textLabel.text = trip.name;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
    cell.detailTextLabel.text = trip.dateString;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next" size:12];
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
    [self performSegueWithIdentifier:@"viewTrip" sender:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:160/255 green:205/255 blue:117/255 alpha:0.1];
        cell.backgroundColor = altCellColor;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //  present alert controller to confirm deletion
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Trip?" message:@"Are you sure you want to delete this trip and its associated events? This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete Trip" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //  delete trip from store
            Trip *deletedTrip = self.trips[indexPath.row];
            [deletedTrip deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //  find and delete all events that belong to deleted trip
                    PFQuery *deletedEventsQuery = [UserEvent query];
                    [deletedEventsQuery whereKey:@"belongsToTrip" equalTo:deletedTrip];
                    [deletedEventsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            NSMutableArray *deletedEvents = [NSMutableArray new];
                            NSLog(@"Successfully retrieved %lu event(s).", (unsigned long)objects.count);
                            for (UserEvent *event in objects) {
                                [deletedEvents addObject:event];
                            }
                            [UserEvent deleteAllInBackground:deletedEvents];
                        } else {
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];

            //  update tableview by removing trip from array
            [tableView beginUpdates];
            id tmp = [self.trips mutableCopy];
            [tmp removeObjectAtIndex:indexPath.row];
            self.trips = [tmp copy];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [tableView endUpdates];

            //  reload to preserve alternating cell colors
            [tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //  hide delete button
            tableView.editing = false;
        }];
        [alert addAction:cancelAction];
        [alert addAction:deleteAction];
        [self presentViewController:alert animated:true completion:nil];
    }
}


#pragma mark - Navigation
#pragma mark -

- (IBAction)logOutButtonTapAction:(UIBarButtonItem *)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logout" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    if ([segue.identifier isEqualToString:@"viewTrip"]) {
        EventsViewController *mapVC = segue.destinationViewController;
        mapVC.trip = self.trip;
    }
}

@end
