//
//  YQPayDetailFilterView.h
//  kuainiao
//
//  Created by yunjobs on 16/12/15.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQPayDetailFilterView : UIView

@property (nonatomic, strong) void(^buttonPress)(NSInteger index, BOOL isReset);
- (void)buttonPress:(void(^)(NSInteger index, BOOL isReset))block;

- (void)showAnimate;
- (void)hideAnimate;
@end
