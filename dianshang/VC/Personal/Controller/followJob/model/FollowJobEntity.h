//
//  FollowJobEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowJobEntity : NSObject

@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *exprience;
@property (nonatomic, copy) NSString *consultant;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *cvedit;
@property (nonatomic, copy) NSString *puid;
@property (nonatomic, copy) NSString *pay;
@property (nonatomic, copy) NSString *probation;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *createtime;

+ (instancetype)FollowJobEntityWithDict:(NSDictionary *)dict;

@end
