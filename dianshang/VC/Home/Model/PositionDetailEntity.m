//
//  PositionDetailEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/22.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "PositionDetailEntity.h"

@implementation PositionDetailEntity

+ (instancetype)PositionDetailEntityWithDict:(NSDictionary *)dict
{
    PositionDetailEntity *obj = [[PositionDetailEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setCtag:(NSString *)ctag
{
    _ctag = [ctag stringByReplacingOccurrencesOfString:@"," withString:@" | "];
}

- (NSString *)salary
{
    if ([self.paytop isEqualToString:@"0"]) {
        return @"面议";
    }else{
        return [NSString stringWithFormat:@"%@-%@k",self.paylow,self.paytop];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _positionid = value;
    }
}

@end
