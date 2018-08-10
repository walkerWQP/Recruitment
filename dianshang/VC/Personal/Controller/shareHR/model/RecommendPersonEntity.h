//
//  RecommendPersonEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendPersonEntity : NSObject

@property (nonatomic, copy) NSString *itemId;//职位id
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *exprience;
@property (nonatomic, copy) NSString *consultant;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *puid;//发布职位的人的id
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *cvedit;
@property (nonatomic, copy) NSString *paytop;
@property (nonatomic, copy) NSString *paylow;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pname;

// 是否选择
@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)RecommendPersonEntityWithDict:(NSDictionary *)dict;

@end
