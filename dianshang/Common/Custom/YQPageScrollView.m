//
//  YQPageScrollView.m
//  kuainiao
//
//  Created by yunjobs on 16/12/2.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQPageScrollView.h"

@interface YQPageScrollView ()

@property (nonatomic, strong) NSMutableArray *leftBoundarys;

@end

@implementation YQPageScrollView

// 可以同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

//- (NSMutableArray *)leftBoundarys
//{
//    if (_leftBoundarys == nil) {
//        _leftBoundarys = [NSMutableArray array];
//        for (int i = 0; i < self.contentSize.width/self.frame.size.width; i++) {
//            // 需要操作区域
//            CGRect tempRect = CGRectMake(i*self.frame.size.width, 0, 20, self.yq_height);
//            NSValue *a1 = [NSValue valueWithCGRect:tempRect];
//            [_leftBoundarys addObject:a1];
//        }
//    }
//    return _leftBoundarys;
//}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    for (int i = 0; i < self.leftBoundarys.count; i++) {
//        NSValue *value = [self.leftBoundarys objectAtIndex:i];
//        CGRect tempRect = [value CGRectValue];
//        if (CGRectContainsPoint(tempRect, point)) {
//            return [self superview];
//        }
//    }
//    return [super hitTest:point withEvent:event];
//}

@end
