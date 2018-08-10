//
//  MemberDetailEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "MemberDetailEntity.h"
#import "HomeJobEntity.h"

@implementation MemberDetailEntity

+ (instancetype)MemberDetailEntityWithDict:(NSDictionary *)dict
{
    MemberDetailEntity *obj = [[MemberDetailEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }
}

- (void)setPositions:(NSMutableArray *)positions
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in positions) {
        HomeJobEntity *en = [HomeJobEntity HomeJobEntityWithDict:dict];
        [array addObject:en];
    }
    _positions = array;
}

@end
