//
//  YQCustomSendWXMessageCell.h
//  huanxin
//
//  Created by yunjobs on 2017/10/12.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

/** @brief 自定义交换微信发送Cell */

@interface YQCustomSendWXMessageCell : UITableViewCell


@property (strong, nonatomic) NSString *title;

/*
 *  时间显示字体
 */
@property (nonatomic) UIFont *titleLabelFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12]

/*
 *  时间显示颜色
 */
@property (nonatomic) UIColor *titleLabelColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor]

+ (NSString *)cellIdentifier;

+ (CGFloat)cellHeight;

@end
