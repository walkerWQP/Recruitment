//
//  YQTableViewController.h
//  kuainiao
//
//  Created by yunjobs on 16/5/18.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

#import "YQGroupCellItem.h"
#import "YQCellItem.h"
#import "YQTableViewCell.h"

#import "PersonItem.h"
#import "YQSettingSwitchItem.h"

@interface YQTableViewController : YQViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) YQTableViewCellStyle cellStyle;

@property (nonatomic, strong) NSMutableArray *tableArr;

@property (nonatomic, strong) NSMutableArray *groups;

@property (nonatomic, strong) UITableView *tableView;

@end
