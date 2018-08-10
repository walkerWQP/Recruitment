//
//  RecommendPersonEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RecommendPersonEntity.h"

@implementation RecommendPersonEntity

+ (instancetype)RecommendPersonEntityWithDict:(NSDictionary *)dict
{
    RecommendPersonEntity *obj = [[RecommendPersonEntity alloc] init];
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
