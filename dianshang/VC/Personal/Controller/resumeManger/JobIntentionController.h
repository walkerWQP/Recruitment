//
//  JobIntentionController.h
//  dianshang
//  求职意向
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@interface JobIntentionController : YQTableViewController

@property (nonatomic, strong) NSMutableArray *hopworkList;

@property (nonatomic, strong) void(^jobIntentionBlock)();

@property (nonatomic, assign) BOOL isback;

@end
