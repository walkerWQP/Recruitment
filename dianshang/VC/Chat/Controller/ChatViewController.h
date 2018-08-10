//
//  ChatViewController.h
//  huanxin
//
//  Created by yunjobs on 2017/10/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EaseMessageViewController.h"

@interface ChatViewController : EaseMessageViewController<EaseMessageViewControllerDataSource,EaseMessageViewControllerDelegate>

//@property (nonatomic, strong) NSString *hx_username;

@property (nonatomic, strong) NSString *isFastStr;
@property (nonatomic, strong) NSString *talentHx_username;

@end
