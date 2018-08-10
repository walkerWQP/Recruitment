//
//  RMExpectindustryEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark - RMExpectindustryEntity
// 期望行业
@interface RMExpectindustryEntity : NSObject

@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)ExpectindustryEntity:(NSDictionary *)dict;

@end

#pragma mark -
#pragma mark - RMJobPositionEntity
// 职位选择
@interface RMJobPositionEntity : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) NSMutableArray<RMJobPositionEntity *> *child;
@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)JobPositionEntity:(NSDictionary *)dict;
@end

#pragma mark -
#pragma mark - RMJobPositionEntity
// 求职意向
@interface RMJobIntentionEntity : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *explanation;
@property (nonatomic, copy) NSString *genre;
// 城市
@property (nonatomic, copy) NSString *city;
// 薪资
@property (nonatomic, copy) NSString *top_salary;
@property (nonatomic, copy) NSString *low_salary;
// 行业
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *tradename;
// 职位
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *position_classid;
//急速求职 1:未开通 2： 开通
@property (nonatomic, copy) NSString  *isfast;
@property (nonatomic, copy) NSString  *workID;

+ (instancetype)JobIntentionEntity:(NSDictionary *)dict;

@end

