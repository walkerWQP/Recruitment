//
//  MemberDetailController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "MemberDetailController.h"
#import "HomePositionDetailVC.h"
#import "CompanyDetailController.h"

#import "MemberDetailView.h"
#import "MemberDetailCell.h"

#import "HomeJobEntity.h"
#import "MemberDetailEntity.h"
#import "UIImage+colorImage.h"

@interface MemberDetailController ()

@property (nonatomic, strong) MemberDetailEntity *memberEntity;

@property (nonatomic, strong) MemberDetailView *memberDetailView;
@end

@implementation MemberDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initView];
    
    [self setNav];
    
    [self reqMemberDetail];
}

- (void)initView
{
    UINib *nib1 = [UINib nibWithNibName:@"MemberDetailCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"MemberDetailCell"];
    
    YQWeakSelf;
    self.memberDetailView = [MemberDetailView memberView];
    self.memberDetailView.goCompanyPress = ^(MemberDetailEntity *entity) {
        [weakSelf gotoCompanyVC];
    };
    
    self.tableView.tableHeaderView = self.memberDetailView;
    [self.view addSubview:self.tableView];
    self.tableView.yq_height = APP_HEIGHT;
    if (IS_IPhoneX) {
        self.tableView.yq_y = -44;
    }
}
- (void)setNav
{
    UIButton *leftButn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButn setImage:[UIImage imageWithOriginalImageName:@"bg_back"] forState:UIControlStateNormal];
    [leftButn setImage:[UIImage imageWithOriginalImageName:@"bg_back"] forState:UIControlStateHighlighted];
    [leftButn addTarget:self action:@selector(backButnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButn sizeToFit];
    //leftButn.backgroundColor = RandomColor;
    leftButn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButn setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    leftButn.frame = CGRectMake(0, 20, APP_WIDTH*0.3, 44);
    [self.view addSubview:leftButn];
}

- (void)backButnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)gotoCompanyVC
{
    CompanyDetailController *vc = [[CompanyDetailController alloc] init];
    vc.memberId = self.memberId;
    vc.companyId = self.memberEntity.companyid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YQGroupCellItem *item = [self.groups objectAtIndex:section];
    return item.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberDetailCell"];
    YQGroupCellItem *item = [self.groups objectAtIndex:indexPath.section];
    HomeJobEntity *en = item.items[indexPath.row];
    cell.entity = en;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQGroupCellItem *item = [self.groups objectAtIndex:indexPath.section];
    HomeJobEntity *en = item.items[indexPath.row];
    
    HomePositionDetailVC *vc = [[HomePositionDetailVC alloc] init];
    vc.jobEntity = en;
    if (vc.jobEntity.puid == nil) {
        vc.jobEntity.puid = self.memberId;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        if (![group.headerTitle isEqualToString:@""] && group.headerTitle != nil) {
            UILabel *footView = [[UILabel alloc] init];
            footView.textColor = [UIColor blackColor];
            footView.textAlignment = NSTextAlignmentLeft;
            footView.font = [UIFont systemFontOfSize:15];
            footView.text = group.headerTitle;
            footView.backgroundColor = [UIColor whiteColor];
            return footView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - 网络访问

- (void)reqMemberDetail
{
    [self.hud show:YES];
    if (self.hx_username == nil) {  //根据环信id判断
        [[RequestManager sharedRequestManager] homeMemberDetail_uid:[UserEntity getUid] puid:self.memberId hx_username:@"" type: @"1" success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                MemberDetailEntity *entity = [MemberDetailEntity MemberDetailEntityWithDict:resultDic[DATA]];
                self.memberEntity = entity;
                
                self.memberDetailView.entity = entity;
                
                YQGroupCellItem *item = [YQGroupCellItem setGroupItems:entity.positions headerTitle:@"   发布的职位" footerTitle:nil];
                [self.groups addObject:item];
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    } else {
        [[RequestManager sharedRequestManager] homeMemberDetail_uid:[UserEntity getUid] puid:self.memberId hx_username:[UserEntity getHXUserName] type: @"1" success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                MemberDetailEntity *entity = [MemberDetailEntity MemberDetailEntityWithDict:resultDic[DATA]];
                self.memberEntity = entity;
                
                self.memberDetailView.entity = entity;
                
                YQGroupCellItem *item = [YQGroupCellItem setGroupItems:entity.positions headerTitle:@"   发布的职位" footerTitle:nil];
                [self.groups addObject:item];
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
    
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
