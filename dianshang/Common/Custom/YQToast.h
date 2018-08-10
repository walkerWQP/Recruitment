//
//  YQWarning.h
//  kuainiao
//
//  Created by yunjobs on 16/9/13.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define DEFAULT_DISPLAY_DURATION 2

@interface YQToast : NSObject

#pragma mark - UIAlertView
/// 警告框UIAlertView
+ (void)yq_AlertText:(NSString *)text;

#pragma mark - Toast
/// toast 默认位置 默认时间
+ (void)yq_ToastText:(NSString *)text;
/// toast 默认位置 自定义时间
+ (void)yq_ToastText:(NSString *)text duration:(CGFloat)duration;
/// toast 自定义距离顶部位置 自定义时间
+ (void)yq_ToastText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;
/// toast 自定义距离底部位置 自定义时间
+ (void)yq_ToastText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;
/// toast 自定义距离顶部位置 默认时间
+ (void)yq_ToastText:(NSString *)text topOffset:(CGFloat)topOffset;
/// toast 自定义距离底部位置 默认时间
+ (void)yq_ToastText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;

@end
