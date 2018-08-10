//
//  RecommendPersonController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RecommendPersonController.h"
#import "HomePositionDetailVC.h"

#import "RecommendPersonCell.h"

#import "HomeJobEntity.h"
#import "RecommendPersonEntity.h"
#import "ShareHREntity.h"

@interface RecommendPersonController ()
{
    NSInteger pageIndex;
}

@property (nonatomic, strong) UIButton *recommendButton;

@end

@implementation RecommendPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐";
    
    [self initView];
}

- (void)initView
{
    // 注册cell
    UINib *nib1 = [UINib nibWithNibName:@"RecommendPersonCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"RecommendPersonCell"];
    [self.view addSubview:self.tableView];
    self.tableView.yq_height -= (50+APP_BottomH);;
    
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
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendPersonCell"];
    
    RecommendPersonEntity *en = [self.tableArr objectAtIndex:indexPath.row];
    
    cell.entity = en;
    
    YQWeakSelf;
    cell.selectBlock = ^(NSIndexPath *indexPath, RecommendPersonEntity *entity) {
        [weakSelf selectClick:indexPath entity:entity];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RecommendPersonEntity *personEn = self.tableArr[indexPath.row];
    
    HomeJobEntity *en = [[HomeJobEntity alloc] init];
    en.uid = personEn.itemId;
    //en.post = @"";
    en.delivery = @"-1";
    en.payposition = @"-1";
    
    HomePositionDetailVC *vc = [[HomePositionDetailVC alloc] init];
    vc.jobEntity = en;
    vc.isRecommend = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 事件

- (void)selectClick:(NSIndexPath *)path entity:(RecommendPersonEntity *)entity
{
    for (RecommendPersonEntity *en in self.tableArr) {
        if ([en isEqual:entity]) {
            en.isSelect = YES;
        }else{
            en.isSelect = NO;
        }
    }
    [self.tableView reloadData];
    
    [self.recommendButton setTitle:[self recommendTitle:entity.cname] forState:UIControlStateNormal];
}

- (void)recommentClick:(UIButton *)sender
{
    RecommendPersonEntity *entity = nil;
    for (RecommendPersonEntity *en in self.tableArr) {
        if (en.isSelect) {
            entity = en;
            break;
        }
    }
    if (entity != nil) {
        [self reqRecommend:entity];
    }
}

- (NSString *)recommendTitle:(NSString *)cName
{
    NSString *str = [NSString stringWithFormat:@"把 %@ 推荐给(%@)",self.shareEntity.name,cName];
    return str;
}

#pragma mark - 网络请求
// 把XX推荐给XX
- (void)reqRecommend:(RecommendPersonEntity *)entity
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getHRRecommend_uid:[UserEntity getUid] pid:entity.itemId type:@"2" puid:entity.puid shareid:self.shareEntity.uid success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"推荐成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.recommendSuccess) {
                self.recommendSuccess(self.shareEntity);
            }
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
    [[RequestManager sharedRequestManager] getHRRecommendPersonList_uid:@"" rid:self.shareEntity.uid posi_name:self.shareEntity.posi_name city:self.shareEntity.city page:page pagesize:KPageSize success:^(id resultDic) {
        [self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            NSArray *array = resultDic[DATA];
            for (NSDictionary *dic in array) {
                RecommendPersonEntity *en = [RecommendPersonEntity RecommendPersonEntityWithDict:dic];
                en.isSelect = NO;
                [tempArr addObject:en];
            }
            
            if (self.isPullDown) {
                self.tableArr = tempArr;
            }else {
                [self.tableArr addObjectsFromArray:tempArr];
            }
            int flag = 0;
            for (RecommendPersonEntity *en in self.tableArr) {
                if (en.isSelect) {
                    flag = 1;
                    self.recommendButton.hidden = NO;// 显示推荐按钮
                    [self.recommendButton setTitle:[self recommendTitle:en.cname] forState:UIControlStateNormal];
                    break;
                }
            }
            if (flag == 0 && self.tableArr.count>0) {
                RecommendPersonEntity *en = [self.tableArr objectAtIndex:0];
                en.isSelect = YES;
                self.recommendButton.hidden = NO;// 显示推荐按钮
                [self.recommendButton setTitle:[self recommendTitle:en.cname] forState:UIControlStateNormal];
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
