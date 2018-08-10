//
//  YQDowndropView.h
//  CustomTable
//
//  Created by yunjobs on 2017/10/24.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQDowndropItem.h"
#import "YQDowndropConst.h"

@interface YQDowndropView : UIView

// 设置下拉View的数据
@property (nonatomic, strong) NSMutableArray<YQDowndropItem *> *item;

// 选择条件的回调
@property (nonatomic, strong) void(^refreshTableList)(NSArray<YQSingleTableViewItem *> *array, NSInteger index);

- (void)downdropViewRefreshUI:(YQDowndropItem *)subItem index:(NSInteger)index;

// 收起子视图
- (void)closeAllSubView;

// 移除子控件
- (void)removeSubView;

@end
