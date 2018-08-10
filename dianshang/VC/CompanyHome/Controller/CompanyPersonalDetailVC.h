//
//  CompanyPersonalDetailVC.h
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@class CompanyHomeEntity;

@interface CompanyPersonalDetailVC : YQViewController

@property (nonatomic, strong) CompanyHomeEntity *entity;

@property (nonatomic, assign) BOOL isChat;

@property (nonatomic, assign) BOOL isRecommend;

@property (nonatomic, strong) NSString *hx_username;

@end
