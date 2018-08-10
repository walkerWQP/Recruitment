//
//  CompanyHomeEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyHomeEntity.h"
#import "NSString+MyDate.h"

@implementation CompanyHomeEntity

+ (instancetype)CompanyHomeEntityWithDict:(NSDictionary *)dict
{
    CompanyHomeEntity *obj = [[CompanyHomeEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (NSString *)salary
{
    if ([self.top_salary isEqualToString:@"0"]) {
        return @"面议";
    }
    NSString *str = [NSString stringWithFormat:@"%@-%@k",self.low_salary,self.top_salary];
    return str;
}
- (NSString *)workStr
{
    NSString *date = [NSString dateToString:[NSDate date] formatter:@"YYYY"];
    NSString *str = [NSString stringWithFormat:@"%li",[date integerValue]-[self.year integerValue]];
    return str;
}

- (void)setEdu:(NSString *)edu
{
    _edu = [[EZPublicList getEducationList] objectAtIndex:[edu integerValue]];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }else if ([key isEqualToString:@"mid"]) {
        _itemId = value;
    }else if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
}

@end
