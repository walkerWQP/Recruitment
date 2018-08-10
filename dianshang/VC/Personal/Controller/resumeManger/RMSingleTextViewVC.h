//
//  RMSingleTextViewVC.h
//  dianshang
//
//  Created by yunjobs on 2017/11/13.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@interface RMSingleTextViewVC : YQViewController

// 标识
@property (nonatomic, assign) BOOL isSave;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) void(^textViewBlock)(NSString *text);

@end
