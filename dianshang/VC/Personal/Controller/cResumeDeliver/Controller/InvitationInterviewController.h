//
//  InvitationInterviewController.h
//  dianshang
//
//  Created by yunjobs on 2017/12/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@class CompanyHomeEntity;

@interface InvitationInterviewController : YQViewController

@property (nonatomic, strong) CompanyHomeEntity *entity;

@property (nonatomic, strong) void(^backBlock)(CompanyHomeEntity *entity);

@end
