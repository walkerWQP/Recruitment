//
//  YQDiscoverComment.m
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQDiscoverComment.h"

@implementation YQDiscoverComment

+ (instancetype)DiscoverCommentWithDict:(NSDictionary *)dict
{
    YQDiscoverComment *obj = [[YQDiscoverComment alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _uid = value;
    }else if ([key isEqualToString:@"tc_praise"]) {
        //NSString *str = value;
        _isPraise = [value isEqualToString:@"1"];
    }else if ([key isEqualToString:@"hot"]){
        _hot_count = [value integerValue];
    }
}

- (void)setDesc:(NSString *)desc
{
    _desc = desc;
    _commentText = desc;
}

@end
