//
//  RecommendOrderController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/8.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RecommendOrderController.h"
#import "COrderBystagesController.h"
#import "COrderPayController.h"

#import "RecommendOrderEntity.h"
#import "RecommendOrderCell.h"

@interface RecommendOrderController ()

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation RecommendOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单";
    
    UINib *nib = [UINib nibWithNibName:@"RecommendOrderCell" bundle:nil];
    self.tableView.yq_height -= APP_TABH;
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RecommendOrderCell"];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    
    //self.view.backgroundColor = RandomColor;
}

#pragma mark ========刷新数据========

- (void)headerRereshing
{
    _pageIndex = 1;
    [self reqFollowJobList:[NSString stringWithFormat:@"%li",_pageIndex++]];
}
- (void)footerRereshing
{
    [self reqFollowJobList:[NSString stringWithFormat:@"%li",_pageIndex++]];
}
#pragma mark ========tableview delegate========

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
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendOrderCell"];
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YQWeakSelf;
    cell.payBlock = ^(NSIndexPath *indexPath, RecommendOrderEntity *entity) {
        [weakSelf payClick:indexPath entity:entity];
    };
    
    return cell;
}

#pragma mark ========支付顾问费========
- (void)payClick:(NSIndexPath *)path entity:(RecommendOrderEntity *)entity
{
    //currentPath = path;
    COrderPayController *vc = [[COrderPayController alloc] init];
    vc.entity = entity.subOrder;
    YQWeakSelf;
    vc.refreshTable = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RecommendOrderEntity *en = self.tableArr[indexPath.row];
    //if ([en.check isEqualToString:@"2"]) {
        COrderBystagesController *vc = [[COrderBystagesController alloc] init];
        vc.orderNumber = en.ordernum;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}
#pragma mark - 事件
#pragma mark - 网络请求
- (void)reqFollowJobList:(NSString *)page
{
    [self endRereshingCustom];
    
    [[RequestManager sharedRequestManager] recommendOrderList_uid:[UserEntity getUid] pname:@"" type:@"1" page:page pagesize:KPageSize success:^(id resultDic) {
        [self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            //[EZPublicList printPropertyWithDict:list.firstObject];
            if (self.isPullDown) {
                [self.tableArr removeAllObjects];
            }
            
            for (NSDictionary *dict in list) {
                RecommendOrderEntity *en = [RecommendOrderEntity entityWithDict:dict];
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
