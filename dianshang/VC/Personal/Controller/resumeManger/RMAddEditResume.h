//
//  RMAddEditResume.h
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

// RMSectionType要和ResumeManageController的self.group的index保持一致
typedef NS_ENUM(NSUInteger, RMSectionType) {
    RMSectionTypeWorking = 3, // 工作经历
    RMSectionTypeExperience = 4, // 项目经验
    RMSectionTypeEducational = 5, // 教育经历
};

#import "YQViewController.h"

@class ResumeManageEntity;
@class ResumeManageSubEntity;

@interface RMAddEditResume : YQViewController

// 添加/编辑类型
@property (nonatomic, assign) RMSectionType type;
// 编辑的内容
@property (nonatomic, strong) ResumeManageSubEntity *editEntity;

@property (nonatomic, strong) void(^addEditBlock)(BOOL isAdd,ResumeManageSubEntity *entity);

@end
