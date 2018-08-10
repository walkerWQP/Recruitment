//
//  YQHotCityCell.h
//  dianshang
//
//  Created by yunjobs on 2017/9/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQHotCityCell;

@protocol hotCellDelegate <NSObject>

/// 点击hotcell子控件执行
- (void)hotCell:(YQHotCityCell *)hotCell didSelectCellAtCityDict:(NSDictionary *)dict;

@end

@interface YQHotCityCell : UITableViewCell

@property (nonatomic, weak) id<hotCellDelegate> delegate;

- (void)setHotCell:(NSArray *)arr;

//@property (nonatomic, strong) void (^hotCity)(NSString *str);
//- (void)hotCity:(void (^)(NSString *str))block;

@end


