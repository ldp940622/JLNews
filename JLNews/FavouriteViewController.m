//
//  FavouriteViewController.m
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "FavouriteViewController.h"
#import "JLDatabase.h"

@interface FavouriteViewController ()

@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData {
    NSArray *arr = [[JLDatabase sharedManager] getStarNews];
    for (NSDictionary *dic in arr) {
        [self.newsArray addObject:[News newsWithDict:dic]];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

@end
