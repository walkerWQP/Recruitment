//
//  NSTimer+addition.h
//  dianshang
//
//  Created by yunjobs on 2018/4/19.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (addition)

/** 暂停时间 */
- (void)w_pauseTime;
/** 获取内容所在当前时间 */
- (void)w_webPageTime;
/** 当前时间 time 秒后的时间 */
- (void)w_webPageTimeWithTimeInterval:(NSTimeInterval)time;

@end
