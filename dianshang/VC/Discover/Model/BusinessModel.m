//
//  BusinessModel.m
//  dianshang
//
//  Created by yunjobs on 2018/4/16.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "BusinessModel.h"

@implementation BusinessModel

+ (instancetype)BusinessModelWithDict:(NSDictionary *)dict
{
    BusinessModel *obj = [[BusinessModel alloc] init];
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
