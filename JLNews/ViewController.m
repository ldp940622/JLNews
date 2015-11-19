//
//  ViewController.m
//  JLNews
//
//  Created by 李大鹏 on 15/10/25.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"
#import "JLNetworking.h"
#import "JLDatabase.h"
#import "TableViewCell.h"
#import "ImageTableViewCell.h"
#import "JLProgressHUD.h"

@implementation ViewController

#pragma mark - Life Cycle
- (void)loadView {
    [super loadView];
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
    NSMutableArray *actionArray = [NSMutableArray array];
    if (![[JLDatabase sharedManager] newsIsExist:self.newsArray[indexPath.row]]) {
        UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            __weak typeof(self) weakSelf = self;
            [[JLDatabase sharedManager] insertNews:weakSelf.newsArray[indexPath.row] success:^{
                [[JLProgressHUD sharedProgressHUD] showMessage:@"收藏成功" hideDelay:1.0];
            } failure:^{
                [[JLProgressHUD sharedProgressHUD] showMessage:@"收藏失败" hideDelay:1.0];
            }];
            [tableView setEditing:NO animated:YES];
        }];
        starAction.backgroundColor = [UIColor orangeColor];
        [actionArray addObject:starAction];
    }
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"不感兴趣" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.newsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    [actionArray addObject:deleteAction];
    deleteAction.backgroundColor = [UIColor grayColor];
    return actionArray;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Public Method
- (void)loadNewData {
    NSString *filter = @"{\"order_by\":[{\"field\":\"id\",\"direction\":\"desc\"}],\"limit\":10,\"offset\":0}";
    NSDictionary *parameter = @{ @"q" : filter };
    __weak typeof(self) weakSelf = self;
    
    [[JLNetworking sharedManager] requestWithURL:@"http://127.0.0.1:25000/api/news" method:JLRequestGET parameter:parameter success:^(id responseObject) {
        //        [weakSelf.newsArr removeAllObjects];
        for (NSDictionary *dic in[responseObject objectForKey:@"objects"]) {
            News *news = [News newsWithDict:dic];
            [self.newsArray addObject:news];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [[JLProgressHUD sharedProgressHUD] showMessage:@"网络出错,请重试." hideDelay:1.0];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Private Method
- (void)getMoreNewsFromID:(NSNumber *)newsID {
    NSString *filter = [NSString stringWithFormat:@"{\"order_by\":[{\"field\":\"id\",\"direction\":\"desc\"}],\"filters\":[{\"name\":\"id\",\"op\":\"lt\",\"val\":%@}],\"limit\":10,\"offset\":0}", newsID];
    NSDictionary *parameter = @{ @"q" : filter };
    __weak typeof(self) weakSelf = self;
    
    [[JLNetworking sharedManager] requestWithURL:@"http://127.0.0.1:25000/api/news" method:JLRequestGET parameter:parameter success:^(id responseObject) {
        for (NSDictionary *dic in[responseObject objectForKey:@"objects"]) {
            News *news = [News newsWithDict:dic];
            [weakSelf.newsArray addObject:news];
        }
        NSLog(@"%@", [NSThread currentThread]);
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [[JLProgressHUD sharedProgressHUD] showMessage:@"网络出错,请重试." hideDelay:1.0];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

@end
