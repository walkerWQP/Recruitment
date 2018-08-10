//
//  YQCustomSendResumeCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EaseBaseMessageCell.h"

@protocol YQCustomSendResumeDelegate;

@interface YQCustomSendResumeCell : EaseBaseMessageCell

@property (weak, nonatomic) id<YQCustomSendResumeDelegate> sendResumeDelegate;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end

@protocol YQCustomSendResumeDelegate <NSObject>

@optional

/// 查看微简历点击
- (void)sendResumeClick:(id<IMessageModel>)model;

@end
