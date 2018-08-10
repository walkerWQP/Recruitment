//
//  YQPageControl.m
//  kuainiao
//
//  Created by yunjobs on 16/11/26.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQPageControl.h"

const CGFloat YQPageControlMarginLeft = 7.0;
const CGFloat YQPageControlItemSpacing = 4.5;
const NSInteger YQDefultDotWH = 5;

@interface YQPageControl ()
{
    NSInteger dotWH;
}
@end

@implementation YQPageControl

- (void)setPageControlDotWH:(NSInteger)pageControlDotWH
{
    _pageControlDotWH = pageControlDotWH;
    dotWH = pageControlDotWH;
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    // 如果没有设置点的宽度 默认是 5
    NSInteger WH = dotWH == 0 ? YQDefultDotWH : dotWH;
    for (int i = 0; i < self.subviews.count; i++) {
        UIImageView *v = [self.subviews objectAtIndex:i];
        CGFloat X = YQPageControlMarginLeft + i*WH + YQPageControlItemSpacing*i;
        CGFloat Y = (self.frame.size.height - WH)*0.5;
        CGRect frame = v.frame;
        frame = CGRectMake(X, Y, WH, WH);
        v.frame = frame;
        v.layer.cornerRadius = frame.size.height*0.5;
    }
}

@end
