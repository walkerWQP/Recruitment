//
//  FollowJobController.h
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQRefreshTableViewController.h"

@class HomeJobEntity;

@protocol FollowJobDelegate <NSObject>

- (void)didFollowJobDelegate:(HomeJobEntity *)entity;

@end

@interface FollowJobController : YQRefreshTableViewController

@property (nonatomic, weak) id<FollowJobDelegate> delegate;

@end
