//
//  DeliveryJobController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DeliveryJobController.h"
#import "InterviewDetailController.h"
#import "HomePositionDetailVC.h"

#import "YQGroupTableItem.h"
#import "HomeJobEntity.h"

#import "DeliveryJobCell.h"
#import "YQPageScrollView.h"

@interface DeliveryJobController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger curTableIndex;
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
//@property (nonatomic, assign) BOOL yandanVC;

@end

@implementation DeliveryJobController

- (NSMutableArray *)tableGroups
{
    if (_tableGroups == nil) {
        _tableGroups = [NSMutableArray array];
        NSArray *titleArr = @[@"面试",@"已入职",@"已转正",@"已离职"];
        for (int i = 0; i < titleArr.count; i++) {
            YQGroupTableItem *item = [[YQGroupTableItem alloc] init];
            item.title = [titleArr objectAtIndex:i];
            item.tableView = [[UITableView alloc] init];
            item.tableViewArray = [NSMutableArray array];
            item.button = [[UIButton alloc] init];
            item.pageCount = 1;
            item.deliveryType = i+1;
            [_tableGroups addObject:item];
        }
    }
    return _tableGroups;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (self.yandanVC) {
//        YQGroupTableItem *item3 = [self.tableGroups objectAtIndex:curTableIndex];
//        [item3.tableView.mj_header beginRefreshing];
//    }
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
        self.navigationItem.title = @"面试记录";
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
        UINib *nib1 = [UINib nibWithNibName:@"DeliveryJobCell" bundle:nil];
        [myTable registerNib:nib1 forCellReuseIdentifier:@"DeliveryJobCell"];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    if (item.tableViewArray.count > 0) {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    NSArray *array = item.tableViewArray;
    HomeJobEntity *en = [array objectAtIndex:indexPath.row];
    
    CGFloat h = 80;
    if (curTableIndex == 0) {
        h += 30;
    }
    if (en.rname.length > 0) {
        h += 30;
    }
    return h;
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
    
    DeliveryJobCell * cell = [myTable dequeueReusableCellWithIdentifier:@"DeliveryJobCell"];
    cell.curTable = curTableIndex;
    cell.entity = en;
    
    YQWeakSelf;
    cell.commentBlock = ^(NSIndexPath *indexPath, HomeJobEntity *entity) {
        [weakSelf commentClick:indexPath entity:entity];
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
    vc.isRecommend = en.rname.length > 0;
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

#pragma mark ========事件处理========

- (void)commentClick:(NSIndexPath *)path entity:(HomeJobEntity *)entity
{
    if ([entity.cdealwith isEqualToString:@"3"]) {
        // 已邀请
        InterviewDetailController *vc = [[InterviewDetailController alloc] init];
        vc.orderid = entity.orderid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ========网络请求========

- (void)reqOrderList:(NSString *)page
{
    //5、已面试；6、已入职；7、已转正；8、已离职
    NSString *typeStr = [NSString stringWithFormat:@"%li",curTableIndex+5];
    
    [[RequestManager sharedRequestManager] getInterviewJobList_uid:[UserEntity getUid] dealwith:typeStr page:page pagesize:KPageSize success:^(id resultDic) {
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
            en.delivery = @"1";
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
        if (self.isPullDown) {
            YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
            [item.tableViewArray removeAllObjects];
            [item.tableView reloadData];
        }
        [item.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark ========接单========
- (void)reqAcceptList:(NSArray *)batchid
{
    //    [self.hud show:YES];
    //    [[RequestManager sharedRequestManager] connectUserid:[UserEntity uid] batchid:batchid success:^(id resultDic) {
    //        //        UIButton *button = [[UIButton alloc] init];
    //        //        button.tag = 1;
    //        //        [self buttonClick:button];
    //        //处理返回结果
    //        [self handleRequest:resultDic];
    //    } failure:^(NSError *error) {
    //        [self.hud hide:YES];
    //        [LToast showWithText:error.domain bottomOffset:100];
    //    }];
}
/// 拒绝接单
- (void)reqRefuseList:(NSArray *)batchid
{
    //    [self.hud show:YES];
    //    [[RequestManager sharedRequestManager] refuseListUserid:[UserEntity uid] batchid:batchid success:^(id resultDic) {
    //        //处理返回结果
    //        [self handleRequest:resultDic];
    //    } failure:^(NSError *error) {
    //        [self.hud hide:YES];
    //        [LToast showWithText:error.domain bottomOffset:100];
    //    }];
    
}
//处理网络返回结果
- (void)handleRequest:(id)resultDic
{
    //    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    //
    //    [self.hud hide:YES];
    //    NSNumber *status = resultDic[STATUS];
    //    if (![status isEqualToNumber:@-1]) {
    //        [LToast showWithText:resultDic[INFO] bottomOffset:100];
    //        /// 删除选择的对象
    //        [item.tableViewArray removeObjectsInArray:self.selectedObject];
    //        //        [item.tableView deleteRowsAtIndexPaths:self.selIndexPath withRowAnimation:UITableViewRowAnimationFade];
    //        //        [self.selectedObject removeAllObjects];
    //        //        [self.selIndexPath removeAllObjects];
    //        [item.tableView reloadData];
    //        [item.tableView.mj_footer endRefreshingWithNoMoreData];
    //    }else{
    //        [LToast showWithText:resultDic[INFO] bottomOffset:100];
    //    }
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
