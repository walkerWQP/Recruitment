//
//  EZCPersonCenterEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/12/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EZCPersonCenterEntity.h"

@implementation EZCPersonCenterEntity

+ (instancetype)entityWithDict:(NSDictionary *)dict
{
    EZCPersonCenterEntity *obj = [[EZCPersonCenterEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setEdu:(NSString *)edu
{
    _edu = [[EZPublicList getEducationList] objectAtIndex:[edu integerValue]];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }else if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
}

- (void)setCompany:(NSDictionary *)company
{
    _company = company;
    
    _companyEn = [EZCompanyInfoEntity entityWithDict:company];
}

@end

@implementation EZCompanyInfoEntity

+ (instancetype)entityWithDict:(NSDictionary *)dict
{
    EZCompanyInfoEntity *obj = [[EZCompanyInfoEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }
}
//- (NSString *)teaminfo
//{
//    return _team;
//}

@end
