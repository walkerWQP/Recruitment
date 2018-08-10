//
//  YQCustomAgreeWXMessageCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQCustomAgreeWXMessageCell : UITableViewCell

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
