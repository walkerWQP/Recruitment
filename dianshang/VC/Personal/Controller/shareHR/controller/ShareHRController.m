//
//  ShareHRController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ShareHRController.h"
#import "RecommendPersonController.h"
#import "WhiteListController.h"
#import "CompanyPersonalDetailVC.h"
#import "CompanyHomeEntity.h"
#import "ShareInvitationController.h"

#import "ShareHREntity.h"
#import "ShareHRCell.h"

#import "YQGroupTableItem.h"
#import "YQPageScrollView.h"

#import "UserInfo+CoreDataClass.h"
#import "YQViewController+YQShareMethod.h"

@interface ShareHRController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger curTableIndex;
    NSIndexPath *currentPath;
}
@property (nonatomic, strong) YQPageScrollView *scrollView;

@property (nonatomic, assign) BOOL isPullDown;

@property (nonatomic, strong) NSMutableArray *tableGroups;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *headLineView;
/// 存放选中的对象
@property (nonatomic, strong) NSMutableArray *selectedObject;
/// 存放选中的indexPath对象
@property (nonatomic, strong) NSMutableArray *selIndexPath;

// 是否是从验单页面返回,如果是就刷新列表
@property (nonatomic, assign) BOOL yandanVC;

@end

@implementation ShareHRController

- (NSMutableArray *)tableGroups
{
    if (_tableGroups == nil) {
        _tableGroups = [NSMutableArray array];
        NSArray *titleArr = @[@"人才库",@"待面试",@"已面试",@"已入职",@"已转正"];
        for (int i = 0; i < titleArr.count; i++) {
            YQGroupTableItem *item = [[YQGroupTableItem alloc] init];
            item.title = [titleArr objectAtIndex:i];
            item.tableView = [[UITableView alloc] init];
            item.tableViewArray = [NSMutableArray array];
            item.button = [[UIButton alloc] init];
            item.pageCount = i+1;
            item.shareHRType = i+1;
            [_tableGroups addObject:item];
        }
    }
    return _tableGroups;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.yandanVC) {
        YQGroupTableItem *item3 = [self.tableGroups objectAtIndex:curTableIndex];
        [item3.tableView.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selIndexPath = [NSMutableArray array];
    //设置导航栏
    [self setNav];
    // 添加表
    [self initView];
    
    // 添加邀请按钮
    [self invitationView];
}
- (void)invitationView
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    button.center = CGPointMake(APP_WIDTH-35, APP_HEIGHT-APP_BottomH-APP_TABH-50-APP_NAVH);
    button.backgroundColor = RGB(49, 117, 210);
//    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:35];
    button.layer.cornerRadius = button.yq_height * 0.5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(invitationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
//设置导航栏
- (void)setNav
{
    self.navigationItem.title = @"共享招聘顾问";
//    UIBarButtonItem *back = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(backButnClicked:)];
//    self.navigationItem.leftBarButtonItem = back;
    
//    NSMutableArray *titleArr = [NSMutableArray array];
//    for (YQGroupTableItem *item in self.tableGroups) {
//        [titleArr addObject:item.title];
//    }
//    if (titleArr.count > 1) {
//        self.navigationItem.title = @"共享HR";
//    }else{
//        self.navigationItem.title = [titleArr lastObject];
//    }
    
    if (![UserEntity getIsCompany]) {
        UIBarButtonItem *right = [UIBarButtonItem itemWithtitle:@"我的顾问" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
        self.navigationItem.rightBarButtonItem = right;
    }
    
}
- (void)rightClick:(UIButton *)sender
{
    WhiteListController *vc = [[WhiteListController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backButnClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView
{
    [self initHeadView];
    [self initScrollerView];
    
    CGFloat buttonW = APP_WIDTH/self.tableGroups.count;
    CGFloat buttonH = self.headView.yq_height;
    //根据模型创建button和tableView
    for (int i = 0; i < self.tableGroups.count; i++) {
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:i];
        
        CGFloat buttonX = i*buttonW;
        CGFloat buttonY = 0;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:item.title forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.headView addSubview:button];
        
        UITableView *myTable  = [[UITableView alloc] initWithFrame:CGRectMake(i*APP_WIDTH, 0, APP_WIDTH, self.scrollView.yq_height) style:UITableViewStylePlain];
        myTable.delegate = self;
        myTable.dataSource = self;
        myTable.scrollsToTop = NO;
        myTable.tableFooterView = [[UIView alloc] init];
        if (IOS_VERSION_11_OR_ABOVE) {
            myTable.estimatedRowHeight = 0;
            myTable.estimatedSectionHeaderHeight = 0;
            myTable.estimatedSectionFooterHeight = 0;
        }
        // 注册cell
        UINib *nib1 = [UINib nibWithNibName:@"ShareHRCell" bundle:nil];
        [myTable registerNib:nib1 forCellReuseIdentifier:@"ShareHRCell"];
        // 添加刷新控件
        [self setupRefresh:myTable];
        [self.scrollView addSubview:myTable];
        
        //去除表格线在左端留有的空白（在viewDidLoad中添加）
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)])
        {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)])
        {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if (i==0) {
            self.headLineView = [[UIView alloc] initWithFrame:CGRectMake(button.yq_x, self.headView.yq_height-2, button.yq_width, 2)];
            self.headLineView.backgroundColor = THEMECOLOR;
            [self.headView addSubview:self.headLineView];
            [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
            //默认刷新第一个表
            [myTable.mj_header beginRefreshing];
        }
        item.tableView = myTable;
        item.button = button;
    }
}

- (void)initHeadView
{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    self.headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.yq_height-0.5, self.headView.yq_width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.737 alpha:1.000];
    [self.headView addSubview:lineView];
}

