//
//  UIView+Frame.m
//  caipiao
//
//  Created by yunjobs on 16/8/4.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)yq_width
{
    return self.bounds.size.width;
}

- (void)setYq_width:(CGFloat)yq_width
{
    CGRect frame = self.frame;
    frame.size.width = yq_width;
    self.frame = frame;
}

- (CGFloat)yq_height
{
    return self.bounds.size.height;
}

- (void)setYq_height:(CGFloat)yq_height
{
    CGRect frame = self.frame;
    frame.size.height = yq_height;
    self.frame = frame;
}

- (CGFloat)yq_x
{
    return self.frame.origin.x;
}

- (void)setYq_x:(CGFloat)yq_x
{
    CGRect frame = self.frame;
    frame.origin.x = yq_x;
    self.frame = frame;
}

- (CGFloat)yq_y
{
    return self.frame.origin.y;
}

- (void)setYq_y:(CGFloat)yq_y
{
    CGRect frame = self.frame;
    frame.origin.y = yq_y;
    self.frame = frame;
}

- (CGFloat)yq_right
{
//    return self.yq_x + self.yq_width;
    return CGRectGetMaxX(self.frame);
}

- (void)setYq_right:(CGFloat)yq_right
{
    self.yq_x = yq_right - self.yq_width;
}

- (CGFloat)yq_bottom
{
//    return self.yq_y + self.yq_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setYq_bottom:(CGFloat)yq_bottom
{
    self.yq_y = yq_bottom - self.yq_height;
}

- (void)setYq_size:(CGSize)yq_size
{
    CGRect frame = self.frame;
    frame.size = yq_size;
    self.frame = frame;
}

- (CGSize)yq_size
{
    return self.frame.size;
}

- (void)setYq_origin:(CGPoint)yq_origin
{
    CGRect frame = self.frame;
    frame.origin = yq_origin;
    self.frame = frame;
}

- (CGPoint)yq_origin
{
    return self.frame.origin;
}

- (void)setYq_centerX:(CGFloat)yq_centerX
{
    CGPoint center = self.center;
    center.x = yq_centerX;
    self.center = center;
}
- (CGFloat)yq_centerX
{
    return self.center.x;
}

- (void)setYq_centerY:(CGFloat)yq_centerY
{
    CGPoint center = self.center;
    center.y = yq_centerY;
    self.center = center;
}
- (CGFloat)yq_centerY
{
    return self.center.y;
}
@end
