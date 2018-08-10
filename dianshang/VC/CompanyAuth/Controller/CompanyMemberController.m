//
//  CompanyMemberController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/21.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyMemberController.h"
#import "AddCompanyMemberVC.h"

#import "WhiteListEntity.h"
#import "WhiteListCell.h"

@interface CompanyMemberController ()<UIAlertViewDelegate>
{
    NSInteger pageIndex;
    NSIndexPath *currentIndexPath;
}

@end

@implementation CompanyMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公司成员管理";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"添加" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick)];
    
    [self initView];
}

- (void)initView
{
    self.tableView.tableHeaderView = [self headerView];
    
    UINib *nib = [UINib nibWithNibName:@"WhiteListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WhiteListCell"];
    
    [self.view addSubview:self.tableView];
    //[self setupRefresh];
    [self reqWhiteList:@""];
}

- (UIView *)headerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];
    view.backgroundColor = RGB(239, 239, 239);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, view.yq_width-20, view.yq_height-20)];
    label.text = @"点击添加，搜索手机号，添加招聘成员帐号，该手机号需先注册人才端用户，无需认证即可归属本公司招聘成员。";
    label.numberOfLines = 0;
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    return view;
}


#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhiteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhiteListCell"];
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];
    cell.isAddBtn = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"移除成员";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WhiteListEntity *en = [self.tableArr objectAtIndex:indexPath.row];
        NSString *str = [NSString stringWithFormat:@"确定要将 %@ 移出您的公司?\n移出后%@将不在为您招聘人才",en.name,en.name];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        currentIndexPath = indexPath;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.hud show:YES];
        WhiteListEntity *en = [self.tableArr objectAtIndex:currentIndexPath.row];
        [[RequestManager sharedRequestManager] deleteCompanyMember_uid:[UserEntity getUid] mid:en.itemId success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [YQToast yq_ToastText:@"移出成功" bottomOffset:100];
                
                [self.tableArr removeObjectAtIndex:currentIndexPath.row];
                if (self.tableArr.count == 0) { // 要根据情况直接删除section或者仅仅删除row
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:currentIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [self.tableView deleteRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }else if ([resultDic[CODE] isEqualToString:@"100002"]){
                [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}

#pragma mark - 刷新
- (void)headerRereshing
{
//    pageIndex = 1;
//    [self reqWhiteList:[NSString stringWithFormat:@"%li",pageIndex]];
}
- (void)footerRereshing
{
//    pageIndex++;
//    [self reqWhiteList:[NSString stringWithFormat:@"%li",pageIndex]];
}
#pragma mark - 网络访问

- (void)reqWhiteList:(NSString *)page
{
    [[RequestManager sharedRequestManager] companyMemberList_uid:@"" cid:[UserEntity getCompanyId] page:@"" pagesize:@"" success:^(id resultDic) {
        
        //[self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            
            [self.tableArr removeAllObjects];
//            if (self.isPullDown) {
//                [self.tableArr removeAllObjects];
//            }
            
            for (NSDictionary *dict in list) {
                WhiteListEntity *en = [WhiteListEntity WhiteListEntityWithDict:dict];
                [self.tableArr addObject:en];
            }
            
//            if (list.count < [KPageSize integerValue]) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
            
            [self.tableView reloadData];
        }else if ([resultDic[CODE] isEqualToString:@"100003"]){
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark - 事件

- (void)rightClick
{
    AddCompanyMemberVC *vc = [[AddCompanyMemberVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    YQWeakSelf;
    vc.refreshTableBlock = ^{
        [weakSelf reqWhiteList:@""];
    };
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