- (void)initScrollerView
{
    self.scrollView = [[YQPageScrollView alloc] initWithFrame:CGRectMake(0, 40, APP_WIDTH, APP_HEIGHT-APP_NAVH-40-APP_TABH)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(self.tableGroups.count*APP_WIDTH, self.scrollView.yq_height-50);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    //    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
}
- (void)invitationClick:(UIButton *)sender
{
//    ShareInvitationController *vc = [[ShareInvitationController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"这里添加分享功能");
    
    [self shareView];
    
}

// 设置分享参数
- (NSMutableDictionary *)getShateParameters
{
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *title = @"E招招聘,共享招聘顾问,找工作赚佣金";
    NSString *messageStr = @"找工作还在靠自己？上E招招聘，万人帮你推荐优质职位，我的工作从此就靠小伙伴。";
    
    NSString *image = [UserEntity getHeadImgUrl];
    NSString *urlStr = [NSString stringWithFormat:@"%@/index/sharelist.html?uid=%@",H5BaseURL,[UserEntity getUid]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    // 通用参数设置
    [parameters SSDKSetupShareParamsByText:messageStr
                                    images:image
                                       url:url
                                     title:title
                                      type:SSDKContentTypeAuto];
    
    return parameters;
}


- (void)buttonClick:(UIButton *)sender
{
    // 设置选中按钮样式
    [self setHeadViewButton:sender.tag];
    
    // 设置滑动的线
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:sender.tag];
    UIButton *button = item.button;
    [UIView animateWithDuration:0.3 animations:^{
        self.headLineView.yq_x = button.yq_x;
    }];
    // 设置滑动的偏移量
    self.scrollView.contentOffset = CGPointMake(sender.tag*APP_WIDTH, 0);
    //    [scroller setContentOffset:CGPointMake((sender.tag-1)*APP_WIDTH, 0) animated:NO];
}

//设置选中按钮样式
- (void)setHeadViewButton:(NSInteger)page
{
    curTableIndex = page;
    
    YQGroupTableItem *item3 = [self.tableGroups objectAtIndex:page];
    if (item3.tableViewArray.count == 0) {
        //>0 就不主动刷新
        [item3.tableView.mj_header beginRefreshing];
        // ==0 默认不选中
    }else{
        // 重新设置全选按钮状态
        //[self setAllSelectBtnWithTableIndex:nil];
    }
    // 设置按钮标题
    //[self setButtonTitle:page];
    
    for (int i = 0; i < self.tableGroups.count; i++) {
        YQGroupTableItem *itema = [self.tableGroups objectAtIndex:i];
        UIButton *button = itema.button;
        if ([button isEqual:item3.button]) {
            [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - scroller

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        //线条的跟随动画
        self.headLineView.yq_x = scrollView.contentOffset.x/self.tableGroups.count;
        self.isShowNoMoreData = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x / pageWidth));
        //NSLog(@"%d",page);
        
        //设置选中按钮样式
        [self setHeadViewButton:page];
    }
}
#pragma mark - table
//去除表格线在左端留有的空白（tableView的代理方法）
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    if (curTableIndex == 0) {
        return 110;
    }
    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    if (item.tableViewArray.count > 0) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    self.isShowNoMoreData = item.tableViewArray.count == 0;
    item.tableView.mj_footer.hidden = item.tableViewArray.count == 0;
    return item.tableViewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    UITableView *myTable = item.tableView;
    NSArray *array = item.tableViewArray;
    ShareHREntity *en = [array objectAtIndex:indexPath.row];
    
    ShareHRCell * cell = [myTable dequeueReusableCellWithIdentifier:@"ShareHRCell"];
    cell.entity = en;
    //是否显示推荐他按钮   后期需要的话可以再加上
//    cell.isRecommendBtn = curTableIndex == 0;
    cell.isTypeLabel = curTableIndex == 0;
    YQWeakSelf;
    cell.recommendBlock = ^(NSIndexPath *indexPath, ShareHREntity *entity) {
        [weakSelf recommendClick:indexPath entity:entity];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (curTableIndex == 0) {
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
        ShareHREntity *shareEn = [item.tableViewArray objectAtIndex:indexPath.row];
        
        CompanyHomeEntity *en = [[CompanyHomeEntity alloc] init];
        en.itemId = shareEn.uid;
        en.name = shareEn.name;
        en.paymember = @"-1";
        
        CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
        vc.entity = en;
        vc.isRecommend = NO;
        vc.isChat = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 添加刷新控件

-(void)setupRefresh:(UITableView *)myTable
{
    YQWeakSelf;
    myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isPullDown = YES;
        [weakSelf headerRereshing];
    }];
    myTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isPullDown = NO;
        [weakSelf footerRereshing];
    }];
}

