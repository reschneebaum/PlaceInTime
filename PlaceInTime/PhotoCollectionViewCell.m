//
//  PhotoCollectionViewCell.m
//  PlaceInTime
//
//  Created by Quinn Harney on 8/28/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

-(void)setAsset:(ALAsset *)asset {
    _asset = asset;
    self.photoImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}

@end
