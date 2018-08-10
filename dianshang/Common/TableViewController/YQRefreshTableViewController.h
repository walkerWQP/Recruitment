//
//  YQRefreshTableViewController.h
//  kuainiao
//
//  Created by yunjobs on 16/8/22.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@interface YQRefreshTableViewController : YQTableViewController

@property (nonatomic, assign) BOOL isPullDown;//是否是下拉刷新 YES:下拉,NO:上拉

-(void)setupRefresh;

- (void)headerRereshing;

- (void)footerRereshing;

//结束刷新
- (void)endRereshingCustom;

@end
