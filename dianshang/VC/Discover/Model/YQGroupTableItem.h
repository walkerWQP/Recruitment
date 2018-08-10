//
//  YQGroupTableItem.h
//  kuainiao
//
//  Created by yunjobs on 16/8/30.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DeliveryJobType) {
    DeliveryJobTypeWaitInterview = 1, // 待面试
    DeliveryJobTypeInterview = 2, // 已面试
    DeliveryJobTypeAlreadyEntry = 3, // 已入职
    DeliveryJobTypeAlreadyWorker = 4, // 已转正
    DeliveryJobTypeAlreadyQuit = 5, // 已离职
};

typedef NS_ENUM(NSUInteger, ShareHRType) {
    ShareHRTypeAllowRecommend = 1, // 可推荐
    ShareHRTypeWaitInterview = 2, // 待面试
    ShareHRTypeInterview = 3, // 已面试
    ShareHRTypeAlreadyEntry = 4, // 已入职
    ShareHRTypeAlreadyWorker = 5, // 已转正
};

#import <Foundation/Foundation.h>

@interface YQGroupTableItem : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *activityTpye;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tableViewArray;

/// 选择职位后刷新标识
@property (nonatomic, assign) BOOL refreshFlag;

// 投递记录类型
@property (nonatomic, assign) DeliveryJobType deliveryType;

// 共享hr类型
@property (nonatomic, assign) ShareHRType shareHRType;

@end
