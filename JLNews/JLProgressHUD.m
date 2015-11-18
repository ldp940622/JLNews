//
//  JLProgressHUD.m
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "JLProgressHUD.h"
#import "MBProgressHUD.h"

@interface JLProgressHUD ()
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation JLProgressHUD

- (instancetype)init {
    self = [super init];
    if (self) {
        UIWindow *hudWindow = [UIApplication sharedApplication].windows[0];
        _hud = [[MBProgressHUD alloc] initWithWindow:hudWindow];
        [hudWindow addSubview:_hud];
        _hud.userInteractionEnabled = NO;
    }
    return self;
}

+ (JLProgressHUD *)sharedProgressHUD {
    static JLProgressHUD *shared_hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_hud = [[JLProgressHUD alloc] init];
    });
    return shared_hud;
}

- (void)showMessage:(NSString *)message hideDelay:(NSTimeInterval)delay {
    if (nil == message || [message isEqualToString:@""]) {
        NSLog(@"YFProgressHUD显示空信息.");
        [_hud hide:YES];
        return;
    }
    UIWindow *hudWindow = (UIWindow *)_hud.superview;
    [hudWindow bringSubviewToFront:_hud];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = message;
    [_hud show:YES];
    [_hud hide:YES afterDelay:delay];
}

@end
