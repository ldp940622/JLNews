//
//  BaseViewController.h
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "MJRefresh.h"
#import "UITabBar+Extension.h"

@interface BaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *newsArray;

- (void)loadNewData;
@end
