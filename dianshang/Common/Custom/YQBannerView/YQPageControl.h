//
//  YQPageControl.h
//  kuainiao
//
//  Created by yunjobs on 16/11/26.
//  Copyright © 2016年 yunjobs. All rights reserved.
//
#import <UIKit/UIKit.h>

/*
 求YQPageControl的宽度
 
 W = 距离左右间距*2 + 点的个数*点的宽度 + 点与点之间的间隔*总共有几个间隔
 YQPageControlMarginLeft*2 + self.items.count*4 + YQPageControlItemSpacing*(self.items.count-1);
 */

// 常量
UIKIT_EXTERN const CGFloat YQPageControlMarginLeft;  // 距离左右间距
UIKIT_EXTERN const CGFloat YQPageControlItemSpacing;  // 点与点之间的间隔

@interface YQPageControl : UIPageControl

/// 圆点的宽高
@property (nonatomic, assign) NSInteger pageControlDotWH;

@end
