//
//  DiscoverDetailController.h
//  dianshang
//
//  Created by yunjobs on 2017/11/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQRefreshTableViewController.h"

@class YQDiscover;
@interface DiscoverDetailController : YQRefreshTableViewController

@property (nonatomic, strong) YQDiscover *discover;
// 是否评论 默认否
@property (nonatomic, assign) BOOL isComment;
// 点赞/转发/评论成功后回调
@property (nonatomic, strong) void(^opeationSuccessBlock)(NSString *text);

@end
