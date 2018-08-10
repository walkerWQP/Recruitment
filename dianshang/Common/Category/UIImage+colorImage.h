//
//  UIImage+colorImage.h
//  kuainiao
//
//  Created by yunjobs on 16/8/8.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (colorImage)


/// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/// 不渲染图片
+ (UIImage *)imageWithOriginalImageName:(NSString *)name;

@end
