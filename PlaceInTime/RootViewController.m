//
//  RootViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/24/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "RootViewController.h"
#import "EventsViewController.h"
#import "TripsViewController.h"
#import "AddTripViewController.h"
#import "LoginViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *options;
@property NSArray *segues;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.options = [[NSArray alloc] initWithObjects:@"View/Edit My Trips", @"Start a New Trip", @"Share Trips", @"Download Available Trips", nil];

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Logout"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(logOutButtonTapAction:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([PFUser currentUser]) {
        self.navigationItem.prompt = [NSString stringWithFormat:NSLocalizedString(@"Welcome, %@!", nil), [[PFUser currentUser] username]];
    } else {
        NSLog(@"error");
    }
}

#pragma mark - UITableView Data Source methods
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    NSArray *segues = @[@"myTrips", @"newTrip", @"sharedTrips", @"downloadTrips"];
    [self performSegueWithIdentifier:segues[indexPath.row] sender:self.navigationController];
}


#pragma mark - Navigation
#pragma mark -

- (IBAction)logOutButtonTapAction:(UIBarButtonItem *)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"%@", [PFUser currentUser]);
        [self performSegueWithIdentifier:@"logout" sender:self];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newTrip"]) {
        AddTripViewController *avc = segue.destinationViewController;
        avc.user = self.user;
    } else if ([segue.identifier isEqualToString:@"logout"]) {
        LoginViewController *lvc = segue.destinationViewController;
    } else {
        TripsViewController *tvc = segue.destinationViewController;
        tvc.user = self.user;
    }
}

@end
