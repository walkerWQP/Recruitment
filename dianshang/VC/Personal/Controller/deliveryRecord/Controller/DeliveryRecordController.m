//
//  DeliveryRecordController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DeliveryRecordController.h"
#import "HomePositionDetailVC.h"
#import "InterviewDetailController.h"

#import "YQGroupTableItem.h"
#import "HomeJobEntity.h"

#import "DeliveryRecordCell.h"
#import "YQPageScrollView.h"

@interface DeliveryRecordController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
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

@end

@implementation DeliveryRecordController

- (NSMutableArray *)tableGroups
{
    if (_tableGroups == nil) {
        _tableGroups = [NSMutableArray array];
        NSArray *titleArr = @[@"直接投递",@"HR推荐"];
        for (int i = 0; i < titleArr.count; i++) {
            YQGroupTableItem *item = [[YQGroupTableItem alloc] init];
            item.title = [titleArr objectAtIndex:i];
            item.tableView = [[UITableView alloc] init];
            item.tableViewArray = [NSMutableArray array];
            item.button = [[UIButton alloc] init];
            item.pageCount = 1;
            item.deliveryType = i;
            [_tableGroups addObject:item];
        }
    }
    return _tableGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selIndexPath = [NSMutableArray array];
    
    [self setNav];
    
    [self initView];
    
}

#pragma mark ========设置导航栏========
- (void)setNav
{
    NSMutableArray *titleArr = [NSMutableArray array];
    for (YQGroupTableItem *item in self.tableGroups) {
        [titleArr addObject:item.title];
    }
    if (titleArr.count > 1) {
        self.navigationItem.title = @"投递记录";
    }else{
        self.navigationItem.title = [titleArr lastObject];
    }
}

#pragma mark ========添加表========
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
        UINib *nib1 = [UINib nibWithNibName:@"DeliveryRecordCell" bundle:nil];
        [myTable registerNib:nib1 forCellReuseIdentifier:@"DeliveryRecordCell"];
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
    self.scrollView = [[YQPageScrollView alloc] initWithFrame:CGRectMake(0, 40, APP_WIDTH, APP_HEIGHT-APP_NAVH-40)];
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

#pragma mark ========设置选中按钮样式========
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

#pragma mark ========去除表格线在左端留有的空白（tableView的代理方法）========
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
    if (curTableIndex == 1) {
        return 140;
    }
    return 110;
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
    HomeJobEntity *en = [array objectAtIndex:indexPath.row];
    
    DeliveryRecordCell * cell = [myTable dequeueReusableCellWithIdentifier:@"DeliveryRecordCell"];
    cell.curTable = curTableIndex;
    cell.entity = en;
    
    YQWeakSelf;
    cell.detailBlock = ^(NSIndexPath *indexPath, HomeJobEntity *entity) {
        [weakSelf detailClick:indexPath entity:entity];
    };
    cell.otherBlock = ^(NSIndexPath *indexPath, HomeJobEntity *entity, NSInteger index) {
        if ([entity.cdealwith isEqualToString:@"3"] && index == 1) {
            [weakSelf reqAgreeInterview:indexPath entity:entity];
        }else if ([entity.cdealwith isEqualToString:@"3"] && index == 2){
            [weakSelf reqRefuseInterview:indexPath entity:entity];
        }else if ([entity.cdealwith isEqualToString:@"3"] && index == 3){
            [weakSelf detailClick:indexPath entity:entity];
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    HomeJobEntity *en = [item.tableViewArray objectAtIndex:indexPath.row];
    
    HomePositionDetailVC *vc = [[HomePositionDetailVC alloc] init];
    vc.jobEntity = en;
    vc.isRecommend = curTableIndex == 1;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ========添加刷新控件========

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

#pragma mark ========邀请详情========
- (void)detailClick:(NSIndexPath *)path entity:(HomeJobEntity *)entity
{
    currentPath = path;
    
    InterviewDetailController *vc = [[InterviewDetailController alloc] init];
    vc.orderid = entity.orderid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ========网络请求========

- (void)reqOrderList:(NSString *)page
{
    //YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    // 1、人才直投；2、hr推荐
    NSString *typeStr = [NSString stringWithFormat:@"%li",curTableIndex+1];
    
    [[RequestManager sharedRequestManager] getDeliveryRecordList_uid:[UserEntity getUid] type:typeStr page:page pagesize:KPageSize success:^(id resultDic) {
        [self handleRequestList:resultDic];
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark ========处理网络返回结果->列表========
- (void)handleRequestList:(id)resultDic
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    
    [item.tableView.mj_header endRefreshing];
    [item.tableView.mj_footer endRefreshing];
    
    if ([resultDic[CODE] isEqualToString:SUCCESS]) {
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        NSArray *array = resultDic[DATA];
        
        for (NSDictionary *dic in array) {
            HomeJobEntity *en = [HomeJobEntity HomeJobEntityWithDict:dic];
            en.uid = en.posid;
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

#pragma mark ========同意邀请========
- (void)reqAgreeInterview:(NSIndexPath *)path entity:(HomeJobEntity *)entity
{
    currentPath = path;
    
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] interviewOperation_uid:[UserEntity getUid] orderid:entity.orderid type:@"1" success:^(id resultDic) {
        [self.hud hide:YES];
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
            HomeJobEntity *en = [item.tableViewArray objectAtIndex:currentPath.row];
            en.mdealwith = @"1";
            [item.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark ========拒绝邀请========
- (void)reqRefuseInterview:(NSIndexPath *)path entity:(HomeJobEntity *)entity
{
    currentPath = path;
    
    if ([entity.mdealwith isEqualToString:@"3"]) {
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] interviewOperation_uid:[UserEntity getUid] orderid:entity.orderid type:@"2" success:^(id resultDic) {
            [self.hud hide:YES];
            
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                
                YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
                HomeJobEntity *en = [item.tableViewArray objectAtIndex:currentPath.row];
                en.mdealwith = @"2";
                [item.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }else{
        
        InterviewDetailController *vc = [[InterviewDetailController alloc] init];
        vc.orderid = entity.orderid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



@end
