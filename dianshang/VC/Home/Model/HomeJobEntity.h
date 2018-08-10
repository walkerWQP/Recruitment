//
//  HomeJobEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeJobEntity : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *exprience;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *cvedit;
@property (nonatomic, copy) NSString *puid;
@property (nonatomic, copy) NSString *pay;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pname;

@property (nonatomic, copy) NSString *position_class_id;//职位类型
@property (nonatomic, copy) NSString *position_class_name;//职位类型名称

@property (nonatomic, copy) NSString *delivery;//是否投递过简历
@property (nonatomic, copy) NSString *payposition;//是否关注职位（1、关注；2、未关注）
@property (nonatomic, copy) NSString *consultant;//顾问费
@property (nonatomic, copy) NSString *collect;//收藏（1、收藏；2、未收藏）
@property (nonatomic, copy) NSString *probation;//试用期
@property (nonatomic, copy) NSString *post;//发布人的职务

@property (nonatomic, copy) NSString *logo;//公司logo
@property (nonatomic, copy) NSString *createtime;//发布时间

@property (nonatomic, copy) NSString *mdealwith;
@property (nonatomic, copy) NSString *cdealwith;

@property (nonatomic, copy) NSString *rname;// 推荐人姓名
@property (nonatomic, copy) NSString *ravatar;// 推荐人头像
@property (nonatomic, copy) NSString *posid;// 职位ID
@property (nonatomic, copy) NSString *orderid;// 订单ID
@property (nonatomic, copy) NSString *reliable;// 靠谱值
@property (nonatomic, copy) NSString *address;// 靠谱值

+ (instancetype)HomeJobEntityWithDict:(NSDictionary *)dict;

@end
