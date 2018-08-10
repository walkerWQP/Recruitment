//
//  YQSearchView.h
//  kuainiao
//
//  Created by yunjobs on 16/12/12.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQSearchView : UIView

/// 创建搜索框
- (void)initSearchView:(NSArray *)myarray placeholder:(NSString *)placeholder searchTitle:(NSString *)title keyboardType:(UIKeyboardType )keyboardType;

// 点击搜索调用  type: 0:手机号 1:编号
@property (nonatomic, strong) void(^query)(NSString *searchStr, NSInteger type);
@property (nonatomic, strong) void(^searchViewCancel)();
@property (nonatomic, strong) void(^searchViewCity)();
@property (nonatomic, strong) void(^beginEdit)(UITextField *textField);

@property (nonatomic, strong) UITextField *textfield;

@property (nonatomic, strong) NSString *cityStr;

/// 创建静态搜索框
- (void)initStaticSearchView:(NSString *)placeholder searchTitle:(NSString *)title;
// 点击静态搜索框调用
@property (nonatomic, strong) void(^press)();
- (void)pressTap:(void(^)())block;

@end
