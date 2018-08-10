//
//  MessageEntity.m
//  kuainiao
//
//  Created by yunjobs on 16/4/2.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "MessageEntity.h"

@implementation MessageEntity

+ (instancetype)messageEntityWithDict:(NSDictionary *)dict
{
    MessageEntity *obj = [[MessageEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

//- (NSDictionary *)handerDic:(NSDictionary *)dic
//{
//    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
//    NSNull *abcd = [[NSNull alloc] init];
//    for (NSString *key in dic) {
//        id value = [dic objectForKey:key];
//        if ([value isKindOfClass:[NSNumber class]]) {
//            value = [value stringValue];
//        }else if (value == nil) {
//            value = @"";
//        }else if ([value isEqual:abcd]){
//            value = @"";
//        }else if ([value isKindOfClass:[NSDictionary class]]){
//            value = [UserEntity handerDic:value];
//        }
//        NSString *keykey = key;
//        if ([keykey isEqualToString:@"id"]) {
//            keykey = @"uid";
//        }
//        [mDic setObject:value forKey:keykey];
//    }
//    return mDic;
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }
}

@end
