//
//  NSString+MyDate.m
//  kuainiao
//
//  Created by yunjobs on 16/5/10.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "NSString+MyDate.h"

@implementation NSString (MyDate)

+ (NSString *)dateToString:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    return [format stringFromDate:date];
}

+ (NSDate *)stringToDate:(NSString *)string formatter:(NSString *)formatter
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    return [format dateFromString:string];
}


/*!
 *  @brief 时间戳格式化字符串
 *
 *  @param timeStamp 时间戳
 *  @param formatter 格式
 *
 *  @return 字符串
 */
+ (NSString *)timeStampToString:(NSString *)timeStamp formatter:(NSString *)formatter
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    return [format stringFromDate:confromTimesp];
}

/*!
 *  @brief 字符串格式化时间戳
 *
 *  @param string    字符串
 *  @param formatter 格式
 *
 *  @return 时间戳
 */
+ (NSString *)stringToTimeStamp:(NSString *)string formatter:(NSString *)formatter
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    return [NSString stringWithFormat:@"%ld", (long)[[format dateFromString:string] timeIntervalSince1970]];
}

// 获取当前13位时间戳
+ (NSString *)timeStamp13
{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
}

@end
