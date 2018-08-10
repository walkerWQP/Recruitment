//
//  ShareHREntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareHREntity : NSObject

@property (nonatomic, copy) NSString *itemId;// 白名单id(这一条的唯一id)
@property (nonatomic, copy) NSString *uid;// 被推荐人id(人才的)
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSArray  *appraise;
@property (nonatomic, copy) NSString *top_salary;
@property (nonatomic, copy) NSString *rid;// 推荐人id(自己的)
@property (nonatomic, copy) NSString *cstatus;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *low_salary;
@property (nonatomic, copy) NSString *mstatus;
@property (nonatomic, copy) NSString *posi_name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *restatus;

@property (nonatomic, copy) NSString *hrstart;//1、人才未被推荐；2、人才已被推荐

// 是否选择
@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)ShareHREntityWithDict:(NSDictionary *)dict;

@end
