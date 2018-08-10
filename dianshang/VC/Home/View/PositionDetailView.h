//
//  PositionDetailView.h
//  dianshang
//
//  Created by yunjobs on 2017/11/22.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PositionDetailEntity;
@interface PositionDetailView : UIView

+ (instancetype)detailView;

+ (CGFloat)detailViewHeight:(PositionDetailEntity *)entity;

@property (nonatomic, strong) PositionDetailEntity *entity;

// 公司主页点击
@property (nonatomic, strong) void(^companyHomePage)(UIButton *sender);

//公司地址点击
@property (nonatomic, strong) void(^addressHomeClick)(UIButton *sender);

@end
