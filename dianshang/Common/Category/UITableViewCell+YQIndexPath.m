//
//  UITableViewCell+YQIndexPath.m
//  kuainiao
//
//  Created by yunjobs on 16/8/17.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "UITableViewCell+YQIndexPath.h"

@implementation UITableViewCell (YQIndexPath)

- (NSIndexPath *)indexPathWithView:(UIView *)view
{
    UITableView *table = nil;
    UITableViewCell *cell = nil;
    
    while (view != nil && ![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    cell = (UITableViewCell *)view;
    
    while (view != nil && ![view isKindOfClass:[UITableView class]]) {
        view = [view superview];
    }
    table = (UITableView *)view;
    
    if (cell != nil && table != nil) {
        return [table indexPathForCell:cell];
    }else{
        return nil;
    }
}

@end
