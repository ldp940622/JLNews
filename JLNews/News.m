//
//  News.m
//  JLNews
//
//  Created by 李大鹏 on 15/10/25.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "News.h"

@implementation News

+ (News *)newsWithDict:(NSDictionary *)newsDict {
    News *news = [[News alloc] init];
    news.newsID = newsDict[@"id"];
    news.title = newsDict[@"title"];
    news.content = newsDict[@"content"];
    news.images = newsDict[@"images"];
    news.imageArr = [News parseImageArray:newsDict[@"images"]];
    news.contentArray = [News parseContentArray:newsDict[@"content"]];
    news.newsDiscription = [News parseDescription:news.contentArray];
    
    return news;
}

+ (NSArray *)parseImageArray:(NSString *)images {
    if (![images isEqualToString:@""]) {
        NSArray *imageUrlArray = [images componentsSeparatedByString:@","];
        return imageUrlArray;
    } else {
        return @[];
    }
}

+ (NSArray *)parseContentArray:(NSString *)content {
    if (![content isEqualToString:@""]) {
        NSArray *contentArray = [content componentsSeparatedByString:@"\\n\\t"];
        return contentArray;
    } else {
        return @[];
    }
}

+ (NSString *)parseDescription:(NSArray *)contentArray {
    for (NSString *p in contentArray) {
        if (![p hasPrefix:@"[IMG-"] && ![p containsString:@"原标"] &&
            [p length] > 20) {
            return p;
        }
    }
    return @"";
}

@end
