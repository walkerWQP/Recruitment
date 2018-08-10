//
//  NSString+MyDate.h
//  kuainiao
//  时间戳格式化字符串<-->字符串格式化时间戳
//  Created by yunjobs on 16/5/10.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#define YYYYMMddHHmmss @"YYYY-MM-dd HH:mm"
#define YYYYMMdd @"YYYY-MM-dd"
#define MMddHHmmss @"MM-dd HH:mm"
//#define YYYYMMddHHmmss @"YYYY-MM-dd HH:mm:ss"

#import <Foundation/Foundation.h>

@interface NSString (MyDate)

+ (NSString *)dateToString:(NSDate *)date formatter:(NSString *)formatter;
+ (NSDate *)stringToDate:(NSString *)string formatter:(NSString *)formatter;

/*!
 *  @brief 时间戳格式化字符串
 *
 *  @param timeStamp 时间戳
 *  @param formatter 格式
 *
 *  @return 字符串
 */
+ (NSString *)timeStampToString:(NSString *)timeStamp formatter:(NSString *)formatter;
/*!
 *  @brief 字符串格式化时间戳
 *
 *  @param string    字符串
 *  @param formatter 格式
 *
 *  @return 时间戳
 */
+ (NSString *)stringToTimeStamp:(NSString *)string formatter:(NSString *)formatter;

// 获取当前时间戳13位
+ (NSString *)timeStamp13;

@end
