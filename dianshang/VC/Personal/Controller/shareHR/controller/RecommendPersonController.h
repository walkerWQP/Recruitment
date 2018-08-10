//
//  RecommendPersonController.h
//  dianshang
//  推荐人才
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQRefreshTableViewController.h"

@class ShareHREntity;
@interface RecommendPersonController : YQRefreshTableViewController

@property (nonatomic, strong) ShareHREntity *shareEntity;

@property (nonatomic, strong) void(^recommendSuccess)(ShareHREntity *shareEntity);

@end
