//
//  WhiteListEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "WhiteListEntity.h"

@implementation WhiteListEntity

+ (instancetype)WhiteListEntityWithDict:(NSDictionary *)dict
{
    WhiteListEntity *obj = [[WhiteListEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }
}


@end
