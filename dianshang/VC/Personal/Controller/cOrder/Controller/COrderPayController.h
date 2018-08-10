//
//  COrderPayController.h
//  dianshang
//
//  Created by yunjobs on 2017/12/15.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@class COrderBystagesEntity;

@interface COrderPayController : YQTableViewController

@property (nonatomic, strong) COrderBystagesEntity *entity;

@property (nonatomic, strong) void(^refreshTable)();

@end
