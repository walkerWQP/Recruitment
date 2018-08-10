//
//  CPositionMangerCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPositionMangerEntity;

@interface CPositionMangerCell : UITableViewCell

@property (nonatomic, strong) CPositionMangerEntity *entity;

// 0->推荐; 1->直投
@property (nonatomic, strong) void(^buttonBlock)(NSIndexPath *indexPath,NSInteger index);

@end
