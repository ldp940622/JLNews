//
//  News.h
//  JLNews
//
//  Created by 李大鹏 on 15/10/25.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property (strong, nonatomic) NSNumber *newsID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSArray *imageArr;
@property (copy, nonatomic) NSString *images;
@property (copy, nonatomic) NSString *newsDiscription;
@property (copy, nonatomic) NSArray *contentArray;
@property (copy, nonatomic) NSString *datetime;
@property (copy, nonatomic) NSString *source;

+ (News *)newsWithDict:(NSDictionary *)newsDict;
@end
