//
//  RMJobPosition.h
//  dianshang
//  职位选择
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@class RMJobPositionEntity;

@interface RMJobPosition : YQViewController

@property (nonatomic, strong) void(^JobPositionBlock)(RMJobPositionEntity *entity);

@end
