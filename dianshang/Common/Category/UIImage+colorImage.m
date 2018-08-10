//
//  UIImage+colorImage.m
//  kuainiao
//
//  Created by yunjobs on 16/8/8.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "UIImage+colorImage.h"

@implementation UIImage (colorImage)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(APP_WIDTH, 64);
    UIGraphicsBeginImageContext(size);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [color set];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithOriginalImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
