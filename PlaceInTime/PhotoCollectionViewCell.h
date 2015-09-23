//
//  PhotoCollectionViewCell.h
//  PlaceInTime
//
//  Created by Quinn Harney on 8/28/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,weak) IBOutlet UIImageView *photoImageView;

@end
