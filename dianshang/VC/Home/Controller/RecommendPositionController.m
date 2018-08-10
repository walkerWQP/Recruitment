//
//  RecommendPositionController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/25.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RecommendPositionController.h"
#import "CompanyPersonalDetailVC.h"

#import "RecommendPositionCell.h"

#import "ShareHREntity.h"
#import "CompanyHomeEntity.h"
@interface RecommendPositionController ()
{
    NSInteger pageIndex;
}

@property (nonatomic, strong) UIButton *recommendButton;

@end

@implementation RecommendPositionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐";
    
    [self initView];
}

- (void)initView
{
    // 注册cell
    UINib *nib1 = [UINib nibWithNibName:@"RecommendPositionCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"RecommendPositionCell"];
    [self.view addSubview:self.tableView];
    self.tableView.yq_height -= (50+APP_BottomH);
    
    [self setupRefresh];
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.tableView.yq_bottom+5, APP_WIDTH-40, 40)];
    [quitBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    NSString *title = [self recommendTitle:@""];
    [quitBtn setTitle:title forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(recommentClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitBtn];
    quitBtn.hidden = YES;// 默认不显示
    self.recommendButton = quitBtn;
}

#pragma mark - 刷新

- (void)headerRereshing
{
    pageIndex = 1;
    [self reqRecommendList:[NSString stringWithFormat:@"%li",pageIndex]];
}

- (void)footerRereshing
{
    pageIndex++;
    [self reqRecommendList:[NSString stringWithFormat:@"%li",pageIndex]];
}

#pragma mark - table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendPositionCell"];
    
    ShareHREntity *en = [self.tableArr objectAtIndex:indexPath.row];
    
    cell.entity = en;

    YQWeakSelf;
    cell.selectBlock = ^(NSIndexPath *indexPath, ShareHREntity *entity) {
        [weakSelf selectClick:indexPath entity:entity];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShareHREntity *shareEn = self.tableArr[indexPath.row];
    // 看人才
    CompanyHomeEntity *en = [[CompanyHomeEntity alloc] init];
    en.itemId = shareEn.uid;
    en.name = shareEn.name;
    en.paymember = @"-1";
    
    CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
    vc.entity = en;
    vc.isRecommend = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 事件

- (void)selectClick:(NSIndexPath *)path entity:(ShareHREntity *)entity
{
    for (ShareHREntity *en in self.tableArr) {
        if ([en isEqual:entity]) {
            en.isSelect = YES;
        }else{
            en.isSelect = NO;
        }
    }
    [self.tableView reloadData];
    
    [self.recommendButton setTitle:[self recommendTitle:entity.name] forState:UIControlStateNormal];
}

- (void)recommentClick:(UIButton *)sender
{
    ShareHREntity *entity = nil;
    for (ShareHREntity *en in self.tableArr) {
        if (en.isSelect) {
            entity = en;
            break;
        }
    }
    if (entity != nil) {
        [self reqRecommend:entity];
    }
}

- (NSString *)recommendTitle:(NSString *)name
{
    NSString *str = [NSString stringWithFormat:@"把 %@ 推荐给(%@)",name,self.companyname];
    return str;
}

#pragma mark ========把XX推荐给XX========
- (void)reqRecommend:(ShareHREntity *)entity
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getHRRecommend_uid:[UserEntity getUid] pid:self.positionid type:@"2" puid:self.puid shareid:entity.uid success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"推荐成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([resultDic[CODE] isEqualToString:@"100002"]) {
            [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)reqRecommendList:(NSString *)page
{
    [[RequestManager sharedRequestManager] getHRRecommendList_uid:[UserEntity getUid] type:@"1" page:page pagesize:KPageSize pname:self.pname success:^(id resultDic) {
        //[self handleRequestList:resultDic];
        [self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            NSArray *array = resultDic[DATA];
            for (NSDictionary *dic in array) {
                ShareHREntity *en = [ShareHREntity ShareHREntityWithDict:dic];
                en.isSelect = NO;
                [tempArr addObject:en];
            }
            
            if (self.isPullDown) {
                self.tableArr = tempArr;
            }else {
                [self.tableArr addObjectsFromArray:tempArr];
            }
            int flag = 0;
            for (ShareHREntity *en in self.tableArr) {
                if (en.isSelect) {
                    flag = 1;
                    self.recommendButton.hidden = NO;// 显示推荐按钮
                    [self.recommendButton setTitle:[self recommendTitle:en.name] forState:UIControlStateNormal];
                    break;
                }
            }
            if (flag == 0 && self.tableArr.count>0) {
                ShareHREntity *en = [self.tableArr objectAtIndex:0];
                en.isSelect = YES;
                self.recommendButton.hidden = NO;// 显示推荐按钮
                [self.recommendButton setTitle:[self recommendTitle:en.name] forState:UIControlStateNormal];
            }
            
            [self.tableView reloadData];
            if (array.count < [KPageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
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
