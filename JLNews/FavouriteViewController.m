//
//  FavouriteViewController.m
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "FavouriteViewController.h"
#import "JLDatabase.h"
#import "JLProgressHUD.h"

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

- (NSArray <UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"不感兴趣" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        News *deleteNews = self.newsArray[indexPath.row];
        [[JLDatabase sharedManager] deleteNews:deleteNews success:^{
            [self.newsArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^{
            [[JLProgressHUD sharedProgressHUD] showMessage:@"删除失败,请重新操作" hideDelay:1.0];
        }];
    }];
    deleteAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
