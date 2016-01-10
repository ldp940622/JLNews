//
//  JLNetworking.m
//  JLNews
//
//  Created by 李大鹏 on 15/11/16.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "JLNetworking.h"
NSString *const kServer = @"http://139.129.22.141/api/news";

@interface JLNetworking ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation JLNetworking

- (instancetype)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

// 单例
+ (JLNetworking *)sharedManager {
    static JLNetworking *sharedManager = nil;
    static dispatch_once_t onceToken;
    // GCD实现单例
    dispatch_once(&onceToken, ^{
        sharedManager = [[JLNetworking alloc] init];
    });
    return sharedManager;
}

- (void)requestWithURL:(NSString *)URLString
                method:(JLRequestMethod)method
             parameter:(NSDictionary *)parameter
               success:(void (^)(id))successBlock
               failure:(void (^)(NSError *))failureBlock {
    // 超时时间
    _manager.requestSerializer.timeoutInterval = 10.0;
    // 远程服务器
    // URLString = kServer;
    if (method == JLRequestGET) {
        [_manager GET:URLString
           parameters:parameter
              success:^(AFHTTPRequestOperation *operation,
                        id responseObject) {
            // 成功Block
            successBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation,
                    NSError *error) {
            // 错误Block
            failureBlock(error);
        }];
    } else if (method == JLRequestPOST) {
        [_manager POST:URLString
            parameters:parameter
               success:^(AFHTTPRequestOperation *operation,
                         id responseObject) {
            successBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation,
                    NSError *error) {
            failureBlock(error);
        }];
    }
}

@end
