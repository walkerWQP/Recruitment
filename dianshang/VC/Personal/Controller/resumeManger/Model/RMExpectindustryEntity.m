//
//  RMExpectindustryEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RMExpectindustryEntity.h"

#pragma mark -
#pragma mark - RMExpectindustryEntity

@implementation RMExpectindustryEntity

+ (instancetype)ExpectindustryEntity:(NSDictionary *)dict
{
    RMExpectindustryEntity *obj = [[RMExpectindustryEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _uid = value;
    }
}

@end

#pragma mark -
#pragma mark - RMJobPositionEntity

@implementation RMJobPositionEntity

+ (instancetype)JobPositionEntity:(NSDictionary *)dict
{
    RMJobPositionEntity *obj = [[RMJobPositionEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _uid = value;
    }else if ([key isEqualToString:@"gchild"]){
        self.child = value;
    }
}

- (void)setChild:(NSMutableArray<RMJobPositionEntity *> *)child
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in child) {
        RMJobPositionEntity *obj = [RMJobPositionEntity JobPositionEntity:dict];
        [array addObject:obj];
    }
    _child = array;
}

@end


@implementation RMJobIntentionEntity

+ (instancetype)JobIntentionEntity:(NSDictionary *)dict
{
    RMJobIntentionEntity *obj = [[RMJobIntentionEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _workID = value;
    }
}

@end




