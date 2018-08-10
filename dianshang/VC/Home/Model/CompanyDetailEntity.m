//
//  CompanyDetailEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyDetailEntity.h"
#import "NSString+YQWidthHeight.h"

@implementation CompanyDetailEntity

+ (instancetype)entityWithDict:(NSDictionary *)dict
{
    CompanyDetailEntity *obj = [[CompanyDetailEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end


@implementation CDescItem

- (void)setDesc:(NSString *)desc
{
    _desc = desc;
    
    _height = [desc yq_stringHeightWithFixedWidth:APP_WIDTH-40 font:15];
    
}

@end
