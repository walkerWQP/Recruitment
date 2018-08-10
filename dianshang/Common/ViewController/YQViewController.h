//
//  YQViewController.h
//  kuainiao
//
//  Created by yunjobs on 16/5/18.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface YQViewController : UIViewController

@property (strong, nonatomic) MBProgressHUD *hud;

/// 是否显示没有更多数据
@property (nonatomic, strong) UILabel *hintLabel;
@property (assign, nonatomic) BOOL isShowNoMoreData;

/// 添加一个自定义的返回按钮  block 处理点击事件
- (void)addBackButton:(void(^)())block;

//- (void)tableview:(UIView *)view toView:(UIView *)cell toY:(CGFloat)y;

//- (CGFloat)yq_navHeight;
//- (CGFloat)yq_tabbarHeight;
//- (CGFloat)yq_viewHeight;

@end
