//
//  NewsViewModel.m
//  JLNews
//
//  Created by 李大鹏 on 15/12/5.
//  Copyright © 2015年 Ldp. All rights reserved.
//

#import "NewsViewModel.h"
#import "JLNetworking.h"
#import "News.h"

@implementation NewsViewModel

- (void)getAllNews {
    [self getAllNewsWithParameter:nil];
}

- (void)getAllNewsWithParameter:(NSDictionary *)parameter {
    [[JLNetworking sharedManager] requestWithURL:@"http://127.0.0.1:25000/api/news" method:JLRequestGET parameter:parameter success:^(id responseObject) {
        [self processSuccessNewsArray:[responseObject objectForKey:@"objects"]];
    } failure:^(NSError *error) {
        self.returnFailureBlock(error.localizedDescription);
    }];
}

- (void)processSuccessNewsArray:(NSArray *)newsArray {
    NSMutableArray *newsMutablArray = [NSMutableArray arrayWithArray:@[]];
    for (NSDictionary *newsDic in newsArray) {
        News *news = [News newsWithDict:newsDic];
        [newsMutablArray addObject:news];
    }
    self.returnNewsArrayBlock(newsMutablArray);
}

- (void)getReturnBlockWithSuccess:(ReturnNewsArrayBlock)success andFailure:(ReturnFailureBlock)failure {
    _returnNewsArrayBlock = success;
    _returnFailureBlock = failure;
}

@end
