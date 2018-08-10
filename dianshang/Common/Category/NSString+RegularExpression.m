//
//  NSString+RegularExpression.m
//  face
//
//  Created by yunjobs on 16/9/6.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString (RegularExpression)

- (NSRange)firstMatchRangeWithPattern:(NSString *)pattern
{
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"正则创建失败");
        return NSMakeRange(0, 0);
    }
    
    NSTextCheckingResult *result = [regular firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (result == nil) {
        NSLog(@"没有匹配结果");
        return NSMakeRange(0, 0);
    }
    
    return result.range;
}

- (NSString *)firstMatchStringWithPattern:(NSString *)pattern
{
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"正则创建失败");
        return nil;
    }
    
    NSTextCheckingResult *result = [regular firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (result == nil) {
        NSLog(@"没有匹配结果");
        return nil;
    }
    
    return [self substringWithRange:result.range];
}

- (NSArray <NSString *> *)matchesStringWithPattern:(NSString *)pattern
{
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    NSArray <NSTextCheckingResult *> *resultArray = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (resultArray.count == 0) {
        NSLog(@"没有匹配结果");
        return nil;
    }
    
    NSMutableArray *tempArrM = [NSMutableArray array];
    // 从每个Result当中获取子字符串
    for (NSTextCheckingResult *result in resultArray) {
        NSString *subString = [self substringWithRange:result.range];
        [tempArrM addObject:subString];
    }
    
    return [tempArrM copy];
}

- (NSArray<NSValue *> *)matchesRangeWithPattern:(NSString *)pattern
{
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    NSArray <NSTextCheckingResult *> *resultArray = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (resultArray.count == 0) {
        //NSLog(@"没有匹配结果");
        return nil;
    }
    
    NSMutableArray *tempArrM = [NSMutableArray array];
    // 从每个Result当中获取 包装了Range的NSValue
    for (NSTextCheckingResult *result in resultArray) {
        NSValue *value = [NSValue valueWithRange:result.range];
        [tempArrM addObject:value];
    }
    
    return [tempArrM copy];
}
/*!
 *  @brief 正则判断手机号
 *
 *
 *  @return 是否是正确的手机号
 */
- (BOOL)checkPhoneNum
{
    NSString *regex = @"^((13[0-9])|(147)|(17[0-9])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
/*!
 *  @brief 正则判断身份证号
 *
 *
 *  @return 是否是正确的身份证号
 */
- (BOOL)checkCardID
{
    NSString *regex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
@end
