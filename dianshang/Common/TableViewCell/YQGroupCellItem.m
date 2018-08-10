//
//  YQGroupCellItem.m
//  kuainiao
//
//  Created by yunjobs on 16/8/8.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQGroupCellItem.h"

@implementation YQGroupCellItem

+ (instancetype)setGroupItems:(NSMutableArray *)items headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    YQGroupCellItem *group = [[self alloc] init];
    
    group.items = items;
    group.headerTitle = headerTitle;
    group.footerTitle = footerTitle;
    
    return group;
}

@end
