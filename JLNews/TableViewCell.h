//
//  TableViewCell.h
//  JLNews
//
//  Created by 李大鹏 on 15/10/25.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
