//
//  CompanyHomeEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyHomeEntity : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *top_salary;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *year;//工作年份
@property (nonatomic, copy) NSString *restatus;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *low_salary;
@property (nonatomic, copy) NSString *paymember;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *workStr;//工作经验
@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *cdealwith;//
@property (nonatomic, copy) NSString *orderid;//

@property (nonatomic, copy) NSString *rname;//推荐人姓名
@property (nonatomic, copy) NSString *rid;//推荐人id
@property (nonatomic, copy) NSString *ravatar;// 推荐人头像
@property (nonatomic, copy) NSString *reliable;// 推荐人靠谱值
@property (nonatomic, copy) NSString *posid;//职位ID
@property (nonatomic, copy) NSString *address;//公司地址
@property (nonatomic, copy) NSString *pcity;//公司城市
//是否开启急速求职 1：未开通 2：开通
@property (nonatomic, copy) NSString *isfast;
//1、未查看；2、已查看
@property (nonatomic, copy) NSString *see;

//1、表示已查看过人才电话号码；2、表示未查看过
@property (nonatomic, copy) NSString *phone_status;
@property (nonatomic, copy) NSString *phone;
//1、表示已打靠谱值；2、表示未打靠谱值
@property (nonatomic, copy) NSString *grade_status;


+ (instancetype)CompanyHomeEntityWithDict:(NSDictionary *)dict;

@end
