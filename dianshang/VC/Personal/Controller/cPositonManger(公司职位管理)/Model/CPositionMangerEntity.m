//
//  CPositionMangerEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CPositionMangerEntity.h"

@implementation CPositionMangerEntity

+ (instancetype)CPositionEntityWithDict:(NSDictionary *)dict
{
    CPositionMangerEntity *obj = [[CPositionMangerEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

//- (void)setEdu:(NSString *)edu
//{
//    _edu = [[EZPublicList getEducationList] objectAtIndex:[edu integerValue]];
//}

//- (void)setExprience:(NSString *)exprience
//{
//    _exprience = [[EZPublicList getExperienceList] objectAtIndex:[exprience integerValue]];
//}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }
}

@end
