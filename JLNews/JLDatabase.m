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
            NSString *creatTableSQL = @"CREATE TABLE 'News' ('id' INTEGER PRIMARY KEY NOT NULL , 'title' VARCHAR(30), 'images' VARCHAR(255), 'content' TEXT)";
            if ([_newsDB executeUpdate:creatTableSQL withErrorAndBindings:&err]) {
                NSLog(@"%@", _newsDB);
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
    NSString *insertSQL = @"INSERT INTO NEWS (id,title,images,content) values (?,?,?,?)";
    if ([_newsDB executeUpdate:insertSQL, news.newsID, news.title, news.images, news.content]) {
        successBlock();
    } else {
        failureBlock();
    }
}

- (NSArray *)getStarNews {
    NSMutableArray *newsArray = [NSMutableArray array];
    NSString *getNewsSQL = @"SELECT * FROM NEWS";
    FMResultSet *result = [_newsDB executeQuery:getNewsSQL];
    while ([result next]) {
        NSDictionary *newsDic = @{ @"id" : [NSNumber numberWithInt:[result intForColumn:@"id"]],
                                   @"title" : [result stringForColumn:@"title"],
                                   @"images" : [result stringForColumn:@"images"],
                                   @"content" : [result stringForColumn:@"content"] };
        [newsArray addObject:newsDic];
    }
    return newsArray;
}

@end
