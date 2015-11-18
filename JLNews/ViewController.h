//
//  ViewController.h
//  JLNews
//
//  Created by 李大鹏 on 15/10/25.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsViewController.h"
#import "MJRefresh.h"
#import "JLDatabase.h"
#import "JLProgressHUD.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *newsArr;

- (void)loadNewData;
@end
