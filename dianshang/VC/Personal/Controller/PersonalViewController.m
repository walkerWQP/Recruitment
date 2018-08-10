//
//  PersonalViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/10/13.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "PersonalViewController.h"
#import "EZCPersonCenterController.h"// 企业个人中心
#import "ResumeManageController.h"
#import "CompanyMemberController.h"
#import "MessageViewController.h"

#import "PersonItem.h"

#import "PersonHeadView.h"

@interface PersonalViewController ()<PersonHeadViewDelegate>
{
    CGFloat personHeight;
}
@property (nonatomic, strong) PersonHeadView *headView;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    personHeight = [PersonHeadView personHeadHeight];
    
    [self setUpdata];
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.headView.headImageUrl = [UserEntity getHeadImgUrl];
    self.headView.nickName = [UserEntity getNickName];
}

- (void)setUpdata
{
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:[EZPublicList getPersonalListRole:@"0"]];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:mArr headerTitle:nil footerTitle:nil];
    [self.groups addObject:group];
}


- (void)initView
{
    self.tableView.yq_height = APP_HEIGHT-APP_TABH;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    // 设置tableView顶部额外滚动区域`
    self.tableView.contentInset = UIEdgeInsetsMake(personHeight+8, 0, 0, 0);
    // 初始化头部控件
    PersonHeadView *headV = [[PersonHeadView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, personHeight)];
    headV.delegate = self;
    
    [self.view addSubview:headV];
    self.headView = headV;
    
    
}

#pragma mark - TableView

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前偏移量y值
    CGFloat curOffsetY = scrollView.contentOffset.y;
    
    // 计算偏移量的差值 == tableView滚动了多少
    // 获取当前滚动偏移量 - 最开始的偏移量(-244)
    CGFloat delta = curOffsetY - -(personHeight+8);
    self.headView.yq_y = -delta;
}

#pragma mark - PersonHeadViewDelegate

- (void)buttonViewClick:(UIButton *)sender item:(PersonItem *)arrowItem
{
    if (arrowItem.pushController) {
        UIViewController *vc = [[arrowItem.pushController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)messageBtnClick:(UIButton *)messageBtn
{
    MessageViewController *vc = [[MessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)headImageTap:(UIImageView *)headImage
{
    if ([UserEntity getIsCompany]) {        
        EZCPersonCenterController *vc = [[EZCPersonCenterController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ResumeManageController *vc = [[ResumeManageController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
