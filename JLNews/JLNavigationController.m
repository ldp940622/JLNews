//
//  JLNavigationController.m
//  JLNews
//
//  Created by 李大鹏 on 15/11/19.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "JLNavigationController.h"
#define COLOR(R, G, B, A) ([UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A])

@interface JLNavigationController ()

@end

@implementation JLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationBar.barTintColor = COLOR(235, 146, 62, 1);
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
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

@end
