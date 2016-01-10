//
//  UITabBar+Extension.m
//  JLNews
//
//  Created by saybot on 15/12/8.
//  Copyright © 2015年 Ldp. All rights reserved.
//

#import "UITabBar+Extension.h"

@implementation UITabBar (Extension)

- (void)showBadgeAtIndex:(NSInteger)index {
    if ([self isBadgeExistAtIndex:index]) {
        return;
    }
    UIView *badgeView = [[UIView alloc] initWithFrame:CGRectZero];
    badgeView.layer.cornerRadius = 5.0f;
    badgeView.backgroundColor = [UIColor redColor];
    badgeView.tag = index + 1000;
    
    CGRect tabFrame = self.frame;
    CGFloat x = (index + 0.55) * tabFrame.size.width / self.items.count;
    badgeView.frame = CGRectMake(x, 5, 10, 10);
    
    [self addSubview:badgeView];
}

- (void)removeBadgeAtIndex:(NSInteger)index {
    if (![self isBadgeExistAtIndex:index]) {
        return;
    }
    [[self isBadgeExistAtIndex:index] removeFromSuperview];
}

- (UIView *)isBadgeExistAtIndex:(NSInteger)index {
    for (UIView *badge in self.subviews) {
        if (badge.tag == 1000 + index) {
            return badge;
        }
    }
    return nil;
}

@end
