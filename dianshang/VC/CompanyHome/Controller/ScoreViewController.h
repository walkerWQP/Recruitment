//
//  ScoreViewController.h
//  dianshang
//
//  Created by yunjobs on 2017/12/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@interface ScoreViewController : YQViewController

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *shareid;
@property (nonatomic, strong) void(^backBlock)();

@end
