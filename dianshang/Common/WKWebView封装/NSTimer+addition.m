//
//  NSTimer+addition.m
//  dianshang
//
//  Created by yunjobs on 2018/4/19.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "NSTimer+addition.h"

@implementation NSTimer (addition)

- (void)w_pauseTime{
    //判断定时器是否有效
    if (!self.isValid)  {
        return;
    }
    //停止计时器
    [self  setFireDate:[NSDate distantFuture]];
}
- (void)w_webPageTime{
    //判断定时器是否有效
    if (!self.isValid)  {
        return;
    }
    //返回当期时间
    [self setFireDate:[NSDate date]];
}
- (void)w_webPageTimeWithTimeInterval:(NSTimeInterval)time{
    //判断定时器是否有效
    if (!self.isValid)  {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}

@end
