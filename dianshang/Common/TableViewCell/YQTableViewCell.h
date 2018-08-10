//
//  YQTableViewCell.h
//  kuainiao
//
//  Created by yunjobs on 16/8/22.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

/// 扩展需要cellStyle 类型
typedef NS_ENUM(NSInteger, YQTableViewCellStyle) {
    YQTableViewCellStyleDefault,	// Simple cell with text label and optional image view (behavior of UITableViewCell in iPhoneOS 2.x)
    YQTableViewCellStyleValue1,		// Left aligned label on left and right aligned label on right with blue text (Used in Settings)
    YQTableViewCellStyleValue2,		// Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
    YQTableViewCellStyleValue3,
    YQTableViewCellStyleBgImage,    // 带有背景的cell
    YQTableViewCellStyleSubtitle	// Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).
};             // available in iPhone OS 3.0


#import <UIKit/UIKit.h>
#import "YQCellItem.h"

@interface YQTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView tableViewCellStyle:(YQTableViewCellStyle)tableViewCellStyle;

@property (nonatomic, strong) YQCellItem *item;

//开关事件

@property (nonatomic, strong) void(^switchChange)(NSIndexPath *indexPath);

- (void)switchChange:(void(^)(NSIndexPath *indexPath))block;

@end
