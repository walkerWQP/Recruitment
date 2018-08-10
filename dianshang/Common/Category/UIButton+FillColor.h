//
//  UIButton+FillColor.h
//  PublicOpinionMonitoring
//  颜色填充背景
//  Created by csip on 15-3-19.
//  Copyright (c) 2015年 com.hn3l.mobilely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FillColor)

/// 给按钮设置不同状态的背景色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/// 根据颜色获取UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
