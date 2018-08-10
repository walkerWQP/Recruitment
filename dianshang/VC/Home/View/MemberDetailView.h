//
//  MemberDetailView.h
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberDetailEntity;

@interface MemberDetailView : UIView

@property (nonatomic, strong) MemberDetailEntity *entity;

@property (nonatomic, strong) void(^goCompanyPress)(MemberDetailEntity *entity);

+ (instancetype)memberView;

@end
