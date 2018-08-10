//
//  YQSingleTableView.h
//  CustomTable
//
//  Created by yunjobs on 2017/10/25.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQDowndropItem;

@interface YQDDSingleTableView : UIView

- (instancetype)initWithFrame:(CGRect)frame downdropItem:(YQDowndropItem *)item;

@property (nonatomic, strong) void(^selectIndexPath)(YQDDSingleTableView *singleTableView, NSIndexPath *path);

@property (nonatomic, strong) void(^FootViewBlock)(YQDDSingleTableView *singleTableView);

- (void)refreshTable:(YQDowndropItem *)item;

// 返回cell的高度
+ (NSInteger)cellHeight;

@end
