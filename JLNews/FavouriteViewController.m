//
//  FavouriteViewController.m
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "FavouriteViewController.h"

@interface FavouriteViewController ()

@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_footer = nil;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * #pragma mark - Navigation
 *
 * // In a storyboard-based application, you will often want to do a little preparation before navigation
 * - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *  // Get the new view controller using [segue destinationViewController].
 *  // Pass the selected object to the new view controller.
 * }
 */

- (void)loadNewData {
    NSArray *arr = [[JLDatabase sharedManager] getStarNews];
    for (NSDictionary *dic in arr) {
        [self.newsArr addObject:[News newsWithDict:dic]];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

@end
