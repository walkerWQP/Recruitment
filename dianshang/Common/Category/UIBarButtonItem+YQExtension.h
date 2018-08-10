//
//  UIBarButtonItem+YQExtension.h
//  kuainiao
//  快速创建UIBarButtonItem
//  Created by yunjobs on 16/9/7.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YQExtension)

@property (nonatomic, strong) UIColor *barButtonItemColor;

@property (nonatomic, strong) NSString *barButtonItemTitle;

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithtitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action;

@end
