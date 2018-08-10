//
//  WithdrawalsController.h
//  dianshang
//
//  Created by yunjobs on 2017/9/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@interface WithdrawalsController : YQTableViewController

@property (nonatomic, strong) void(^refreshBalance)(NSString *balance);

@end
