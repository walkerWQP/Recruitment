//
//  ToCompanyEvaluateController.h
//  dianshang
//  人才给公司评价
//  Created by yunjobs on 2017/11/24.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

typedef NS_ENUM(NSUInteger, EvaluateType) {
    EvaluateTypeFirstImpression = 1, // 第一印象
    EvaluateTypeEntryImpression = 2, // 入职印象
    EvaluateTypeworkerImpression = 3, // 离职印象
};

#import "YQViewController.h"

@class DeliveryJobEntity;

@interface ToCompanyEvaluateController : YQViewController

@property (nonatomic, assign) EvaluateType type;

@property (nonatomic, strong) DeliveryJobEntity *entity;

@end
