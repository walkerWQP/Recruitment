//
//  DetailRecord.m
//  dianshang
//
//  Created by yunjobs on 2017/9/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DetailRecordEntity.h"

@implementation DetailRecordEntity

+ (instancetype)entityWithDict:(NSDictionary *)dict
{
    DetailRecordEntity *obj = [[DetailRecordEntity alloc] init];
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
