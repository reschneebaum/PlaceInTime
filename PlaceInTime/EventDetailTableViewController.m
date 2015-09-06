//
//  EventDetailTableViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/30/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import "AppDelegate.h"
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
@property (weak, nonatomic) IBOutlet UIButton *addPhotosButton;
@property NSManagedObjectContext *moc;

@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [self configureView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.userEvent.location.latitude longitude:self.userEvent.location.longitude];
    [self reverseGeocode:location];
    [self.navigationItem setTitle:self.userEvent.name];
    NSLog(@"%@", self.userEvent.name);
    self.addPhotosButton.hidden = true;
    self.collectionView.hidden = true;
}


-(void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark = placemarks.firstObject;
            NSString *address;
            if (placemark.subThoroughfare == nil) {
                if (placemark.thoroughfare == nil) {
                    address = [NSString stringWithFormat:@"%@, %@ %@", placemark.locality, placemark.administrativeArea, placemark.postalCode];
                } else {
                    address = [NSString stringWithFormat:@"%@, %@, %@ %@", placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
                }
            } else {
                address = [NSString stringWithFormat:@"%@ %@, %@, %@ %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
            }
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

//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    ALAsset *asset = self.assets[indexPath.row];
//    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
//    UIImage *image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
//    self.image = image;
//}

-(void)retrieveImageTimestamp {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gg_gps" ofType:@"jpg"];
    NSURL *imageFileURL = [NSURL fileURLWithPath:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)CFBridgingRetain(imageFileURL), NULL);
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache, nil];
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (CFDictionaryRef)CFBridgingRetain(options));
    CFDictionaryRef exifDic = CFDictionaryGetValue(imageProperties, kCGImagePropertyExifDictionary);
    if (exifDic){
        NSString *timestamp = (NSString *)CFBridgingRelease(CFDictionaryGetValue(exifDic, kCGImagePropertyExifDateTimeOriginal));
        if (timestamp){
            NSLog(@"timestamp: %@", timestamp);
            self.userEvent.imageString = timestamp;
        } else {
            NSLog(@"timestamp not found in the exif dic %@", exifDic);
        }
    } else {
        NSLog(@"exifDic nil for imageProperties %@",imageProperties);
    }
    CFRelease(imageProperties);
}

-(void)presentNoCameraAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"No camera available on device" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - UIImagePickerController methods
#pragma mark -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

//- (IBAction)selectPhoto:(UIButton *)sender {
//    UIImagePickerController *picker = [UIImagePickerController new];
//    picker.delegate = self;
//    picker.allowsEditing = NO;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:true completion:nil];
//}

@end
