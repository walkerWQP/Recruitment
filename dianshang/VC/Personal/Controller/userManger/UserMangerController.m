//
//  UserMangerController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "UserMangerController.h"
#import "ChangePhoneNumVC.h"
#import "AccountViewController.h"
#import "CommonProblemVC.h"
#import "ServiceAgreementVC.h"

@interface UserMangerController ()

@end

@implementation UserMangerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助";
    
    [self setUpdata];
    
    [self initView];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    //    PersonItem *item1 = [PersonItem setCellItemImage:nil title:@"账户安全"];
    //    item1.pushController = [AccountViewController class];
    //    [items addObject:item1];
    
    //    PersonItem *item2 = [PersonItem setCellItemImage:nil title:@"消息提醒"];
    //    item2.pushController = [PromptViewController class];
    //    [items addObject:item2];
    
//    PersonItem *item3 = [PersonItem setCellItemImage:@"person_account" title:@"账户安全"];
//    item3.pushController = [AccountViewController class];
//    [items addObject:item3];
    
    PersonItem *item3 = [PersonItem setCellItemImage:@"person_phone" title:@"更换手机号"];
    item3.pushController = [ChangePhoneNumVC class];
    [items addObject:item3];
    
    PersonItem *item4 = [PersonItem setCellItemImage:@"person_problem" title:@"常见问题"];
    item4.pushController = [CommonProblemVC class];
    [items addObject:item4];
    
    PersonItem *item5 = [PersonItem setCellItemImage:@"person_protocol" title:@"用户协议"];
    item5.pushController = [ServiceAgreementVC class];
    [items addObject:item5];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:nil];
    
    [self.groups addObject:group];
}


- (void)initView
{
    
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQTableViewCell *cell = [YQTableViewCell cellWithTableView:tableView tableViewCellStyle:YQTableViewCellStyleBgImage];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = item;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
