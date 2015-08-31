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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    NSError *error = [NSError new];
    [self determineEventClassWithError:error];
    if (!error) {
        [self assignPointValues];
    } else {
        NSLog(@"uh oh");
    }
}

-(BOOL)determineEventClassWithError:(NSError *)error {
    if (self.userEvent != nil) {
        return self.isUserEvent;
    } else if (self.landmark != nil) {
        return self.isLandmark;
    } else if (self.histEvent) {
        return self.isHistoryEvent;
    } else {
        return error;
    }
}

-(void)assignPointValues {
    if (self.isUserEvent) {
        NSLog(@"%@", self.userEvent);
        self.descriptionTextView.text = self.userEvent.textDescription;
        self.navigationItem.title = self.userEvent.name;
        self.dateLabel.text = self.userEvent.date;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.userEvent.location.latitude longitude:self.userEvent.location.longitude];
        [self reverseGeocode:location];
    }
    if (self.isLandmark) {
        NSLog(@"%@", self.landmark);
        self.descriptionTextView.text = self.landmark.textDescription;
        self.navigationItem.title = self.landmark.name;
        self.dateLabel.text = self.landmark.date;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.landmark.latitude longitude:self.landmark.longitude];
        [self reverseGeocode:location];
    }
    if (self.isHistoryEvent) {
        NSLog(@"%@", self.histEvent);
        self.descriptionTextView.text = self.histEvent.textDescription;
        self.navigationItem.title = self.histEvent.name;
        self.dateLabel.text = self.histEvent.date;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.histEvent.location.latitude longitude:self.histEvent.location.longitude];
        [self reverseGeocode:location];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
