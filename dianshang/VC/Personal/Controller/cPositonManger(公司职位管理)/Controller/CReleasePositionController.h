//
//  CReleasePositionController.h
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@class CPositionMangerEntity;
@interface CReleasePositionController : YQTableViewController

@property (nonatomic, strong) CPositionMangerEntity *entity;

@property (nonatomic, strong) void(^addEditBlock)(BOOL isAdd, CPositionMangerEntity *entity);

@end
