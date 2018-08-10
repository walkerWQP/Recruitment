//
//  DeliveryJobEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DeliveryJobEntity.h"

@implementation DeliveryJobEntity

+ (instancetype)DeliveryJobEntityWithDict:(NSDictionary *)dict
{
    DeliveryJobEntity *obj = [[DeliveryJobEntity alloc] init];
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
