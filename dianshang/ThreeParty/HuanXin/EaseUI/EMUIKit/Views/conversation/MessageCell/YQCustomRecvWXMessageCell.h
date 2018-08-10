//
//  YQCustomRecvWXMessageCell.h
//  huanxin
//
//  Created by yunjobs on 2017/10/12.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EaseBaseMessageCell.h"

/** @brief 自定义交换微信接收Cell */
@protocol YQCustomRecvWXMessageCellDelegate;

@interface YQCustomRecvWXMessageCell : EaseBaseMessageCell

@property (weak, nonatomic) id<YQCustomRecvWXMessageCellDelegate> wxDelegate;

+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;

@end

@protocol YQCustomRecvWXMessageCellDelegate <NSObject>

@optional

/// 0-同意;1-拒绝
- (void)wxButtonClick:(id<IMessageModel>)model buttonIndex:(NSInteger)buttonIndex;

@end
