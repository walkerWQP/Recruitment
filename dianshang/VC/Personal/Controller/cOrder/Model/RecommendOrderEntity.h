//
//  RecommendOrderEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/12/15.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class COrderBystagesEntity;

@interface RecommendOrderEntity : NSObject

@property (nonatomic, copy) NSString *paytime;
@property (nonatomic, copy) NSString *ordernum;
@property (nonatomic, copy) NSString *check;//订单是否有效1、失效；2、有效
@property (nonatomic, copy) NSString *uid;//推荐者
@property (nonatomic, copy) NSString *sharename;//人才名称
@property (nonatomic, copy) NSString *checktime;//生效时间
@property (nonatomic, copy) NSString *avatar;//推荐者头像
@property (nonatomic, copy) NSString *price;//顾问费
@property (nonatomic, copy) NSString *posid;
@property (nonatomic, copy) NSString *probation;//试用期
@property (nonatomic, copy) NSString *shareid;//人才
@property (nonatomic, copy) NSString *paystatus;
@property (nonatomic, copy) NSString *shareavatar;//人才头像
@property (nonatomic, copy) NSString *name;//推荐者名称
@property (nonatomic, copy) NSString *pname;//职位名
@property (nonatomic, copy) NSString *overdue;//1、有逾期；2、未逾期
@property (nonatomic, strong) NSArray *count;//count

@property (nonatomic, copy) NSDictionary *bystages;//分期
@property (nonatomic, strong) COrderBystagesEntity *subOrder;

+ (instancetype)entityWithDict:(NSDictionary *)dict;

@end


@interface COrderBystagesEntity : NSObject

@property (nonatomic, copy) NSString *paytime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *ordernum;
@property (nonatomic, copy) NSString *pordernum;
@property (nonatomic, copy) NSString *orderstatus;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *money;

+ (instancetype)entityWithDict:(NSDictionary *)dict;

@end
