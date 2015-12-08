//
//  ViewController.m
//  JLNews
//
//  Created by 李大鹏 on 15/10/25.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"
#import "JLDatabase.h"
#import "TableViewCell.h"
#import "ImageTableViewCell.h"
#import "JLProgressHUD.h"
#import "SearchViewController.h"
#import "NewsViewModel.h"

@interface ViewController ()
@property (strong, nonatomic) NewsViewModel *viewModel;
@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)loadView {
    [super loadView];
    _viewModel = [[NewsViewModel alloc] init];
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        News *lastNews = weakSelf.newsArray.lastObject;
        [weakSelf getMoreNewsFromID:lastNews.newsID];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Method @Override

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        __weak typeof(self) weakSelf = self;
        [[JLDatabase sharedManager] insertNews:weakSelf.newsArray[indexPath.row] success:^{
            [self.tabBarController.tabBar showBadgeAtIndex:1];
            [[JLProgressHUD sharedProgressHUD] showMessage:@"收藏成功" hideDelay:1.0];
        } failure:^{
            [[JLProgressHUD sharedProgressHUD] showMessage:@"收藏失败" hideDelay:1.0];
        }];
        [tableView setEditing:NO animated:YES];
    }];
    starAction.backgroundColor = [UIColor orangeColor];
    return @[starAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![[JLDatabase sharedManager] newsIsExist:self.newsArray[indexPath.row]];
}

#pragma mark - Public Method
- (void)loadNewData {
    NSString *filter = @"{\"order_by\":[{\"field\":\"id\",\"direction\":\"desc\"}],\"limit\":10,\"offset\":0}";
    NSDictionary *parameter = @{ @"q" : filter };
    __weak typeof(self) weakSelf = self;
    
    [_viewModel getAllNewsWithParameter:parameter];
    [_viewModel getReturnBlockWithSuccess:^(NSMutableArray *newsArray) {
        weakSelf.newsArray = newsArray;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } andFailure:^(NSString *errorMsg) {
        [[JLProgressHUD sharedProgressHUD] showMessage:errorMsg hideDelay:1.0];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Private Method
- (void)getMoreNewsFromID:(NSNumber *)newsID {
    NSString *filter = [NSString stringWithFormat:@"{\"order_by\":[{\"field\":\"id\",\"direction\":\"desc\"}],\"filters\":[{\"name\":\"id\",\"op\":\"lt\",\"val\":%@}],\"limit\":10,\"offset\":0}", newsID];
    NSDictionary *parameter = @{ @"q" : filter };
    __weak typeof(self) weakSelf = self;
    
    [_viewModel getAllNewsWithParameter:parameter];
    [_viewModel getReturnBlockWithSuccess:^(NSMutableArray *newsArray) {
        [weakSelf.newsArray addObjectsFromArray:newsArray];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } andFailure:^(NSString *errorMsg) {
        [[JLProgressHUD sharedProgressHUD] showMessage:errorMsg hideDelay:1.0];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

@end
