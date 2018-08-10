//
//  CFollowPersonalController.h
//  dianshang
//
//  Created by yunjobs on 2017/12/4.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQRefreshTableViewController.h"

@class CompanyHomeEntity;

@protocol FollowPersonalDelegate <NSObject>

- (void)didFollowPersonalDelegate:(CompanyHomeEntity *)entity;

@end


@interface CFollowPersonalController : YQRefreshTableViewController

@property (nonatomic, weak) id<FollowPersonalDelegate> delegate;

@end
