//
//  WalletViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "WalletViewController.h"
#import "WithdrawalsController.h"
#import "EdouViewController.h"
#import "SelectBankcardController.h"
#import "DetailedRecordController.h"
#import "CDetailRecordController.h"
#import "RechargeEdouController.h"

#import "PersonItem.h"

@interface WalletViewController ()<UIAppearanceContainer>
{
    UIView *bgView;
}
@property (nonatomic, strong) UILabel *allBalancelbl;
@property (nonatomic, strong) UILabel *edoulbl;

@property (nonatomic, strong) UILabel *frozenlbl;// 冻结

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSString *webTitle;

@end

@implementation WalletViewController

- (UILabel *)titleLable
{
    if (_titleLable == nil) {
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.font = [UIFont boldSystemFontOfSize:17];
        _titleLable = titleLbl;
    }
    return _titleLable;
}

- (UIView *)titleView
{
    if (_titleView == nil) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _titleView = titleView;
    }
    return _titleView;
}

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        _activityView.center = CGPointMake(self.titleView.yq_width*0.5, self.titleView.yq_height*0.5);
        //[_activityView startAnimating];
    }
    return _activityView;
}
- (void)setWebTitle:(NSString *)webTitle
{
    _webTitle = webTitle;
    
    self.titleLable.text = webTitle;
    [self.titleLable sizeToFit];
    
    self.titleLable.center = CGPointMake(self.titleView.yq_width*0.5, self.titleView.yq_height*0.5);
    self.activityView.center = CGPointMake(self.titleLable.yq_x-self.activityView.yq_width*0.5-5, self.titleView.yq_height*0.5);
}

- (void)setNav
{
    self.navigationItem.titleView = self.titleView;
    
    [self.titleView addSubview:self.titleLable];
    
    [self.titleView addSubview:self.activityView];
    
    self.webTitle = @"钱包";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title = @"钱包";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"明细" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    
    [self setNav];
//    [self initView];
//    [self setUpdata];

    //[self reqBalance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reqBalance];
}

