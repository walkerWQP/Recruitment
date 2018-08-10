//
//  RMHeadView.h
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResumeManageEntity;

@interface RMHeadView : UIView

+ (instancetype)headView;

@property (nonatomic, strong) ResumeManageEntity *entity;

@end
