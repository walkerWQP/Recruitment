//
//  CompanyDetailView.h
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyDetailEntity;

@interface CompanyDetailView : UIView

+ (instancetype)companyView;

@property (nonatomic, strong) CompanyDetailEntity *entity;

@property (nonatomic, strong) void(^linkClick)(CompanyDetailEntity *entity);

@end
