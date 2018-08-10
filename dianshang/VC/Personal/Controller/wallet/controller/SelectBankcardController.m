//
//  SelectBankcardController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "SelectBankcardController.h"
#import "AddBankcardController.h"

#import "YQTableViewCell.h"

@interface SelectBankcardController ()

@end

@implementation SelectBankcardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择银行卡";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"添加" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    
    [self setUpdata];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    //self.tableView.tableFooterView = [self footerView];
    self.tableView.backgroundColor = RGB(243, 243, 243);
    self.cellStyle = YQTableViewCellStyleSubtitle;
    [self.view addSubview:self.tableView];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    YQCellItem *item0 = [YQCellItem setCellItemImage:@"person_haoyou" title:@"中国银行"];
    item0.subTitle = @"尾号2474储蓄卡";
    item0.isSelect = YES;
    //item0.pushController = [YQBuySMSController class];
    [items addObject:item0];
    
    YQCellItem *item1 = [YQCellItem setCellItemImage:@"person_haoyou" title:@"中国农业银行"];
    //item0.pushController = [YQBuySMSController class];
    item1.subTitle = @"尾号2475储蓄卡";
    item1.isSelect = NO;
    [items addObject:item1];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:nil];
    [self.groups addObject:group];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 选择银行卡回调
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightClick:(UIButton *)sender
{
    AddBankcardController *vc = [[AddBankcardController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
