//
//  NSString+Extension.m
//  JLNews
//
//  Created by 李大鹏 on 15/12/3.
//  Copyright © 2015年 Ldp. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGRect)rectByFont:(UIFont *)font andSize:(CGSize)size {
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : font } context:nil];
    rect.size.width += 10;
    rect.size.height += 5;
    return rect;
}

@end
