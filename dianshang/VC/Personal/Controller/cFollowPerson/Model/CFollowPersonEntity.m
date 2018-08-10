//
//  CFollowPersonEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/12/4.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CFollowPersonEntity.h"

@implementation CFollowPersonEntity

+ (instancetype)CFollowPersonEntityWithDict:(NSDictionary *)dict
{
    CFollowPersonEntity *obj = [[CFollowPersonEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
