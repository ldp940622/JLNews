//
//  JLDatabase.h
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface JLDatabase : NSObject

+ (JLDatabase *)sharedManager;

- (void)insertNews:(News *)news success:(void (^)())successBlock failure:(void (^)())failureBlock;
- (void)deleteNews:(News *)news success:(void (^)())successBlock failure:(void (^)())failureBlock;
- (void)insertHistory:(NSString *)history success:(void (^)())successBlock failure:(void (^)())failureBlock;
- (BOOL)newsIsExist:(News *)news;
- (NSArray *)getStarNews;
- (NSMutableArray *)getSearchHistory;
- (BOOL)historyIsExist:(NSString *)history;

@end
