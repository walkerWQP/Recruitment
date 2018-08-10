//
//  YQDowndropBodyView.m
//  CustomTable
//
//  Created by yunjobs on 2017/10/26.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#import "YQDowndropBodyView.h"

@implementation YQDowndropBodyView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        UIView *v = self.superview;
        for (UIView *a in v.subviews) {
            if ([a isKindOfClass:[UIView class]] && a.tag == -100) {
                return a;
            }
        }
        return v;
    }
    return view;
}

@end
