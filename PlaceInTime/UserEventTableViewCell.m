//
//  UserEventTableViewCell.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/25/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import "UserEventTableViewCell.h"

@implementation UserEventTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:0.70 green:0.74 blue:0.80 alpha:1];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
}

@end
