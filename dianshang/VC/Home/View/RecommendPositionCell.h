//
//  RecommendPositionCell.h
//  dianshang
//
//  Created by yunjobs on 2017/12/25.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareHREntity;
@interface RecommendPositionCell : UITableViewCell

@property (nonatomic, strong) ShareHREntity *entity;

@property (nonatomic, strong) void(^selectBlock)(NSIndexPath *indexPath, ShareHREntity *entity);

@end
