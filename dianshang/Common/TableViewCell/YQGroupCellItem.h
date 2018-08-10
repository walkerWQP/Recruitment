//
//  YQGroupCellItem.h
//  kuainiao
//
//  Created by yunjobs on 16/8/8.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQGroupCellItem : NSObject

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSString *headerTitle;

@property (nonatomic, strong) NSString *footerTitle;

@property (nonatomic, strong) NSString *ext;

+ (instancetype)setGroupItems:(NSMutableArray *)items headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

@end
