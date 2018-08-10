//
//  NSString+RegularExpression.h
//  face
//
//  Created by yunjobs on 16/9/6.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpression)

/**
 *  匹配第一个符合正则语法的结果, 返回匹配的结果(字符串)
 *
 *  @param pattern 正则语法
 *
 *  @return 返回第一个匹配的字符串, 如果没有则返回nil
 */
- (NSString *)firstMatchStringWithPattern:(NSString *)pattern;

// 匹配第一个符合正则语法的结果, 返回匹配的结果(原字符串中的范围)
- (NSRange)firstMatchRangeWithPattern:(NSString *)pattern;

// 匹配所有符合正则语法的结果, 返回匹配的结果(字符串)
- (NSArray <NSString *> *)matchesStringWithPattern:(NSString *)pattern;

// 匹配所有符合正则语法的结果, 返回匹配的结果(原字符串中的范围)
- (NSArray <NSValue *> *)matchesRangeWithPattern:(NSString *)pattern;

/*!
 *  @brief 正则判断手机号
 *
 *
 *  @return 是否是正确的手机号
 */
- (BOOL)checkPhoneNum;
/*!
 *  @brief 正则判断身份证号
 *
 *
 *  @return 是否是正确的身份证号
 */
- (BOOL)checkCardID;
@end
