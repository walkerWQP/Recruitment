//
//  RMAddEditJobIntention.h
//  dianshang
//  添加/编辑期望工作
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@class RMJobIntentionEntity;

@interface RMAddEditJobIntention : YQTableViewController

@property (nonatomic, assign) BOOL isDelBtn;

@property (nonatomic, strong) RMJobIntentionEntity *entity;

@property (nonatomic, strong) void(^addEditBlock)(BOOL isAdd, RMJobIntentionEntity *entity);

//职位ID
@property (nonatomic, strong) NSString *workIDStr;

@end
