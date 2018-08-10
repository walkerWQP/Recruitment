//
//  BusinessEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/12/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "BusinessEntity.h"

@implementation BusinessEntity

+ (instancetype)entityWithDict:(NSDictionary *)dict
{
    BusinessEntity *obj = [[BusinessEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    //NSLog(@"%s",__FUNCTION__);
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }else if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
}

- (NSString *)thumb
{
    return _imgurl[@"thumb"];
}

@end
