//
//  COrderPayController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/15.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "COrderPayController.h"

#import "RecommendOrderEntity.h"

#import "RecommendOrderCell.h"
#import "COrderBystagesCell.h"
#import "YQPayManage.h"

@interface COrderPayController ()
{
    int flag;
}
@end

@implementation COrderPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付";
    
    [self initView];
    [self setUpdata];
}

- (void)initView
{
    self.tableView.tableFooterView = [self footerView];
    self.tableView.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:self.tableView];
}
- (void)setUpdata
{
    NSMutableArray *items1 = [NSMutableArray array];
    [items1 addObject:@""];
    YQGroupCellItem *group1 = [YQGroupCellItem setGroupItems:items1 headerTitle:nil footerTitle:nil];
    [self.groups addObject:group1];
    
    NSMutableArray *items = [NSMutableArray array];
    
    PersonItem *item0 = [PersonItem setCellItemImage:@"person_qianbao" title:@"支付宝"];
    [items addObject:item0];
    
//    PersonItem *item1 = [PersonItem setCellItemImage:@"buysms" title:@"微信"];
//    [items addObject:item1];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:@"   选择充值方式" footerTitle:nil];
    [self.groups addObject:group];
}

- (UIView *)footerView
{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 60)];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (contentView.yq_height-40)*0.5, APP_WIDTH-40, 40)];
    [quitBtn setBackgroundColor:RGB(241, 88, 82) forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:RGB(201, 58, 54) forState:UIControlStateHighlighted];
    [quitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(goPayClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:quitBtn];
    
    if ([self.entity.orderstatus isEqualToString:@"2"]) {
        quitBtn.enabled = NO;
        [quitBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    return contentView;
}

#pragma mark - tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UINib *nib = [UINib nibWithNibName:@"COrderBystagesCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"COrderBystagesCell"];
        COrderBystagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"COrderBystagesCell"];
        cell.entity = self.entity;
//        cell.isPayBtn = NO;
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH-35, (cell.frame.size.height-20)/2, 20, 20)];
            image.tag = 100;
            [cell addSubview:image];
        }
        if (indexPath.row == flag) {
            ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageNamed:@"select1"];
        }else{
            ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageNamed:@"select1_un"];
        }
        
        YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
        YQCellItem *item = [group.items objectAtIndex:indexPath.row];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = item.title;
        cell.imageView.image = [UIImage imageNamed:item.image];
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        if (![group.headerTitle isEqualToString:@""] && group.headerTitle != nil) {
            UILabel *footView = [[UILabel alloc] init];
            footView.textColor = RGB(51, 51, 51);
            footView.textAlignment = NSTextAlignmentLeft;
            footView.font = [UIFont systemFontOfSize:16];
            footView.text = group.headerTitle;
            return footView;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    flag = (int)indexPath.row;
    [self.tableView reloadData];
}

- (void)goPayClick
{
    YQPayManage *pay = [[YQPayManage alloc] init];
    
    YQPayMode model = YQPayModeAli;
    if (flag == 1) {
        model = YQPayModeWX;
    }
    NSString *orderId = self.entity.ordernum;
    NSString *money = self.entity.money;
    [pay handlePayMode:model orderType:YQPayOrderRechargeType orderid:orderId money:money handleBlock:^(NSInteger code,YQPayMode model, NSString *codeMsg, NSString *errorStr) {
        if (code == 1000) {
            [YQToast yq_ToastText:@"支付成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.refreshTable) {
                self.refreshTable();
            }
        }else if (code == 2000){
            [YQToast yq_AlertText:@"支付失败"];
        }else if (code == 3000){
            [YQToast yq_AlertText:@"支付取消"];
        }
    }];
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
