//
//  WhiteListController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "WhiteListController.h"
#import "WhiteListQueryController.h"

#import "WhiteListEntity.h"
#import "WhiteListCell.h"

@interface WhiteListController ()<UIAlertViewDelegate>
{
    NSInteger pageIndex;
    NSIndexPath *currentIndexPath;
}
@end

@implementation WhiteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的招聘顾问";
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"+" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"home_add" highImage:@"home_add" target:self action:@selector(rightClick)];
    
    [self initView];
    
}

- (void)initView
{
    UINib *nib = [UINib nibWithNibName:@"WhiteListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WhiteListCell"];
    
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    
    self.tableView.tableHeaderView = [self headerView];
}
- (UIView *)headerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];
    view.backgroundColor = RGB(239, 239, 239);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, view.yq_width-20, view.yq_height-20)];
    label.text = @"点击添加按钮，搜索手机号，添加该用户为自己的招聘顾问，该用户即可免费为你推荐和你求职意向相符的企业和岗位。";
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
    return @"移出白名单";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WhiteListEntity *en = [self.tableArr objectAtIndex:indexPath.row];
        NSString *str = [NSString stringWithFormat:@"确定要将 %@ 移出白名单?\n移出后%@将不在为您推荐工作",en.name,en.name];
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
        [[RequestManager sharedRequestManager] whiteListDelete_uid:[UserEntity getUid] itemid:en.itemId success:^(id resultDic) {
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
    pageIndex = 1;
    [self reqWhiteList:[NSString stringWithFormat:@"%li",pageIndex]];
}
- (void)footerRereshing
{
    pageIndex++;
    [self reqWhiteList:[NSString stringWithFormat:@"%li",pageIndex]];
}
#pragma mark - 网络访问

- (void)reqWhiteList:(NSString *)page
{
    [[RequestManager sharedRequestManager] getWhiteList_uid:[UserEntity getUid] page:page pagesize:KPageSize success:^(id resultDic) {
        
        [self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            
            if (self.isPullDown) {
                [self.tableArr removeAllObjects];
            }
            
            for (NSDictionary *dict in list) {
                WhiteListEntity *en = [WhiteListEntity WhiteListEntityWithDict:dict];
                [self.tableArr addObject:en];
            }
            
            if (list.count < [KPageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        }else if ([resultDic[CODE] isEqualToString:@"100003"]){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark - 事件

- (void)rightClick
{
    
    
    
    
    WhiteListQueryController *vc = [[WhiteListQueryController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    YQWeakSelf;
    vc.refreshTableBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
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
