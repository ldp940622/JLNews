//
//  JLNetworking.h
//  JLNews
//
//  Created by 李大鹏 on 15/11/16.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef enum {
    JLRequestGET = 0,
    JLRequestPOST
}JLRequestMethod;

@interface JLNetworking : NSObject

+ (JLNetworking *)sharedManager;
- (void)requestWithURL:(NSString *)URLString method:(JLRequestMethod)method parameter:(NSDictionary *)parameter success:(void (^)(id responseObject))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
