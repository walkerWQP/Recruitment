//
//  EZPublicList.h
//  dianshang
//
//  Created by yunjobs on 2017/10/21.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZPublicList : NSObject

/// 经验
+ (NSArray *)getExperienceList;
/// 技能
+ (NSArray *)getSkillList;
/// 顾问费
+ (NSArray *)getCostList;
/// 薪资
+ (NSArray *)getSalaryList;
/// 薪资转换
+ (NSString *)getSalaryConvert:(NSString *)itemId;
/// 公司规模
+ (NSArray *)getScopeList;
/// 公司标签
+ (NSArray *)getCompanyLabelList;
/// 行业
+ (NSArray *)getTradeList;
/// 学历
+ (NSArray *)getEducationList;
/// 公司标识
+ (NSArray *)getCompanyFlagList;
/// 融资
+ (NSArray *)getFinancingList;
/// 求职状态
+ (NSArray *)getJobIntentionStateList;

#pragma mark - 城市列表
/// 城市列表
+ (NSDictionary *)getCityDict;
// 根据城市获取区县列表
+ (NSArray *)getAreaListWith:(NSString *)city;
// 全国城市列表
+ (NSArray *)getCityList;
#pragma mark - 我的
// 根据角色返回我的列表信息
+ (NSArray *)getPersonalListRole:(NSString *)role;
// 根据角色返回我的头部列表信息
+ (NSArray *)getPersonalHeadListRole:(NSString *)role;


/*  测试数据  */
+ (void)printPropertyWithDict:(NSDictionary *)dict;

@end
