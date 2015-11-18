//
//  BaseViewController.m
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "BaseViewController.h"
#import "MJRefresh.h"
#import "TableViewCell.h"
#import "ImageTableViewCell.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - Life Cycle
- (void)loadView {
    [super loadView];
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsArray = [[NSMutableArray alloc] init];
    [self.tableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
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
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    News *news;
    @try {
        news = self.newsArray[indexPath.row];
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
    newsVC.news = self.newsArray[indexPath.row];
    [self.navigationController pushViewController:newsVC animated:YES];
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
}

@end
