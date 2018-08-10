//
//  CResumeRecommendController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/5.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CResumeRecommendController.h"
#import "InterviewDetailController.h"
#import "CSelectPositionController.h"
#import "InvitationInterviewController.h"
#import "CompanyPersonalDetailVC.h"
#import "COrderPayController.h"

#import "YQGroupTableItem.h"
#import "CompanyHomeEntity.h"

#import "XLAlertView.h"
#import "KNActionSheet.h"
#import "CResumeDeliverCell.h"
#import "YQPageScrollView.h"

@interface CResumeRecommendController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,XLAlertViewDelegate>
{
    NSInteger curTableIndex;
    
    NSIndexPath *currentPath;
}
@property (nonatomic, strong) YQPageScrollView *scrollView;

@property (nonatomic, assign) BOOL isPullDown;

@property (nonatomic, strong) NSMutableArray *tableGroups;

@property (nonatomic, strong) UIScrollView *headView;
@property (nonatomic, strong) UIView *headLineView;
/// 存放选中的对象
@property (nonatomic, strong) NSMutableArray *selectedObject;
/// 存放选中的indexPath对象
@property (nonatomic, strong) NSMutableArray *selIndexPath;

@property (nonatomic, strong) NSString *pName;
// 是否面试
//@property (nonatomic, strong) NSString *redPacket;
@end

@implementation CResumeRecommendController
- (NSMutableArray *)tableGroups
{
    if (_tableGroups == nil) {
        _tableGroups = [NSMutableArray array];
        NSArray *titleArr = @[@"人才简历",@"待面试",@"已面试",@"已入职",@"已转正",@"已离职"];
        for (int i = 0; i < titleArr.count; i++) {
            YQGroupTableItem *item = [[YQGroupTableItem alloc] init];
            item.title = [titleArr objectAtIndex:i];
            item.tableView = [[UITableView alloc] init];
            item.tableViewArray = [NSMutableArray array];
            item.button = [[UIButton alloc] init];
            item.pageCount = 1;
            //item.deliveryType = i+1;
            [_tableGroups addObject:item];
        }
    }
    return _tableGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.positionName.length > 0) {
        self.pName = self.positionName;
        UIBarButtonItem *item = [UIBarButtonItem itemWithtitle:self.pName titleColor:[UIColor whiteColor] target:self action:@selector(switchPosition)];
        UIButton *button = item.customView;
        button.yq_width = APP_WIDTH/3;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }else{
        self.pName = @"";
        UIBarButtonItem *item = [UIBarButtonItem itemWithtitle:@"全部" titleColor:[UIColor whiteColor] target:self action:@selector(switchPosition)];
        UIButton *button = item.customView;
        button.yq_width = APP_WIDTH/3;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
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
        self.navigationItem.title = @"HR推荐";
    }else{
        self.navigationItem.title = [titleArr lastObject];
    }
}

#pragma mark ========添加表========
- (void)initView
{
    [self initHeadView];
    [self initScrollerView];
    
    CGFloat buttonW = ((APP_WIDTH-30)/4);
    //CGFloat buttonW = APP_WIDTH/self.tableGroups.count;
    CGFloat buttonH = self.headView.yq_height;
    self.headView.contentSize = CGSizeMake(buttonW*self.tableGroups.count, buttonH);
#pragma mark ========根据模型创建button和tableView========
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
#pragma mark ========注册cell========
        UINib *nib1 = [UINib nibWithNibName:@"CResumeDeliverCell" bundle:nil];
        [myTable registerNib:nib1 forCellReuseIdentifier:@"CResumeDeliverCell"];
#pragma mark ========添加刷新控件========
        [self setupRefresh:myTable];
        [self.scrollView addSubview:myTable];
        
#pragma mark ========去除表格线在左端留有的空白（在viewDidLoad中添加）========
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
#pragma mark ========默认刷新第一个表========
            [myTable.mj_header beginRefreshing];
        }
        item.tableView = myTable;
        item.button = button;
    }
}

