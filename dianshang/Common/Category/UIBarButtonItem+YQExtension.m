//
//  UIBarButtonItem+YQExtension.m
//  kuainiao
//
//  Created by yunjobs on 16/9/7.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "UIBarButtonItem+YQExtension.h"
#import "UIImage+colorImage.h"

@implementation UIBarButtonItem (YQExtension)
@dynamic barButtonItemColor;
@dynamic barButtonItemTitle;

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *rightButn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButn setImage:[UIImage imageWithOriginalImageName:image] forState:UIControlStateNormal];
    [rightButn setImage:[UIImage imageWithOriginalImageName:highImage] forState:UIControlStateHighlighted];
    [rightButn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [rightButn sizeToFit];
    return [[self alloc] initWithCustomView:rightButn];
}

+ (instancetype)itemWithtitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action
{
    UIButton *rightButn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButn setTitle:title forState:UIControlStateNormal];
    [rightButn setTitleColor:color forState:UIControlStateNormal];
    [rightButn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    rightButn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButn sizeToFit];
    return [[self alloc] initWithCustomView:rightButn];
}

- (void)setBarButtonItemColor:(UIColor *)barButtonItemColor
{
    UIButton *button = self.customView;
    [button setTitleColor:barButtonItemColor forState:UIControlStateNormal];
}

- (void)setBarButtonItemTitle:(NSString *)barButtonItemTitle
{
    UIButton *button = self.customView;
    [button setTitle:barButtonItemTitle forState:UIControlStateNormal];
}

@end
