//
//  EnclosureViewController.h
//  dianshang
//
//  Created by yunjobs on 2018/2/1.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@class ResumeManageEntity;

@interface EnclosureViewController : YQViewController

@property (nonatomic, strong) ResumeManageEntity *rmEntity;

@property (nonatomic, strong) void(^refreshUI)();

@end
