//
//  YQCellItem.h
//  kuainiao
//
//  Created by yunjobs on 16/8/8.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQCellItem : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, strong) NSString *timeStr;

// 是否选中
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) void(^operationBlock)();

+ (instancetype)setCellItemImage:(NSString *)image title:(NSString *)title;
//+ (instancetype)setCellItemImage:(NSString *)image title:(NSString *)title subTitle:(NSString *)subTitle;
//+ (instancetype)setCellItemImage:(NSString *)image title:(NSString *)title subTitle:(NSString *)subTitle operationBlock:(void(^)())block;
@end
