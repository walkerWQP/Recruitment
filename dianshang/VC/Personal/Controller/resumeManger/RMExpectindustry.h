//
//  RMExpectindustry.h
//  dianshang
//  期望行业标签控制器
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@interface RMExpectindustry : YQViewController

@property (nonatomic, strong) void(^expectIndustryBlock)(NSArray *array);

// 期望标签
@property (nonatomic, strong) NSArray *expectArray;

@end

@class RMExpectindustryEntity;
@interface RMCollectionCell : UICollectionViewCell

@property (nonatomic, strong) RMExpectindustryEntity *buttonItem;

@property (nonatomic, strong) UIButton *textButton;

@property (nonatomic, strong) void(^refreshSection)(NSIndexPath *path);

@end

@interface RMCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;

@end

// 左对齐样式
@interface RMCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
