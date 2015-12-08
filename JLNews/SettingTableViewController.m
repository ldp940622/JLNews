//
//  SettingTableViewController.m
//  JLNews
//
//  Created by 李大鹏 on 15/12/2.
//  Copyright © 2015年 Ldp. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()
@property (copy, nonatomic) NSMutableArray *array;
@property (assign, nonatomic) BOOL isOpen;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [NSMutableArray arrayWithObjects:@"正文字体", @"正文字号", @"关键字过滤", nil];
    _isOpen = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"settingCell";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:indentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.textLabel.text = _array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 100.0f;
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if (!_isOpen) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
            [_array addObject:@"我是新增加的cell"];
            [tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationFade]	;
            _isOpen = YES;
        } else {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
            [_array removeObject:@"我是新增加的cell"];
            [tableView deleteRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            _isOpen = NO;
        }
    }
}

@end
