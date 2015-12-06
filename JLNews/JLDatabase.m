//
//  JLDatabase.m
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "JLDatabase.h"
#import "MBProgressHUD.h"
#import "FMDB.h"
#define DOC_PATH (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0])

@interface JLDatabase ()
@property (strong, nonatomic) FMDatabase *newsDB;
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation JLDatabase

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _newsDB = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/news.db", DOC_PATH]];
        if ([_newsDB open]) {
            NSError *err;
            NSString *creatNewsTableSQL = @"CREATE TABLE 'News' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 'newsID' INTEGER,'title' VARCHAR(30), 'images' VARCHAR(255), 'content' TEXT, 'datetime' VARCHAR(255), 'source' VARCHAR(255))";
            NSString *creatHistoryTableSQL = @"CREATE TABLE 'History' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 'history' VARCHAR(255) NOT NULL)";
            [_newsDB executeUpdate:creatNewsTableSQL, creatHistoryTableSQL];
            if ([_newsDB executeUpdate:creatNewsTableSQL withErrorAndBindings:&err] || [_newsDB executeUpdate:creatHistoryTableSQL withErrorAndBindings:&err]) {
                NSLog(@"成功创建表!");
            } else {
                NSLog(@"失败:%@", err);
            }
        }
    }
    return self;
}

- (void)dealloc {
    _newsDB = [FMDatabase databaseWithPath:@"/tmp/news.db"];
    NSLog(@"关闭数据库");
    [_newsDB close];
}

#pragma mark - Singleton Method
+ (JLDatabase *)sharedManager {
    static JLDatabase *shared_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_manager = [[JLDatabase alloc] init];
    });
    return shared_manager;
}

#pragma mark - Public Method
- (void)insertNews:(News *)news success:(void (^)())successBlock failure:(void (^)())failureBlock {
    NSString *insertSQL = @"INSERT INTO NEWS (newsID,title,images,content,datetime,source) values (?,?,?,?,?,?)";
    if ([_newsDB executeUpdate:insertSQL, news.newsID, news.title, news.images, news.content, news.datetime, news.source]) {
        successBlock();
    } else {
        failureBlock();
    }
}

- (void)deleteNews:(News *)news success:(void (^)())successBlock failure:(void (^)())failureBlock {
    NSString *deleteSQL = @"DELETE FROM NEWS WHERE newsID = ?";
    if ([_newsDB executeUpdate:deleteSQL, news.newsID]) {
        successBlock();
    }
    else{
        failureBlock();
    }
}

- (BOOL)newsIsExist:(News *)news {
    NSString *getNews = @"SELECT * FROM NEWS WHERE newsID = (?)";
    FMResultSet *result = [_newsDB executeQuery:getNews, news.newsID];
    if ([result next]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)getStarNews {
    NSMutableArray *newsArray = [NSMutableArray arrayWithArray:@[]];
    NSString *getNewsSQL = @"SELECT * FROM NEWS ORDER BY id ASC";
    FMResultSet *result = [_newsDB executeQuery:getNewsSQL];
    while ([result next]) {
        NSDictionary *newsDic = @{ @"id" : [NSNumber numberWithInt:[result intForColumn:@"newsID"]],
                                   @"title" : [result stringForColumn:@"title"],
                                   @"images" : [result stringForColumn:@"images"],
                                   @"content" : [result stringForColumn:@"content"],
                                   @"datetime" : [result stringForColumn:@"datetime"],
                                   @"source" : [result stringForColumn:@"source"] };
        [newsArray insertObject:newsDic atIndex:0];
    }
    return newsArray;
}

- (void)insertHistory:(NSString *)history success:(void (^)())successBlock failure:(void (^)())failureBlock {
    NSString *insertSQL = @"INSERT INTO History (History) values (?)";
    if ([_newsDB executeUpdate:insertSQL, history]) {
        successBlock();
    } else {
        failureBlock();
    }
}

- (NSArray *)getSearchHistory {
    NSMutableArray *historyArray = [NSMutableArray arrayWithArray:@[]];
    NSString *getNewsSQL = @"SELECT * FROM History ORDER BY id ASC";
    FMResultSet *result = [_newsDB executeQuery:getNewsSQL];
    while ([result next]) {
        [historyArray insertObject:[result stringForColumn:@"history"] atIndex:0];
    }
    return historyArray;
}

@end
