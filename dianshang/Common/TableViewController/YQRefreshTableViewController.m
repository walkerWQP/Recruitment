//
//  YQRefreshTableViewController.m
//  kuainiao
//
//  Created by yunjobs on 16/8/22.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQRefreshTableViewController.h"

@interface YQRefreshTableViewController ()

@end

@implementation YQRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setupRefresh];
}

-(void)setupRefresh
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isPullDown = YES;
        [weakSelf headerRereshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isPullDown = NO;
        [weakSelf footerRereshing];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRereshing
{
    
}

- (void)footerRereshing
{
    
}

- (void)endRereshingCustom
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


@end
