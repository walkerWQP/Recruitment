//
//  FollowJobEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "FollowJobEntity.h"

@implementation FollowJobEntity


+ (instancetype)FollowJobEntityWithDict:(NSDictionary *)dict
{
    FollowJobEntity *obj = [[FollowJobEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
