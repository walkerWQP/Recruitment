//
//  RecommendPersonCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecommendPersonEntity;
@interface RecommendPersonCell : UITableViewCell

@property (nonatomic, strong) RecommendPersonEntity *entity;

@property (nonatomic, strong) void(^selectBlock)(NSIndexPath *indexPath, RecommendPersonEntity *entity);
@end
