//
//  WhiteListQueryController.h
//  dianshang
//
//  Created by yunjobs on 2017/12/1.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@interface WhiteListQueryController : YQTableViewController

@property (nonatomic, strong) void(^refreshTableBlock)();

@end
