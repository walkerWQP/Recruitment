//
//  HomeJobEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "HomeJobEntity.h"

@implementation HomeJobEntity

+ (instancetype)HomeJobEntityWithDict:(NSDictionary *)dict
{
    HomeJobEntity *obj = [[HomeJobEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    //NSLog(@"%s",__FUNCTION__);
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _uid = value;
    }else if ([key isEqualToString:@"mid"]) {
        _uid = value;
    }
}
@end
