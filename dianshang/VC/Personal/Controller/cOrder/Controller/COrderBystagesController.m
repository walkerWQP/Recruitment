//
//  COrderBystagesController.m
//  dianshang
//
//  Created by yunjobs on 2018/1/3.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "COrderBystagesController.h"
#import "COrderPayController.h"
#import "COrderBystagesCell.h"
#import "RecommendOrderEntity.h"

@interface COrderBystagesController ()<UIAlertViewDelegate>

@property (nonatomic, strong) COrderBystagesEntity *orderEn;

@end

@implementation COrderBystagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self reqOrderList];
}

- (void)initView
{
    UINib *nib = [UINib nibWithNibName:@"COrderBystagesCell" bundle:nil];
    self.tableView.yq_height -= APP_TABH;
    [self.tableView registerNib:nib forCellReuseIdentifier:@"COrderBystagesCell"];
    [self.view addSubview:self.tableView];
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
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    COrderBystagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"COrderBystagesCell"];
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    COrderBystagesEntity *en = [self.tableArr objectAtIndex:indexPath.row];
    if ([en.orderstatus isEqualToString:@"3"]) {
        self.orderEn = en;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"您已逾期,请尽快付款!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去付款", nil];
        alert.tag = 1000;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            COrderPayController *vc = [[COrderPayController alloc] init];
            vc.entity = self.orderEn;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)reqOrderList
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] recommendOrderBystagesList_uid:@"" ordernum:self.orderNumber success:^(id resultDic) {
        [self.hud hide:YES];
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            
            [self.tableArr removeAllObjects];
            
            for (NSDictionary *dict in list) {
                COrderBystagesEntity *en = [COrderBystagesEntity entityWithDict:dict];
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
