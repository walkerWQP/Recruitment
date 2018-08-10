//
//  DeliveryRecordCell.h
//  dianshang
//
//  Created by yunjobs on 2017/12/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeJobEntity;

@interface DeliveryRecordCell : UITableViewCell

@property (nonatomic, assign) NSInteger curTable;

@property (nonatomic, strong) HomeJobEntity *entity;

@property (nonatomic, strong) void(^detailBlock)(NSIndexPath *indexPath, HomeJobEntity *entity);
// 1->同意;2->拒绝
@property (nonatomic, strong) void(^otherBlock)(NSIndexPath *indexPath, HomeJobEntity *entity,NSInteger index);

@end
