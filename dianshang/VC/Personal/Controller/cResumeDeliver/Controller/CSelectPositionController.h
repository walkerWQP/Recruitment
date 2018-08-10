//
//  CSelectPositionController.h
//  dianshang
//
//  Created by yunjobs on 2017/12/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@interface CSelectPositionController : YQTableViewController

@property (nonatomic, strong) NSString *pName;

@property (nonatomic, strong) void(^selectBlock)(NSString *positionName);

@end
