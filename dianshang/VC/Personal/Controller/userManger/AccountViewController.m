//
//  AccountViewController.m
//  kuainiao
//
//  Created by yunjobs on 16/4/1.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "AccountViewController.h"

//#import "SetPayPassVC.h"
//#import "ChangePhoneNumVC.h"
//#import "ChangePassViewController.h"
//#import "YQPayPasswordController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账户安全";
    
    [self setUpdata];
    
    [self initView];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:nil];
    
    [self.groups addObject:group];
}

- (void)initView
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 15)];
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
//    PersonItem *item = [group.items objectAtIndex:indexPath.row];
//    
//    if ([item.title isEqualToString:@"设置支付密码"]) {
//        if ([[UserEntity hasPaypass] isEqualToString:@"0"]) {
//            [self pushVC:item];
//        }else{
//            [LToast showWithText:@"您已经设置过支付密码" bottomOffset:100];
//        }
//    }else if ([item.title isEqualToString:@"修改支付密码"]) {
//        if ([[UserEntity hasPaypass] isEqualToString:@"1"]) {
//            [self pushVC:item];
//        }else{
//            [LToast showWithText:@"您还没有设置过支付密码" bottomOffset:100];
//        }
//    }else{
//        [self pushVC:item];
//    }
}
- (void)pushVC:(PersonItem *)item
{
    if (item.pushController) {
        UIViewController *renzhengVC = [[item.pushController alloc] init];
        renzhengVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:renzhengVC animated:YES];
    }
}

@end
