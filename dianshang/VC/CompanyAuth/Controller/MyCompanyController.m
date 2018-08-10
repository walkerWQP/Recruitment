//
//  MyCompanyController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/8.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "MyCompanyController.h"
#import "CompanyDetailController.h"
#import "BusinessDetailController.h"
#import "CompanyIntroduceController.h"
#import "EZCPersonCenterEntity.h"

#import "YQSaveManage.h"
#import "JPushManager.h"
#import "YQGuideManage.h"
#import "EaseUI.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface MyCompanyController ()<UIAlertViewDelegate>
{
    UIView *headView;
}

@end

@implementation MyCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    
    //[self reqPersonInfo];
    [self setUpdata];
    [self initView];
    
}

- (void)setUpdata
{
    if (self.groups.count>0) {
        [self.groups removeAllObjects];
    }
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    
    if (self.entity.companyEn.scale != nil) {
        YQCellItem *item2 = [YQCellItem setCellItemImage:nil title:@"公司规模"];
        item2.subTitle = [[EZPublicList getScopeList] objectAtIndex:[self.entity.companyEn.scale integerValue]];
        [mArr addObject:item2];
    }
    if (self.entity.companyEn.cvedit != nil) {
        YQCellItem *item0 = [YQCellItem setCellItemImage:nil title:@"融资规模"];
        item0.subTitle = [[EZPublicList getFinancingList] objectAtIndex:[self.entity.companyEn.cvedit integerValue]];
        [mArr addObject:item0];
    }
    if (self.entity.companyEn.link.length > 0) {
        YQWeakSelf;
        YQCellItem *item6 = [YQCellItem setCellItemImage:nil title:@"公司官网"];
        item6.subTitle = self.entity.companyEn.link;
        item6.operationBlock = ^{
            [weakSelf goCompanyLink];
        };
        [mArr addObject:item6];
    }
    
    YQGroupCellItem *group1 = [YQGroupCellItem setGroupItems:mArr headerTitle:@" " footerTitle:nil];
    [self.groups addObject:group1];
    
    YQWeakSelf;
    NSMutableArray *mArr1 = [[NSMutableArray alloc] init];
    YQCellItem *item7 = [YQCellItem setCellItemImage:nil title:@"公司主页"];
    item7.subTitle = @"";
    item7.operationBlock = ^{
        [weakSelf goCompanyHome];
    };
    [mArr1 addObject:item7];
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:mArr1 headerTitle:@" " footerTitle:nil];
    [self.groups addObject:group];

   
    NSMutableArray *mArr2 = [[NSMutableArray alloc] init];
    YQCellItem *item8 = [YQCellItem setCellItemImage:nil title:@"编辑公司信息"];
    item8.subTitle = @"";
    item8.operationBlock = ^{
        [weakSelf changeData];
    };
    
    [mArr2 addObject:item8];
    YQGroupCellItem *group2 = [YQGroupCellItem setGroupItems:mArr2 headerTitle:@" " footerTitle:nil];
    [self.groups addObject:group2];
    
    
   
    
    
}

- (void)initView
{
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick:)];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 170)];
    headView.backgroundColor = [UIColor whiteColor];
    //[headView addGestureRecognizer:tap];
    
    UIImageView *a = [[UIImageView alloc] initWithFrame:headView.bounds];
    a.image = [UIImage imageNamed:@"my_company_bg"];
    [headView addSubview:a];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    NSString *avatar = [UserEntity getHeadImgUrl];
    [image sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    image.tag = -1;
    image.center = CGPointMake(headView.yq_width*0.5, 60);
    [headView addSubview:image];
    image.layer.cornerRadius = 8;
    image.layer.masksToBounds = YES;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, image.yq_bottom+5, headView.yq_width, 25)];
    if (self.entity.companyEn.tradeid != nil) {
        label1.text = [[EZPublicList getTradeList] objectAtIndex:[self.entity.companyEn.tradeid integerValue]];
    }
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB(51, 51, 51);
    label1.font = [UIFont systemFontOfSize:15];
    [headView addSubview:label1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.yq_bottom, headView.yq_width, 25)];
    label.text = self.entity.companyEn.cname;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(102, 102, 102);
    label.font = [UIFont systemFontOfSize:14];
    [headView addSubview:label];
    
    //self.headImageView = image;
    
    
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 50)];
    footView.backgroundColor = [UIColor redColor];
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, footView.yq_width-40, 40)];
    [quitBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [quitBtn setTitle:@"与公司解绑" forState:UIControlStateNormal];
    [quitBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(goUnbundlingClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:quitBtn];
    
    self.tableView.tableHeaderView = headView;
    
    if (![[UserEntity getCompanyPerson] isEqualToString:@"1"]) {
        self.tableView.tableFooterView = footView;
    }
    
    [self.view addSubview:self.tableView];
}
#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    
    if (item.operationBlock != nil) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    if (item.operationBlock) {
        item.operationBlock();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 9;
    }
    return 0.01;
}
#pragma mark - 事件

- (void)changeData
{
    NSString *str = [NSString stringWithFormat:@"%@%@%@",@"你即将编辑 ",self.entity.companyEn.cname,@" 的公司信息,该操作对公司全体成员生效,公司信息将进行重新审核生效。"];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
        CompanyIntroduceController *CompanyIntroduceVC = [[CompanyIntroduceController alloc] init];
        CompanyIntroduceVC.entity = self.entity;
        CompanyIntroduceVC.typeStr = @"1";
        [self.navigationController pushViewController:CompanyIntroduceVC animated:YES];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
        
    }];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)goCompanyLink
{
    NSString *urlStr = self.entity.companyEn.link;
    if (![urlStr hasPrefix:@"http"]) {
        urlStr = [NSString stringWithFormat:@"http://%@",urlStr];
    }
    BusinessDetailController *detail = [[BusinessDetailController alloc] init];
    detail.urlStr = urlStr;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)goCompanyHome
{
    CompanyDetailController *vc = [[CompanyDetailController alloc] init];
    vc.memberId = [UserEntity getUid];
    vc.companyId = self.entity.companyid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goUnbundlingClick
{
    //
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] companyUnbundling_uid:[UserEntity getUid] success:^(id resultDic) {
        [self.hud hide:YES];
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"与公司解绑成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 退出登录
    // 把密码清除
    NSDictionary *accountDic = [YQSaveManage objectForKey:MYACCOUNT];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:accountDic];
    [dict removeObjectForKey:@"password"];
    [YQSaveManage setObject:dict forKey:MYACCOUNT];
    // 清除用户信息
    [YQSaveManage removeObjectForKey:USERINFO];
    // 修改登录状态
    [YQSaveManage setObject:@"0" forKey:LOGINSTATUS];
    // 清除推送别名
    [[JPushManager shareJPushManager] setAlias:@"" resBlock:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    }];
    // 删除分享图片
    //[self deleteShareImage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 退出环信登录
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        [[EMClient sharedClient] logout:YES];
    });
    
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    keyWindow.rootViewController = [YQGuideManage chooseRootController];
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
