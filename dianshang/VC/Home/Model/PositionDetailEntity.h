//
//  PositionDetailEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/22.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionDetailEntity : NSObject
@property (nonatomic, copy) NSString *positionid;// 职位ID
@property (nonatomic, copy) NSString *pdetails;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *ctag;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *paylow;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *position_class_name;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *skill;
@property (nonatomic, copy) NSString *exprience;
@property (nonatomic, copy) NSString *paytop;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *position_class_id;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *puid;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *hx_username;// 环信id聊天使用
@property (nonatomic, copy) NSString *lat; //经纬度
@property (nonatomic, copy) NSString *lng;

@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *consultant;//顾问费
@property (nonatomic, copy) NSString *probation;//试用期

+ (instancetype)PositionDetailEntityWithDict:(NSDictionary *)dict;


@end