- (void)headerRereshing
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    item.pageCount = 1;
    [self reqOrderList:[NSString stringWithFormat:@"%li",item.pageCount]];
}

- (void)footerRereshing
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    item.pageCount++;
    [self reqOrderList:[NSString stringWithFormat:@"%li",item.pageCount]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

- (void)recommendClick:(NSIndexPath *)path entity:(ShareHREntity *)entity
{
    currentPath = path;
    
    RecommendPersonController *vc = [[RecommendPersonController alloc] init];
    vc.shareEntity = entity;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    YQWeakSelf;
    vc.recommendSuccess = ^(ShareHREntity *shareEntity) {
        [weakSelf deleteRow];
    };
}

- (void)deleteRow
{
    if (currentPath != nil) {
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
        [item.tableViewArray removeObjectAtIndex:currentPath.row];
        if (item.tableViewArray.count == 0) { // 要根据情况直接删除section或者仅仅删除row
            [item.tableView deleteSections:[NSIndexSet indexSetWithIndex:currentPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [item.tableView deleteRowsAtIndexPaths:@[currentPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
#pragma mark - 网络请求

- (void)reqOrderList:(NSString *)page
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    //1、可推荐；2、待面试；3、已面试；4、已入职；5、已转正
    NSString *typeStr = [NSString stringWithFormat:@"%li",item.shareHRType];
    
    [[RequestManager sharedRequestManager] getHRRecommendList_uid:[UserEntity getUid] type:typeStr page:page pagesize:KPageSize pname:@"" success:^(id resultDic) {
        [self handleRequestList:resultDic];
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

// 处理网络返回结果->列表
- (void)handleRequestList:(id)resultDic
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    
    [item.tableView.mj_header endRefreshing];
    [item.tableView.mj_footer endRefreshing];
    
    if ([resultDic[CODE] isEqualToString:SUCCESS]) {
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        NSArray *array = resultDic[DATA];
        for (NSDictionary *dic in array) {
            ShareHREntity *en = [ShareHREntity ShareHREntityWithDict:dic];
            [tempArr addObject:en];
        }
        if (self.isPullDown) {
            item.tableViewArray = tempArr;
        }else {
            [item.tableViewArray addObjectsFromArray:tempArr];
        }
        [item.tableView reloadData];
        if (array.count < [KPageSize integerValue]) {
            [item.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else if ([resultDic[CODE] isEqualToString:@"100003"]){
        [item.tableView.mj_footer endRefreshingWithNoMoreData];
    }
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
