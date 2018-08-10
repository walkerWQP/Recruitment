//
//  UITableViewCell+YQIndexPath.h
//  kuainiao
//
//  Created by yunjobs on 16/8/17.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (YQIndexPath)

/// 根据view(控件视图)获取在当前表(tableView)的索引
- (NSIndexPath *)indexPathWithView:(UIView *)view;

@end
