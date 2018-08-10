//
//  CompanyDetailEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDetailEntity : NSObject

@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *cvedit;
@property (nonatomic, copy) NSString *companyinfo;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *teaminfo;
@property (nonatomic, copy) NSString *productinfo;
@property (nonatomic, copy) NSString *link;

+ (instancetype)entityWithDict:(NSDictionary *)dict;

@end


@interface CDescItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) BOOL isOpen;

@end
