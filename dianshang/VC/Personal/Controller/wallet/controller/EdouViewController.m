//
//  EdouViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EdouViewController.h"
#import "PersonItem.h"
#import "RechargeEdouController.h"

@interface EdouViewController ()
{
    UIView *bgView;
}
@property (nonatomic, strong) UILabel *allBalancelbl;
//@property (nonatomic, strong) UILabel *allowBalancelbl;

//@property (nonatomic, strong) UILabel *frozenlbl;// 冻结

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSString *webTitle;

@end

@implementation EdouViewController


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
    
    self.webTitle = @"E豆";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title = @"钱包";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"明细" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    
    [self setNav];
    [self initView];
    [self setUpdata];
    
    
//    [self.activityView startAnimating];
//    NSDictionary *accountDic = [YQSaveManage objectForKey:MYACCOUNT];
//    NSString *str = [accountDic objectForKey:@"username"];
//    NSString *str1 = [accountDic objectForKey:@"password"];
//    [[RequestManager sharedRequestManager] login_phone:str password:str1 success:^(id resultDic) {
//        [self.activityView stopAnimating];
//        if ([resultDic[STATUS] isEqualToString:SUCCESS]) {
//            NSString *balance = resultDic[INFO][@"balance"];
//            //保存余额
//            [UserEntity setBalance:balance];
//
//            [self initView];
//            [self setUpdata];
//        }
//    } failure:nil];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    PersonItem *item1 = [PersonItem setCellItemImage:@"buysms" title:@"充值"];
    item1.pushController = [RechargeEdouController class];
    [items addObject:item1];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:nil];
    [self.groups addObject:group];
}

- (UIView *)headerView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 10)];
    bgView.backgroundColor = THEMECOLOR;
    [self.tableView addSubview:bgView];
    
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 115)];
    headV.backgroundColor = THEMECOLOR;
    
    UILabel *balancelbl = [[UILabel alloc] init];
    balancelbl.text = @"E豆";
    balancelbl.adjustsFontSizeToFitWidth = YES;
    balancelbl.textColor = [UIColor whiteColor];
    balancelbl.textAlignment = NSTextAlignmentLeft;
    balancelbl.font = [UIFont systemFontOfSize:15];
    balancelbl.frame = CGRectMake(20, 15, APP_WIDTH-40, 25);
    [headV addSubview:balancelbl];
    
    UILabel *balancelbl1 = [[UILabel alloc] init];
    balancelbl1.text = @"00";//[UserEntity getBalance];
    balancelbl1.adjustsFontSizeToFitWidth = YES;
    balancelbl1.textColor = [UIColor whiteColor];
    balancelbl1.textAlignment = NSTextAlignmentLeft;
    balancelbl1.font = [UIFont systemFontOfSize:40];
    //balancelbl1.backgroundColor = RandomColor;
    balancelbl1.frame = CGRectMake(20, balancelbl.yq_bottom, APP_WIDTH-40, 40);
    _allBalancelbl = balancelbl1;
    [headV addSubview:balancelbl1];
    
//    UILabel *balancelbl2 = [[UILabel alloc] init];
//    balancelbl2.text = @"冻结金额:0";
//    balancelbl2.adjustsFontSizeToFitWidth = YES;
//    balancelbl2.textColor = [UIColor whiteColor];
//    balancelbl2.textAlignment = NSTextAlignmentLeft;
//    balancelbl2.font = [UIFont systemFontOfSize:15];
//    balancelbl2.frame = CGRectMake(20, balancelbl1.yq_bottom, APP_WIDTH-40, 30);
//    _frozenlbl = balancelbl2;
//    [headV addSubview:balancelbl2];
    
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
//    DetailedRecordController *renzhengVC = [[DetailedRecordController alloc] init];
//    [self.navigationController pushViewController:renzhengVC animated:YES];
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
