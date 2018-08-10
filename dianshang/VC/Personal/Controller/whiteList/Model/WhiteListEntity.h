//
//  WhiteListEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhiteListEntity : NSObject

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *top_salary;
@property (nonatomic, copy) NSString *rid;
@property (nonatomic, copy) NSString *cstatus;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *low_salary;
@property (nonatomic, copy) NSString *mstatus;
@property (nonatomic, copy) NSString *posi_name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *appraise;
@property (nonatomic, copy) NSString *phone;

+ (instancetype)WhiteListEntityWithDict:(NSDictionary *)dict;

@end
