//
//  YQDowndropHeadView.h
//  CustomTable
//
//  Created by yunjobs on 2017/10/24.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQHeadViewItem;

@interface YQDowndropHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray<YQHeadViewItem *> *)titleArr;

// 按钮点击回调
@property (nonatomic, strong) void(^headViewBlock)(NSInteger index);

@end
