//
//  HistoryCollectionViewCell.m
//  JLNews
//
//  Created by 李大鹏 on 15/12/4.
//  Copyright © 2015年 Ldp. All rights reserved.
//

#import "HistoryCollectionViewCell.h"

@implementation HistoryCollectionViewCell
- (void)awakeFromNib {
}

- (void)layoutSubviews {
    _historyLabel.layer.masksToBounds = YES;
    _historyLabel.layer.borderWidth = 0.5f;
    _historyLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _historyLabel.layer.cornerRadius = 5.0f;
}

@end
