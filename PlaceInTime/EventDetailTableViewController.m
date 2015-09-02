//
//  EventDetailTableViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/30/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "EventDetailTableViewController.h"
#import "PhotoCollectionViewCell.h"

@interface EventDetailTableViewController () <UICollectionViewDataSource, UICollectionViewDelegate
, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *assets;
@property UIImage *image;

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

    _assets = [@[]mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    ALAssetsLibrary *assetsLibrary = [EventDetailTableViewController defaultAssetLibrary];

    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [tmpAssets addObject:result];
            }
        }];

        self.assets = tmpAssets;
        [self.collectionView reloadData];

    } failureBlock:^(NSError *error) {
        NSLog(@" Error Loading images");
        
    }];
}


-(void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark = placemarks.firstObject;

            NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@ %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];

//            NSString *addressString = @"";
//
//            if (placemark.subThoroughfare != nil) {
//                 addressString = [NSString stringWithFormat:@"%@", placemark.subThoroughfare];
//            } else {
//                NSLog(@"placemark.subThoroughfare is nil");
//            }
//
//            if (placemark.thoroughfare != nil) {
//                [addressString stringByAppendingFormat:@" %@", placemark.thoroughfare];
//            } else {
//                NSLog(@"placemark.thoroughfare is nil");
//            }
//
//            if (placemark.locality) {
//
//            }


            self.locationLabel.text = address;
        } else {
            NSLog(@"Error while in reverseGeocode: %@", error.localizedDescription);
        }

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

#pragma mark - collection view data source
#pragma mark -

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (PhotoCollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];

    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    cell.backgroundColor = [UIColor blackColor];
    cell.photoImageView.image = self.image;

    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ALAsset *asset = self.assets[indexPath.row];
    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    UIImage *image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
    self.image = image;
}

+ (ALAssetsLibrary *)defaultAssetLibrary{
    static dispatch_once_t pred;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc]init];
    });

    return library;

}

- (IBAction)onAddImageTapped:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO) {
        return;
    }

    UIImagePickerController *mediaUI = [[UIImagePickerController alloc]init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];

    [self dismissViewControllerAnimated:YES completion:^{
        self.image = image;
        PhotoCollectionViewCell *cell = [PhotoCollectionViewCell new];
        cell.photoImageView.image = self.image;
    }];
}

@end
