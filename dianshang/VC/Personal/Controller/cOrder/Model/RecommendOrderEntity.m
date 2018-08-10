//
//  RecommendOrderEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/12/15.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RecommendOrderEntity.h"

@implementation RecommendOrderEntity

+ (instancetype)entityWithDict:(NSDictionary *)dict
{
    RecommendOrderEntity *obj = [[RecommendOrderEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}

- (void)setBystages:(NSDictionary *)bystages
{
    _bystages = bystages;
    
    _subOrder = [COrderBystagesEntity entityWithDict:bystages];
}

@end

@implementation COrderBystagesEntity

+ (instancetype)entityWithDict:(NSDictionary *)dict
{
    COrderBystagesEntity *obj = [[COrderBystagesEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }
}
@end
