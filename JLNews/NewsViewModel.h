//
//  NewsViewModel.h
//  JLNews
//
//  Created by 李大鹏 on 15/12/5.
//  Copyright © 2015年 Ldp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ReturnNewsArrayBlock)(NSMutableArray *newsArray);
typedef void (^ReturnFailureBlock)(NSString *errorMsg);

@interface NewsViewModel : NSObject

@property (copy, nonatomic) ReturnNewsArrayBlock returnNewsArrayBlock;
@property (copy, nonatomic) ReturnFailureBlock returnFailureBlock;

- (void)getAllNews;
- (void)getAllNewsWithParameter:(NSDictionary *)parameter;

- (void)getReturnBlockWithSuccess:(ReturnNewsArrayBlock)success andFailure:(ReturnFailureBlock)failure;

@end
