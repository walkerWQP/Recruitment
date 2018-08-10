//
//  RecommendOrderCell.h
//  dianshang
//
//  Created by yunjobs on 2017/12/15.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecommendOrderEntity;
@interface RecommendOrderCell : UITableViewCell

@property (nonatomic, assign) BOOL isPayBtn;

@property (nonatomic, strong) RecommendOrderEntity *entity;
// 支付顾问费
@property (nonatomic, strong) void(^payBlock)(NSIndexPath *indexPath, RecommendOrderEntity *entity);

@end
