//
//  CompanyIntroduceController.h
//  dianshang
//
//  Created by yunjobs on 2017/11/28.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQUploadImageVC.h"

@class EZCPersonCenterEntity;
@interface CompanyIntroduceController : YQUploadImageVC
@property (nonatomic, strong) EZCPersonCenterEntity *entity;
@property (nonatomic, strong) NSString   *typeStr;
@end


