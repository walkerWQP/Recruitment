//
//  YQTableViewController.m
//  kuainiao
//
//  Created by yunjobs on 16/5/18.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@interface YQTableViewController ()



@end

@implementation YQTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.cellStyle = YQTableViewCellStyleValue1;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = [[UIView alloc] init];
        //去除表格线在左端留有的空白（在viewDidLoad中添加）
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _tableView = tableView;
        
        if (IOS_VERSION_11_OR_ABOVE) {
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _tableView;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (NSMutableArray *)tableArr
{
    if (_tableArr == nil) {
        _tableArr = [NSMutableArray array];
    }
    return _tableArr;
}

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.groups.count==0&&self.tableArr.count!=0) {
        return 1;
    }
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YQGroupCellItem *group = [self.groups objectAtIndex:section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQTableViewCell *cell = [YQTableViewCell cellWithTableView:tableView tableViewCellStyle:self.cellStyle];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.item = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    if (item.operationBlock) {
        item.operationBlock();
    }
    if ([item isKindOfClass:[PersonItem class]]) {
        PersonItem *arrowItem = (PersonItem *)item;
        if (arrowItem.pushController) {
            UIViewController *vc = [[arrowItem.pushController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([item isKindOfClass:[YQSettingSwitchItem class]]){
        //YQSettingSwitchItem *switchItem =(YQSettingSwitchItem *) item;
        //NSLog(@"%d",switchItem.isOn);
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        return group.headerTitle;
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        return group.footerTitle;
    }
    return @"";
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        if (![group.headerTitle isEqualToString:@""] && group.headerTitle != nil) {
            UILabel *footView = [[UILabel alloc] init];
            footView.textColor = [UIColor colorWithWhite:0.508 alpha:1.000];
            footView.textAlignment = NSTextAlignmentLeft;
            footView.font = [UIFont systemFontOfSize:13];
            footView.text = group.headerTitle;
            return footView;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        if (![group.footerTitle isEqualToString:@""] && group.footerTitle != nil) {
            UILabel *footView = [[UILabel alloc] init];
            footView.textColor = [UIColor colorWithWhite:0.508 alpha:1.000];
            footView.textAlignment = NSTextAlignmentCenter;
            footView.font = [UIFont systemFontOfSize:13];
            footView.text = group.footerTitle;
            return footView;
        }
    }
    return nil;
}

//去除表格线在左端留有的空白（tableView的代理方法）
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
