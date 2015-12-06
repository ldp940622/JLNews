//
//  UISearchBar+Extension.m
//  TableSearch
//
//  Created by 李大鹏 on 15/12/5.
//
//

#import "UISearchBar+Extension.h"

@implementation UISearchBar (Extension)

- (void)changeBackgroundColor:(UIColor *)backgroundColor {
    static NSInteger backgroundTag = 99999;
    
    UIView *view = [[self subviews] firstObject];
    
    [[view subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == backgroundTag) {
            [obj removeFromSuperview];
        }
    }];
    
    if (backgroundColor) {
        CGRect frame = CGRectMake(0, -20, self.frame.size.width, self.frame.size.height + 20);
        UIGraphicsBeginImageContext(frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
        CGContextFillRect(context, frame);
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView *imageView = [[UIImageView alloc] initWithImage:theImage];
        imageView.tag = backgroundTag;
        
        [[[self subviews] firstObject] insertSubview:imageView atIndex:1];
    }
}

@end
