//
//  CPositionMangerController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/28.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CPositionMangerController.h"
#import "CReleasePositionController.h"
#import "CResumeDeliverController.h"
#import "CResumeRecommendController.h"

#import "EZCPersonCenterController.h"

#import "CPositionMangerEntity.h"
#import "CPositionMangerCell.h"

@interface CPositionMangerController ()<UIAlertViewDelegate>

@end

@implementation CPositionMangerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"职位管理";
    
    [self initView];
    
    [self reqPositionList];
}

- (void)initView
{
    UINib *nib1 = [UINib nibWithNibName:@"CPositionMangerCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"CPositionMangerCell"];
    self.tableView.yq_height -= (50+APP_BottomH);
    [self.view addSubview:self.tableView];
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.tableView.yq_bottom+5, APP_WIDTH-40, 40)];
    [quitBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    [quitBtn setTitle:@"发布职位" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(releaseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitBtn];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPositionMangerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CPositionMangerCell"];
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];
    YQWeakSelf;
    cell.buttonBlock = ^(NSIndexPath *indexPath,NSInteger index) {
        [weakSelf gotoRecordVC:indexPath index:index];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPositionMangerEntity *entity = [self.tableArr objectAtIndex:indexPath.row];
    if ([entity.issue isEqualToString:@"1"]) {
        return 110;
    }
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CPositionMangerEntity *en = [self.tableArr objectAtIndex:indexPath.row];
    
    CReleasePositionController *vc = [[CReleasePositionController alloc] init];
    vc.entity = en;
    YQWeakSelf;
    vc.addEditBlock = ^(BOOL isAdd, CPositionMangerEntity *entity) {
        if (isAdd) {
            [weakSelf reqPositionList];
        }else{
            [weakSelf.tableView reloadData];
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"companyHomeRefresh" object:nil userInfo:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)releaseClick:(UIButton *)sender
{
    NSInteger flag = 0;
    if ([UserEntity getIsCompany]) {
        NSInteger auth = [[UserEntity getRealAuth] integerValue];
        if (auth == 1) {
            flag = 1;
        }else if (auth == 2){
            //去认证
            [self goAuth];
        }else if (auth == 3){
            // 等待审核
            [self waitExamine];
        }
    }else{
        NSInteger auth = [[UserEntity getRealAuth] integerValue];
        if (auth == 1) {
            flag = 1;
        }else if (auth == 2){
            //去认证
            [self goAuth];
        }else if (auth == 3){
            // 等待审核
            [self waitExamine];
        }
    }
    
    
    if (flag == 1) {
        CReleasePositionController *vc = [[CReleasePositionController alloc] init];
        YQWeakSelf;
        vc.addEditBlock = ^(BOOL isAdd, CPositionMangerEntity *entity) {
            if (isAdd) {
                [weakSelf reqPositionList];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goAuth
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"您未实名认证,暂不能发布职位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)waitExamine
{
    [YQToast yq_AlertText:@"您的资料正在审核中,请耐心等待"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            if ([UserEntity getIsCompany]) {
                EZCPersonCenterController *vc = [[EZCPersonCenterController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)gotoRecordVC:(NSIndexPath *)path index:(NSInteger)index
{
    CPositionMangerEntity *entity = [self.tableArr objectAtIndex:path.row];
    if (index == 0) {
        // 推荐
        CResumeRecommendController *vc = [[CResumeRecommendController alloc] init];
        vc.positionName = entity.position_class_name;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1) {
        // 直投
        CResumeDeliverController *vc = [[CResumeDeliverController alloc] init];
        vc.positionName = entity.position_class_name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 网络请求

- (void)reqPositionList
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getCPositionList_uid:[UserEntity getUid] success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            [self.tableArr removeAllObjects];
            
            for (NSDictionary *dict in list) {
                CPositionMangerEntity *en = [CPositionMangerEntity CPositionEntityWithDict:dict];
                [self.tableArr addObject:en];
            }
            
            [self.tableView reloadData];
        }else if ([resultDic[CODE] isEqualToString:@"100003"]) {
            [self.tableArr removeAllObjects];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
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
