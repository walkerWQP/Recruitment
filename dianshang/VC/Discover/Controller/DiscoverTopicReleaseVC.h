//
//  DiscoverTopicReleaseVC.h
//  dianshang
//
//  Created by yunjobs on 2017/11/15.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@interface DiscoverTopicReleaseVC : YQViewController

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *text;
// 1、合伙人；2、职场
@property (nonatomic, strong) NSString *isdefault;

@property (nonatomic, strong) void(^releaseSuccessBlock)(NSString *text);

@end