- (void)initHeadView
{
    self.headView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.headView.showsHorizontalScrollIndicator = NO;
    self.headView.bounces = NO;
    [self.view addSubview:self.headView];
    
    CGFloat buttonW = ((APP_WIDTH-30)/4);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.yq_height-0.5, self.tableGroups.count * buttonW, 0.5)];
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
#pragma mark ========设置选中按钮样式========
    [self setHeadViewButton:sender.tag];
    
#pragma mark ========设置滑动的线========
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:sender.tag];
    UIButton *button = item.button;
    [UIView animateWithDuration:0.3 animations:^{
        self.headLineView.yq_x = button.yq_x;
    }];
#pragma mark ========设置滑动的偏移量========
    self.scrollView.contentOffset = CGPointMake(sender.tag*APP_WIDTH, 0);
    //    [scroller setContentOffset:CGPointMake((sender.tag-1)*APP_WIDTH, 0) animated:NO];
}

#pragma mark ========设置选中按钮样式========
- (void)setHeadViewButton:(NSInteger)page
{
    curTableIndex = page;
    
    YQGroupTableItem *item3 = [self.tableGroups objectAtIndex:page];
    if (item3.tableViewArray.count == 0) {
#pragma mark ========>0 就不主动刷新========
        [item3.tableView.mj_header beginRefreshing];
#pragma mark ==========0 默认不选中========
    }else{
#pragma mark ========重新设置全选按钮状态========
        if (item3.refreshFlag) {
            item3.refreshFlag = NO;
            [item3.tableView.mj_header beginRefreshing];
        }
    }
#pragma mark ========设置按钮标题========
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
    
#pragma mark ========设置headview的偏移量========
    UIButton *button = item3.button;
    UIScrollView *scroll = (UIScrollView *)[button superview];
    CGFloat offset = 0;
    if (button.center.x > scroll.yq_width*0.5 && scroll.contentSize.width - button.center.x > scroll.yq_width*0.5) {
        offset = (button.center.x - scroll.yq_width*0.5);
        //[scroll setContentOffset:CGPointMake(offset, 0) animated:YES];
    }else if (button.center.x < scroll.yq_width*0.5){
        offset = 0;
        //[scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (scroll.contentSize.width - button.center.x < scroll.yq_width*0.5){
        offset = (scroll.contentSize.width - scroll.yq_width);
    }
    
    if (scroll.contentSize.width > scroll.yq_width) {
        [scroll setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
}

#pragma mark - scroller

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else if ([scrollView isKindOfClass:[UIScrollView class]]) {
#pragma mark ========线条的跟随动画========
        //self.headLineView.yq_x = scrollView.contentOffset.x/self.tableGroups.count;
        self.headLineView.yq_x = scrollView.contentOffset.x/APP_WIDTH*self.self.headLineView.yq_width;
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
        
#pragma mark ========设置选中按钮样式========
        [self setHeadViewButton:page];
    }
}
#pragma mark - table
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
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    NSArray *array = item.tableViewArray;
    CompanyHomeEntity *en = [array objectAtIndex:indexPath.row];
    
    CGFloat h = 80;
    if (curTableIndex != 5) {
        h += 30;
    }
    if (en.rname.length > 0) {
        h += 45;
    }
    return h;
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
    CompanyHomeEntity *en = [array objectAtIndex:indexPath.row];
    
    CResumeDeliverCell * cell = [myTable dequeueReusableCellWithIdentifier:@"CResumeDeliverCell"];
    cell.curTable = curTableIndex;
    cell.entity = en;
    
    
    YQWeakSelf;
    cell.commentBlock = ^(NSIndexPath *indexPath, CompanyHomeEntity *entity) {
        [weakSelf commentClick:indexPath entity:entity];
    };
    cell.invitationBlock = ^(NSIndexPath *indexPath, CompanyHomeEntity *entity) {
        [weakSelf invitationPersonal:indexPath entity:entity];
    };
    cell.closeBlock = ^(NSIndexPath *indexPath, CompanyHomeEntity *entity) {
        [weakSelf closeClick:indexPath entity:entity];
    };
    cell.payBlock = ^(NSIndexPath *indexPath, CompanyHomeEntity *entity) {
        [weakSelf payClick:indexPath entity:entity];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    CompanyHomeEntity *en = [item.tableViewArray objectAtIndex:indexPath.row];

    CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
    vc.entity = en;
    vc.isRecommend = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
- (void)switchPosition
{
    if (self.positionName.length == 0) {
        UIButton *button = self.navigationItem.rightBarButtonItem.customView;
        CSelectPositionController *vc = [[CSelectPositionController alloc] init];
        vc.pName = button.currentTitle;
        YQWeakSelf;
        vc.selectBlock = ^(NSString *positionName) {
            [weakSelf refreshTable:positionName];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ========未面试========
- (void)payClick:(NSIndexPath *)path entity:(CompanyHomeEntity *)entity
{
//    currentPath = path;
//
//    COrderPayController *vc = [[COrderPayController alloc] init];
//    //vc.entity = en;
//    [self.navigationController pushViewController:vc animated:YES];
    XLAlertView *alert = [[XLAlertView alloc] initWithTitle:@"" message:@"确定人才没有来面试吗?" sureBtn:@"未面试" cancleBtn:@"取消"];
    alert.tag = 1003;
    alert.delegate = self;
    [alert showXLAlertView];
}

#pragma mark ========不合适========
- (void)closeClick:(NSIndexPath *)path entity:(CompanyHomeEntity *)entity
{
//    currentPath = path;
//    YQWeakSelf;
//    KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:@[@"不合适"]  actionBlock:^(NSInteger buttonIndex) {
//        if (buttonIndex != -1) {
//            [weakSelf deleteRow];
//        }
//    }];
//    [actionSheet show];
}


- (void)deleteRow
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    [item.tableViewArray removeObjectAtIndex:currentPath.row];
    if (item.tableViewArray.count == 0) { // 要根据情况直接删除section或者仅仅删除row
        [item.tableView deleteSections:[NSIndexSet indexSetWithIndex:currentPath.section] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [item.tableView deleteRowsAtIndexPaths:@[currentPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark ========邀请面试========
- (void)invitationPersonal:(NSIndexPath *)path entity:(CompanyHomeEntity *)entity
{
    currentPath = path;
    if ([entity.cdealwith isEqualToString:@"1"]) {
#pragma mark ========邀请========
        InvitationInterviewController *vc = [[InvitationInterviewController alloc] init];
        vc.entity = entity;
        [self.navigationController pushViewController:vc animated:YES];
        YQWeakSelf;
        vc.backBlock = ^(CompanyHomeEntity *entity) {
            [weakSelf tableRefresh];
        };
    }else if ([entity.cdealwith isEqualToString:@"3"]) {
#pragma mark ========已邀请========
        InterviewDetailController *vc = [[InterviewDetailController alloc] init];
        vc.orderid = entity.orderid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)commentClick:(NSIndexPath *)path entity:(CompanyHomeEntity *)entity
{
    currentPath = path;
    if (curTableIndex == 2){
        if ([entity.cdealwith isEqualToString:@"5"]){
#pragma mark ========已通过========
            XLAlertView *alert = [[XLAlertView alloc] initWithTitle:@"" message:@"是否已经入职?" sureBtn:@"已入职" cancleBtn:@"未入职"];
            alert.tag = 1001;
            alert.delegate = self;
            [alert showXLAlertView];
        }else if ([entity.cdealwith isEqualToString:@"4"]){
#pragma mark ========不合适 没有操作========
        }else{
            XLAlertView *alert = [[XLAlertView alloc] initWithTitle:@"" message:@"是否通过面试?" sureBtn:@"已通过" cancleBtn:@"未通过"];
            alert.tag = 1000;
            alert.delegate = self;
            [alert showXLAlertView];
        }
    }else if (curTableIndex == 3){
        if ([entity.cdealwith isEqualToString:@"6"]){
            XLAlertView *alert = [[XLAlertView alloc] initWithTitle:@"" message:@"是否已经转正?" sureBtn:@"已转正" cancleBtn:@"未转正"];
            alert.tag = 1002;
            alert.delegate = self;
            [alert showXLAlertView];
        }
    }else if (curTableIndex == 4){
#pragma mark ========已离职操作========
        if ([entity.cdealwith isEqualToString:@"7"]){
            XLAlertView *alert = [[XLAlertView alloc] initWithTitle:@"" message:@"确定人才已离职?" sureBtn:@"已离职" cancleBtn:@"取消"];
            alert.tag = 1004;
            alert.delegate = self;
            [alert showXLAlertView];
        }
    }
}
- (void)alertView:(XLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //self.redPacket = @"0";
    // 4、已面试不合适；5、已面试待入职（已面试合适）；6、已入职待转正；7、已转正；8、已离职
    if (alertView.tag == 1000) {
        // 是否通过
        if (buttonIndex == 1) {
            //self.redPacket = @"2";
            // 未通过
            [self changeResumeStatus:@"4"];
        }else if (buttonIndex == 2) {
            //self.redPacket = @"2";
            // 通过
            [self changeResumeStatus:@"5"];
        }
    }else if (alertView.tag == 1001) {
        // 是否入职
        if (buttonIndex == 1) {
            // 未入职
            [self changeResumeStatus:@"4"];
        }else if (buttonIndex == 2) {
            // 入职
            [self changeResumeStatus:@"6"];
        }
    }else if (alertView.tag == 1002) {
        // 是否转正
        if (buttonIndex == 1) {
            // 未转正
            [self changeResumeStatus:@"8"];
        }else if (buttonIndex == 2) {
            // 转正
            [self changeResumeStatus:@"7"];
        }
    }else if (alertView.tag == 1003) {
        // 是否来面试
        if (buttonIndex == 2) {
            // 未面试
            //self.redPacket = @"1";
            [self changeResumeStatus:@"10"];
        }
    }else if (alertView.tag == 1004) {
        // 是否已离职
        if (buttonIndex == 2) {
            [self changeResumeStatus:@"8"];
        }
    }
}

- (void)changeResumeStatus:(NSString *)state // success:(void(^)())success
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    CompanyHomeEntity *entity = [item.tableViewArray objectAtIndex:currentPath.row];
    
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] changeResumeState_uid:[UserEntity getUid] mid:entity.itemId orderid:entity.orderid dealwith:state redpacket:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            entity.cdealwith = state;
            if ([state isEqualToString:@"4"] || [state isEqualToString:@"5"]) {
                [item.tableView reloadData];
            }else{
                [self deleteRow];
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)tableRefresh
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    [item.tableView reloadData];
}
- (void)refreshTable:(NSString *)pname
{
    self.pName = pname;
    if ([pname isEqualToString:@"全部"]) {
        self.pName = @"";
    }
    
    // 重置刷新标识
    for (YQGroupTableItem *item in self.tableGroups) {
        item.refreshFlag = YES;
    }
    
    UIButton *button = self.navigationItem.rightBarButtonItem.customView;
    [button setTitle:pname forState:UIControlStateNormal];
    
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    [item.tableView.mj_header beginRefreshing];
}
#pragma mark - 网络请求

- (void)reqOrderList:(NSString *)page
{
#pragma mark ========0-人才简历;1-已面试;2-已入职;3-已转正;4-已离职========
    NSString *dealwithStr = @"1";
    if (curTableIndex > 0) {
        if (curTableIndex == 1) {
            dealwithStr = @"3";
        }else{
            dealwithStr = [NSString stringWithFormat:@"%li",curTableIndex+3];
        }
    }
#pragma mark ========dealwith(1表示人才简历；3、待面试；5、已面试；6、已入职；7、已转正；8、已离职)========
    [[RequestManager sharedRequestManager] getResumeRecommendList_uid:[UserEntity getUid] type:nil pclassid:self.pName dealwith:dealwithStr page:page pagesize:KPageSize success:^(id resultDic) {
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
            CompanyHomeEntity *en = [CompanyHomeEntity CompanyHomeEntityWithDict:dic];
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



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
