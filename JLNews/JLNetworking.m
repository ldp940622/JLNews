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

+ (JLNetworking *)sharedManager {
    static JLNetworking *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[JLNetworking alloc] init];
    });
    return sharedManager;
}

- (void)requestWithURL:(NSString *)URLString method:(JLRequestMethod)method parameter:(NSDictionary *)parameter success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock {
    _manager.requestSerializer.timeoutInterval = 10.0;
    // Remote Server
    //    URLString = kServer;
    if (method == JLRequestGET) {
        [_manager GET:URLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock(error);
//            NSLog(@"Error: %@", error.localizedDescription);
        }];
    } else if (method == JLRequestPOST) {
        [_manager POST:URLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock(error);
            NSLog(@"Error: %@", error);
        }];
    }
}

@end
