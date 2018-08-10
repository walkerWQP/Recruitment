//
//  DeliveryJobEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryJobEntity : NSObject

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *positionid;
@property (nonatomic, copy) NSString *exprience;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *puid;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *paytop;
@property (nonatomic, copy) NSString *paylow;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pname;

+ (instancetype)DeliveryJobEntityWithDict:(NSDictionary *)dict;

@end