- (void)reqBalance
{
    [self.activityView startAnimating];
    
    //NSString *type = [UserEntity getIsCompany] ? @"2" : @"1";
    [[RequestManager sharedRequestManager] getAccountBalance_uid:[UserEntity getUid] type:nil success:^(id resultDic) {
        [self.activityView stopAnimating];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSDictionary *dict = resultDic[DATA];
            //保存余额
            [UserEntity setBalance:dict[@"money"]];
            [UserEntity setFrozenBalance:dict[@"frozen"]];
            [UserEntity setEdou:dict[@"coin"]];
            
            [self initView];
            [self setUpdata];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    PersonItem *item0 = [PersonItem setCellItemImage:@"person_qianbao" title:@"提现"];
    //item0.pushController = [WithdrawalsController class];
    [items addObject:item0];
    
    if ([UserEntity getIsCompany]) {
        PersonItem *item1 = [PersonItem setCellItemImage:@"buysms" title:@"E豆充值"];
        item1.pushController = [RechargeEdouController class];
        [items addObject:item1];
        
//        PersonItem *item2 = [PersonItem setCellItemImage:@"buysms" title:@"E豆"];
//        item2.subTitle = @"200豆";
//        item2.pushController = [EdouViewController class];
//        [items insertObject:item2 atIndex:0];
    }
    
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:nil];
    [self.groups addObject:group];
}

- (UIView *)headerView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 10)];
    bgView.backgroundColor = THEMECOLOR;
    [self.tableView addSubview:bgView];
    
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 155)];
    headV.backgroundColor = THEMECOLOR;
    
    if ([UserEntity getIsCompany]) {
        UILabel *edoulbl = [[UILabel alloc] init];
        edoulbl.text = @"E豆";
        edoulbl.adjustsFontSizeToFitWidth = YES;
        edoulbl.textColor = [UIColor whiteColor];
        edoulbl.textAlignment = NSTextAlignmentLeft;
        edoulbl.font = [UIFont systemFontOfSize:15];
        edoulbl.frame = CGRectMake(20, 15, APP_WIDTH-40, 25);
        [headV addSubview:edoulbl];
        
        UILabel *edoulbl1 = [[UILabel alloc] init];
        edoulbl1.text = [UserEntity getEdou];
        edoulbl1.adjustsFontSizeToFitWidth = YES;
        edoulbl1.textColor = [UIColor whiteColor];
        edoulbl1.textAlignment = NSTextAlignmentLeft;
        edoulbl1.font = [UIFont systemFontOfSize:40];
        //balancelbl1.backgroundColor = RandomColor;
        edoulbl1.frame = CGRectMake(20, edoulbl.yq_bottom, APP_WIDTH-40, 40);
        self.edoulbl = edoulbl1;
        [headV addSubview:edoulbl1];
    }
    
    UILabel *balancelbl = [[UILabel alloc] init];
    balancelbl.text = @"账户余额(元)";
    balancelbl.adjustsFontSizeToFitWidth = YES;
    balancelbl.textColor = [UIColor whiteColor];
    balancelbl.textAlignment = NSTextAlignmentLeft;
    balancelbl.font = [UIFont systemFontOfSize:15];
    balancelbl.frame = CGRectMake(20, self.edoulbl.yq_bottom+5, APP_WIDTH-40, 25);
    [headV addSubview:balancelbl];
    
    UILabel *balancelbl1 = [[UILabel alloc] init];
    balancelbl1.text = [NSString stringWithFormat:@"%g",[[UserEntity getBalance] floatValue]];
    balancelbl1.adjustsFontSizeToFitWidth = YES;
    balancelbl1.textColor = [UIColor whiteColor];
    balancelbl1.textAlignment = NSTextAlignmentLeft;
    balancelbl1.font = [UIFont systemFontOfSize:40];
    //balancelbl1.backgroundColor = RandomColor;
    balancelbl1.frame = CGRectMake(20, balancelbl.yq_bottom, APP_WIDTH-40, 40);
    _allBalancelbl = balancelbl1;
    [headV addSubview:balancelbl1];
    
//    UILabel *balancelbl2 = [[UILabel alloc] init];
//    //balancelbl2.text = [NSString stringWithFormat:@"冻结金额:%@",[UserEntity getFrozenBalance]];
//    //balancelbl2.text = @"冻结金额";
//    balancelbl2.adjustsFontSizeToFitWidth = YES;
//    balancelbl2.textColor = [UIColor whiteColor];
//    balancelbl2.textAlignment = NSTextAlignmentLeft;
//    balancelbl2.font = [UIFont systemFontOfSize:15];
//    balancelbl2.frame = CGRectMake(20, balancelbl1.yq_bottom, APP_WIDTH-40, 30);
//    //_frozenlbl = balancelbl2;
//    [headV addSubview:balancelbl2];
    
    headV.yq_height = balancelbl1.yq_bottom+20;
    
    return headV;
}

- (UIView *)footerView
{
    return [[UIView alloc] init];
}

- (void)initView
{
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.tableFooterView = [self footerView];
    self.tableView.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:self.tableView];
}

- (void)rightClick:(UIButton *)sender
{
    if ([UserEntity getIsCompany]) {
        CDetailRecordController *vc = [[CDetailRecordController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DetailedRecordController *vc = [[DetailedRecordController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - tableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.mj_offsetY<0) {
        bgView.yq_y = scrollView.mj_offsetY;
        bgView.yq_height = -scrollView.mj_offsetY;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQTableViewCell *cell = [YQTableViewCell cellWithTableView:tableView tableViewCellStyle:YQTableViewCellStyleSubtitle];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.item = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
        }else{
            if ([item.title isEqualToString:@"提现"]) {
                WithdrawalsController *vc = [[WithdrawalsController alloc] init];
                YQWeakSelf;
                vc.refreshBalance = ^(NSString *balance) {
                    weakSelf.allBalancelbl.text = balance;
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
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
