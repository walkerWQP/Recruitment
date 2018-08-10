//
//  CompanyAuthSelectController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyAuthSelectController.h"
#import "CompanyAuthController.h"
#import "CompanyBaseInfoController.h"
#import "CompanyIntroduceController.h"
#import "CompanyLicenseController.h"
#import "ServiceAgreementVC.h"

#import "EZCPersonCenterEntity.h"

@interface CompanyAuthSelectController ()
{
    BOOL isProtocol;
    NSInteger aflag;
}
@property (nonatomic, strong) UIButton *authButton;

@end

@implementation CompanyAuthSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"认证";
    
    self.tableView.tableFooterView = [self footerView];
    [self setUpData];
    [self.view addSubview:self.tableView];
    // 已完善通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"AlreadyPerfect" object:nil];
}

- (UIView *)footerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 130)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, view.yq_width-30, 50)];
    label.textColor = RGB(102, 102, 102);
    label.text = @"";
    [view addSubview:label];
    
    UIButton *protocolBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 60, 35)];
    [protocolBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [protocolBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 5, 8, 35)];
    [protocolBtn setTitle:@"同意" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:protocolBtn];
    
    UILabel *protocolLbl = [[UILabel alloc] initWithFrame:CGRectMake(protocolBtn.yq_right, protocolBtn.yq_y, 250, protocolBtn.yq_height)];
    protocolLbl.text = @"《E招用户注册服务协议及隐私条款》";
    protocolLbl.textColor = THEMECOLOR;
    protocolLbl.font = [UIFont systemFontOfSize:14];
    [view addSubview:protocolLbl];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolLbl:)];
    protocolLbl.userInteractionEnabled = YES;
    [protocolLbl addGestureRecognizer:tap];
    
    isProtocol = YES;
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, view.yq_height-50, APP_WIDTH-40, 40)];
    [quitBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [quitBtn setTitle:@"提交认证资料" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(authClick) forControlEvents:UIControlEventTouchUpInside];
    quitBtn.enabled = NO;
    [view addSubview:quitBtn];
    
    self.authButton = quitBtn;
    
    return view;
}

- (void)setUpData
{
    if (self.groups.count > 0) {
        [self.groups removeAllObjects];
    }
    
    PersonItem *item1 = [PersonItem setCellItemImage:@"auth3" title:@"公司基本信息"];
    //item1.pushController = [CompanyBaseInfoController class];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:[NSMutableArray arrayWithObject:item1] headerTitle:nil footerTitle:nil];
    
    PersonItem *item2 = [PersonItem setCellItemImage:@"auth2" title:@"公司介绍"];
    //item2.pushController = [CompanyIntroduceController class];
    YQGroupCellItem *group2 = [YQGroupCellItem setGroupItems:[NSMutableArray arrayWithObject:item2] headerTitle:nil footerTitle:nil];
    
    PersonItem *item3 = [PersonItem setCellItemImage:@"auth1" title:@"营业执照"];
    //item3.pushController = [CompanyLicenseController class];
    YQGroupCellItem *group3 = [YQGroupCellItem setGroupItems:[NSMutableArray arrayWithObject:item3] headerTitle:nil footerTitle:nil];
    
    PersonItem *item4 = [PersonItem setCellItemImage:@"auth1" title:@"负责人身份证证件照"];
    //item4.pushController = [CompanyAuthController class];
    YQGroupCellItem *group4 = [YQGroupCellItem setGroupItems:[NSMutableArray arrayWithObject:item4] headerTitle:nil footerTitle:nil];
    
    [self.groups addObject:group];
    [self.groups addObject:group2];
    [self.groups addObject:group3];
    [self.groups addObject:group4];
    EZCompanyInfoEntity *en = self.entity.companyEn;
    NSInteger flag = 0;
    if (en.cname.length > 0) {
        item1.subTitle = @"已完善";
        item1.pushController = nil;
        flag++;
    }
    if (en.companyinfo.length > 0) {
        item2.subTitle = @"已完善";
        item2.pushController = nil;
        flag++;
    }
    if (en.license_num.length > 0) {
        item3.subTitle = @"已完善";
        item3.pushController = nil;
        flag++;
    }
    if (en.id_card_num.length > 0) {
        item4.subTitle = @"已完善";
        item4.pushController = nil;
        flag++;
    }else{
        item4.subTitle = @"选填";
        item4.pushController = nil;
        flag++;
    }
    aflag = flag;
    if (flag >= 4) {
        // 可以提交
        if (isProtocol) {
            [self.authButton setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
            [self.authButton setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
            self.authButton.enabled = YES;
        }
        
    }else{
        self.authButton.enabled = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EZCompanyInfoEntity *en = self.entity.companyEn;
    
    if (indexPath.section == 0) {
        CompanyBaseInfoController *vc = [[CompanyBaseInfoController alloc] init];
        vc.entity = self.entity;
        [self.navigationController pushViewController:vc animated:YES];
        if (en.cname.length == 0) {
        }
    }else if (indexPath.section == 1) {
        CompanyIntroduceController *vc = [[CompanyIntroduceController alloc] init];
        vc.entity = self.entity;
        [self.navigationController pushViewController:vc animated:YES];
        if (en.companyinfo.length == 0) {
        }
    }else if (indexPath.section == 2) {
        CompanyLicenseController *vc = [[CompanyLicenseController alloc] init];
        vc.entity = self.entity;
        [self.navigationController pushViewController:vc animated:YES];
        if (en.license_num.length == 0) {
        }
    }else if (indexPath.section == 3) {
        CompanyAuthController *vc = [[CompanyAuthController alloc] init];
        vc.entity = self.entity;
        [self.navigationController pushViewController:vc animated:YES];
        if (en.id_card_num.length == 0) {
        }
    }
    
}

- (void)notify:(NSNotification *)notify
{
    [self setUpData];
    [self.tableView reloadData];
}

- (void)protocolLbl:(UIGestureRecognizer *)sender
{
    ServiceAgreementVC *vc = [[ServiceAgreementVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)protocolBtnClick:(UIButton *)sender
{
    if (aflag >=4) {
        if (isProtocol) {
            isProtocol = NO;
            [sender setImage:[UIImage imageNamed:@"select_un"] forState:UIControlStateNormal];
            self.authButton.enabled = NO;
            [self.authButton setBackgroundColor:[UIColor colorWithWhite:0.624 alpha:1.000] forState:UIControlStateNormal];
        }else{
            isProtocol = YES;
            [sender setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            self.authButton.enabled = YES;
            [self.authButton setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
        }
    }else{
        [YQToast yq_ToastText:@"请先完善认证资料" bottomOffset:100];
    }
    
}

- (void)authClick
{
    if (isProtocol) {
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] checkAuthStatus_uid:[UserEntity getUid] success:^(id resultDic) {
            [self.hud hide:YES];
            
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [UserEntity setRealAuth:@"3"];
                [YQToast yq_ToastText:@"资料已提交审核" bottomOffset:100];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.finishBlock) {
                    self.finishBlock();
                }
            }
            
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }else{
        [YQToast yq_ToastText:@"请同意《E招用户注册服务协议及隐私条款》" bottomOffset:100];
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
