//
//  YQCustomRecvResumeCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EaseBaseMessageCell.h"

@protocol YQCustomRecvResumeDelegate;

@interface YQCustomRecvResumeCell : EaseBaseMessageCell

@property (weak, nonatomic) id<YQCustomRecvResumeDelegate> recvResumeDelegate;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end

@protocol YQCustomRecvResumeDelegate <NSObject>

@optional

/// 查看微简历点击
- (void)recvResumeClick:(id<IMessageModel>)model;

@end
