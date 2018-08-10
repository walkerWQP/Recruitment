//
//  CompanyDetailController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyDetailController.h"
#import "BusinessDetailController.h"

#import "CompanyDetailView.h"
#import "CompanyDetailCell.h"

#import "CompanyDetailEntity.h"

#import "UIImage+colorImage.h"

@interface CompanyDetailController ()

@property (nonatomic, strong) CompanyDetailEntity *companyEntity;

@property (nonatomic, strong) CompanyDetailView *companyDetailView;

@end

@implementation CompanyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initView];
    
    [self setNav];
    
    [self reqCompanyDetail];
}

- (void)initView
{
    UINib *nib1 = [UINib nibWithNibName:@"CompanyDetailCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"CompanyDetailCell"];
    
    self.companyDetailView = [CompanyDetailView companyView];
    self.tableView.tableHeaderView = self.companyDetailView;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.yq_height = APP_HEIGHT;
    if (IS_IPhoneX) {
        self.tableView.yq_y = -44;
    }
    YQWeakSelf;
    self.companyDetailView.linkClick = ^(CompanyDetailEntity *entity) {
        [weakSelf goCompanyLink:entity];
    };
}
- (void)goCompanyLink:(CompanyDetailEntity *)entity
{
    NSString *urlStr = entity.link;
    if (![urlStr hasPrefix:@"http"]) {
        urlStr = [NSString stringWithFormat:@"http://%@",urlStr];
    }
    BusinessDetailController *detail = [[BusinessDetailController alloc] init];
    detail.urlStr = urlStr;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)setNav
{
    UIButton *leftButn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButn setImage:[UIImage imageWithOriginalImageName:@"bg_back"] forState:UIControlStateNormal];
    [leftButn setImage:[UIImage imageWithOriginalImageName:@"bg_back"] forState:UIControlStateHighlighted];
    [leftButn addTarget:self action:@selector(backButnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButn sizeToFit];
    //leftButn.backgroundColor = RandomColor;
    leftButn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButn setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    leftButn.frame = CGRectMake(0, 20, APP_WIDTH*0.3, 44);
    [self.view addSubview:leftButn];
}

- (void)backButnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDescItem *item = [self.tableArr objectAtIndex:indexPath.row];
    NSInteger h = 0;
    if (item.height > 80) {
        if (item.isOpen) {
            h = item.height;
        }else{
            h = 80;
        }
    }else if (item.height < 25){
        h = 25;
    }else{
        h = item.height;
    }
    return 120-33+h;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyDetailCell"];
    
    CDescItem *item = [self.tableArr objectAtIndex:indexPath.row];
    cell.entity = item;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YQWeakSelf;
    cell.openBlock = ^(NSIndexPath *path) {
        [weakSelf openClick:path];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}

- (void)openClick:(NSIndexPath *)path
{
    CDescItem *item = [self.tableArr objectAtIndex:path.row];
    item.isOpen = !item.isOpen;
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 网络访问

- (void)reqCompanyDetail
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] homeCompanyDetail_uid:@"" mid:self.memberId companyid:self.companyId success:^(id resultDic) {
        [self.hud hide:YES];
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            //[EZPublicList printPropertyWithDict:resultDic[@"data"]];
            
            CompanyDetailEntity *entity = [CompanyDetailEntity entityWithDict:resultDic[DATA]];
            self.companyEntity = entity;
            
            self.companyDetailView.entity = entity;
            
            NSArray *array = @[@"公司介绍",@"产品介绍",@"团队介绍"];
            NSArray *arrayinfo = @[entity.companyinfo,entity.productinfo,entity.teaminfo];
            NSInteger index = 0;
            for (NSString *str in array) {
                CDescItem *item = [[CDescItem alloc] init];
                item.title = str;
                item.desc = [arrayinfo objectAtIndex:index++];
                item.isOpen = NO;
                
                [self.tableArr addObject:item];
            }
            [self.tableView reloadData];
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

@end
