//
//  CompanyAuthSelectController.h
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@class EZCPersonCenterEntity;

@interface CompanyAuthSelectController : YQTableViewController

@property (nonatomic, strong) EZCPersonCenterEntity *entity;

@property (nonatomic, strong) void(^finishBlock)();

@end
