//
//  CFollowPersonalController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/4.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CFollowPersonalController.h"

#import "CompanyHomeEntity.h"

#import "CFollowPersonCell.h"

@interface CFollowPersonalController ()

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation CFollowPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注人才";
    
    UINib *nib = [UINib nibWithNibName:@"CFollowPersonCell" bundle:nil];
    self.tableView.yq_height -= APP_TABH;
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CFollowPersonCell"];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    
    //self.view.backgroundColor = RandomColor;
}

#pragma mark - 刷新

- (void)headerRereshing
{
    _pageIndex = 1;
    [self reqFollowJobList:[NSString stringWithFormat:@"%li",_pageIndex++]];
}
- (void)footerRereshing
{
    [self reqFollowJobList:[NSString stringWithFormat:@"%li",_pageIndex++]];
}
#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFollowPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFollowPersonCell"];
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CompanyHomeEntity *en = self.tableArr[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFollowPersonalDelegate:)]) {
        [self.delegate didFollowPersonalDelegate:en];
    }
}
#pragma mark - 事件
#pragma mark - 网络请求
- (void)reqFollowJobList:(NSString *)page
{
    [[RequestManager sharedRequestManager] followPersonList_uid:[UserEntity getUid] page:page pagesize:KPageSize success:^(id resultDic) {
        [self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA][@"member_list"];
            
            if (self.isPullDown) {
                [self.tableArr removeAllObjects];
            }
            
            for (NSDictionary *dict in list) {
                CompanyHomeEntity *en = [CompanyHomeEntity CompanyHomeEntityWithDict:dict];
                en.paymember = @"1";
                [self.tableArr addObject:en];
            }
            
            if (list.count < [KPageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        }else if ([resultDic[CODE] isEqualToString:@"100003"]){
            if (self.isPullDown) {
                [self.tableArr removeAllObjects];
                [self.tableView reloadData];
            }
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
