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
#import "TableViewCell.h"
#import "ImageTableViewCell.h"

@implementation ViewController

#pragma mark - Life Cycle
- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsArr = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.newsArr removeAllObjects];
        [weakSelf loadNewData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        News *lastNews = weakSelf.newsArr.lastObject;
        [weakSelf getMoreNewsFromID:lastNews.newsID];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@", @2);
    return _newsArr.count;
    //    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    News *news;
    @try {
        news = _newsArr[indexPath.row];
    }
    @catch (NSException *exception)
    {
        NULL;
    }
    //    News *news = _newsArr[indexPath.row];
    TableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    imageCell.myImageView.image = [UIImage imageNamed:@"NewsNoImage.png"];
    if (news.imageArr.count == 0) {
        if (!myCell) {
            myCell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        }
        myCell.titleLabel.text = news.title;
        myCell.contentLabel.text = news.newsDiscription;
        return myCell;
    } else {
        if (!imageCell) {
            imageCell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        }
        imageCell.titleLabel.text = news.title;
        imageCell.contentLabel.text = news.newsDiscription;
        [imageCell.myImageView sd_setImageWithURL:[NSURL URLWithString:news.imageArr[0]]
                                 placeholderImage:[UIImage imageNamed:@"NewsNoImage.png"]];
        return imageCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    newsVC.news = _newsArr[indexPath.row];
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        __weak typeof(self) weakSelf = self;
        [[JLDatabase sharedManager] insertNews:weakSelf.newsArr[indexPath.row] success:^{
            [[JLProgressHUD sharedProgressHUD] showMessage:@"收藏成功" hideDelay:1.0];
        } failure:^{
            [[JLProgressHUD sharedProgressHUD] showMessage:@"收藏失败" hideDelay:1.0];
        }];
    }];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"不感兴趣" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [_newsArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    starAction.backgroundColor = [UIColor orangeColor];
    deleteAction.backgroundColor = [UIColor grayColor];
    return @[starAction, deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Public Method
- (void)loadNewData {
    NSString *filter = @"{\"order_by\":[{\"field\":\"id\",\"direction\":\"desc\"}],\"limit\":10,\"offset\":0}";
    NSDictionary *parameter = @{ @"q" : filter };
    __weak typeof(self) weakSelf = self;
    
    [[JLNetworking sharedManager] requestWithURL:@"http://192.168.1.106:25000/api/news" method:JLRequestGET parameter:parameter success:^(id responseObject) {
        //        [weakSelf.newsArr removeAllObjects];
        for (NSDictionary *dic in[responseObject objectForKey:@"objects"]) {
            News *news = [News newsWithDict:dic];
            [self.newsArr addObject:news];
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
    
    [[JLNetworking sharedManager] requestWithURL:@"http://192.168.1.106:25000/api/news" method:JLRequestGET parameter:parameter success:^(id responseObject) {
        for (NSDictionary *dic in[responseObject objectForKey:@"objects"]) {
            News *news = [News newsWithDict:dic];
            [weakSelf.newsArr addObject:news];
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
