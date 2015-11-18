//
//  JLProgressHUD.h
//  JLNews
//
//  Created by 李大鹏 on 15/11/18.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLProgressHUD : NSObject
+ (JLProgressHUD *)sharedProgressHUD;
- (void)showMessage:(NSString *)message hideDelay:(NSTimeInterval)delay;
@end
