//
//  PromptViewController.m
//  kuainiao
//
//  Created by yunjobs on 16/4/8.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "PromptViewController.h"
#import "YQSettingSwitchItem.h"
#import "YQGroupCellItem.h"
#import "JPushManager.h"

@interface PromptViewController ()

@end

@implementation PromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息提醒";
    
    [self setUpdata];
    
    [self initView];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    YQSettingSwitchItem *item1 = [YQSettingSwitchItem setCellItemImage:nil title:@"声音提示"];
    item1.isOn = [[UserEntity soundStatus] isEqualToString:@"1"] ? YES : NO;
    [items addObject:item1];
    
    YQSettingSwitchItem *item2 = [YQSettingSwitchItem setCellItemImage:nil title:@"振动提示"];
    item2.isOn = [[UserEntity vibrationStatus] isEqualToString:@"1"] ? YES : NO;
    [items addObject:item2];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:nil];
    
    [self.groups addObject:group];
}

- (void)initView
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 15)];
    [self.view addSubview:self.tableView];
}

#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQTableViewCell *cell = [YQTableViewCell cellWithTableView:tableView tableViewCellStyle:YQTableViewCellStyleValue1];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.item = item;
    
    [cell switchChange:^(NSIndexPath *indexPath) {
        [self switchAction:indexPath.row];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)switchAction:(NSInteger)tag
{
    if (tag == 0) {
        if ([[UserEntity soundStatus] isEqualToString:@"1"]) {
            [UserEntity setSoundStatus:@"0"];//不选中
        }else{
            [UserEntity setSoundStatus:@"1"];//选中
            [[JPushManager shareJPushManager] playSound];
        }
    }else if (tag == 1){
        //Vibration//振动
        if ([[UserEntity vibrationStatus] isEqualToString:@"1"]) {
            [UserEntity setVibrationStatus:@"0"];//不选中
        }else{
            [UserEntity setVibrationStatus:@"1"];//选中
            [[JPushManager shareJPushManager] playVibrate];
        }
    }
}

@end
