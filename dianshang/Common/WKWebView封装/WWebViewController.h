//
//  WWebViewController.h
//  dianshang
//
//  Created by yunjobs on 2018/4/19.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@interface WWebViewController : YQViewController

/** 相关链接*/
@property (nonatomic, copy) NSString *url;

/** 标题 */
@property (nonatomic, copy) NSString *webTitle;

/** 进度条颜色 */
@property (nonatomic, assign) UIColor *progressColor;

@end
