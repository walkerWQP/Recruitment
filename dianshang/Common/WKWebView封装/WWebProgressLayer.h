//
//  WWebProgressLayer.h
//  dianshang
//
//  Created by yunjobs on 2018/4/19.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface WWebProgressLayer : CAShapeLayer

/** 开始加载 */
- (void)w_startLoad;

/** 完成加载 */
- (void)w_finishedLoadWithError:(NSError *)error;

/** 关闭时间 */
- (void)w_closeTimer;

- (void)w_WebViewPathChanged:(CGFloat)estimatedProgress;

@end
