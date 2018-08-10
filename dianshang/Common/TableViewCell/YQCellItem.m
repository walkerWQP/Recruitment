//
//  YQCellItem.m
//  kuainiao
//
//  Created by yunjobs on 16/8/8.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQCellItem.h"

@implementation YQCellItem

+ (instancetype)setCellItemImage:(NSString *)image title:(NSString *)title
{
    YQCellItem *item = [[self alloc] init];
    item.image = image;
    item.title = title;
    return item;
}

//+ (instancetype)setCellItemImage:(NSString *)image title:(NSString *)title subTitle:(NSString *)subTitle
//{
//    return [YQCellItem setCellItemImage:image title:title subTitle:subTitle operationBlock:nil];
//}
//
//+ (instancetype)setCellItemImage:(NSString *)image title:(NSString *)title subTitle:(NSString *)subTitle operationBlock:(void(^)())block
//{
//    YQCellItem *item = [[self alloc] init];
//    item.image = image;
//    item.title = title;
//    item.operationBlock = block;
//    item.subTitle = subTitle;
//    return item;
//}

@end
