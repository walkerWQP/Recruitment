//
//  CPositionMangerEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPositionMangerEntity : NSObject

@property (nonatomic, copy) NSString *pdetails;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *pname;//职位名
@property (nonatomic, copy) NSString *pay;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *probation;
@property (nonatomic, copy) NSString *sharecount;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *paylow;
@property (nonatomic, copy) NSString *hot;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *chat_num;//沟通过
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *look_num;
@property (nonatomic, copy) NSString *itemId;// 记录唯一id
@property (nonatomic, copy) NSString *consultant;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *skill;
@property (nonatomic, copy) NSString *exprience;
@property (nonatomic, copy) NSString *paytop;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *issue;
@property (nonatomic, copy) NSString *position_class_id;
@property (nonatomic, copy) NSString *position_class_name;
@property (nonatomic, copy) NSString *puid;
@property (nonatomic, copy) NSString *genre;

@property (nonatomic, copy) NSString *pcount;// 直投数量
@property (nonatomic, copy) NSString *hrcount;// hr推荐数量

@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)CPositionEntityWithDict:(NSDictionary *)dict;

@end
