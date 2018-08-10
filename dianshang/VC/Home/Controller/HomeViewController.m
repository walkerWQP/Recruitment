//
//  HomeViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/10/13.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define kButtonNormalColor RGBA(255, 255, 255, 0.7)

#import "HomeViewController.h"
#import "HomePositionDetailVC.h"
#import "SearchViewController.h"
#import "JobIntentionController.h"
#import "MessageViewController.h"
#import "YQNavigationController.h"
#import "StickViewController.h"

#import "YQDowndropView.h"
#import "HomeJobCell.h"
#import "HomeJobEntity.h"
#import "YQNotDismissAlertView.h"

#import "YQSaveManage.h"
#import "RMExpectindustryEntity.h"
#import "SelectCityController.h"
#import "JobIntentionController.h"

#import "EZCPersonCenterEntity.h"

@interface HomeViewController ()<UIAlertViewDelegate>
{
    NSString *appUrl;
}

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) YQDowndropView *downdropView;
@property (nonatomic, strong) NSMutableArray *hopworkList;
@property (nonatomic, strong) UILabel        *addLabel;
@property (nonatomic, strong) UIView         *titleView;
@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UIButton       *perviousBtn;

@property (nonatomic, strong) UIButton *toastBtn;//E按钮
// 重置数据标识(切换筛选条件或者求职意向是置为YES 重置数据)
@property (nonatomic, assign) BOOL resetFlag;
// 筛选条件
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, strong) NSString *cityStr;
@property (nonatomic, strong) NSString *araeStr;
@property (nonatomic, strong) NSString *scaleStr;// 团队规模
@property (nonatomic, strong) NSString *cveditStr;// 融资规模
@property (nonatomic, strong) NSString *tradeidStr;// 行业
@property (nonatomic, strong) NSString *eduStr;// 学历
@property (nonatomic, strong) NSString *exprienceStr;// 经验
@property (nonatomic, strong) NSString *payStr;// 薪资
@property (nonatomic, strong) NSString *costStr;// 顾问费
@property (nonatomic, strong) NSString *pnameStr;// 期望职位名称

@property (nonatomic, strong) UIView   *hintView;
// 刷新页面标识
@property (nonatomic, assign) BOOL isRefreshFlag;

@end

@implementation HomeViewController

- (NSMutableArray *)hopworkList {
    if (!_hopworkList) {
        _hopworkList = [NSMutableArray array];
    }
    return _hopworkList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isRecommend = YES;//默认推荐
    self.scaleStr = @"0";//全部
    self.cveditStr = @"0";//全部
    self.tradeidStr = @"0";//全部
    self.eduStr = @"0";//全部
    self.exprienceStr = @"0";//不限
    self.payStr = @"0";//不限
    self.isRefreshFlag = NO;
    
    [self reqHopwork];
    [self reqHoptrade];
    [self reqVersion];
    
#pragma mark ========获取行业保存到本地========
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"HomeRefresh" object:nil];
    
#pragma mark ========注册一个消息通知========
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotity:) name:myMessage object:nil];
    /*
    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_CONCURRENT); dispatch_async(queue, ^{ // 追加任务1
        [self.hud show:YES];
        for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            [self reqHopwork];
            
        } });dispatch_async(queue, ^{ // 追加任务2
            for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                [self reqHoptrade];
                
            } });dispatch_async(queue, ^{ // 追加任务3
                for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                    [self reqVersion];
                    
                } }); dispatch_barrier_async(queue, ^{ // 追加任务4
                    for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                        // 获取行业保存到本地
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"HomeRefresh" object:nil];
                        
                        // 注册一个消息通知
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotity:) name:myMessage object:nil];
                        
                        [self.hud hide:YES];
                        
                    } });
    
    [self.tableView reloadData];
 */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    //    self.hopworkList = [NSMutableArray array];
    
//    [self reqHopwork];
   
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"HomeRefresh" object:nil];
//
//    [self reqVersion];
//    // 注册一个消息通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotity:) name:myMessage object:nil];
//
//    // 获取行业保存到本地
//    [self reqHoptrade];
    
    
    
    
}

#pragma mark ========E按钮页面布局========
- (void)invitationView
{
    if (self.toastBtn == nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        button.center = CGPointMake(APP_WIDTH-35, APP_HEIGHT-APP_BottomH-APP_TABH-50-APP_NAVH);
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"E" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:35];
        button.layer.cornerRadius = button.yq_height * 0.5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(invitationClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        self.toastBtn = button;
    } else {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        button.center = CGPointMake(APP_WIDTH-35, APP_HEIGHT-APP_BottomH-APP_TABH-50-APP_NAVH);
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"E" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:35];
        button.layer.cornerRadius = button.yq_height * 0.5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(invitationClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        self.toastBtn = button;
    }
}

#pragma mark ========E按钮点击事件========
- (void)invitationClick:(UIButton *)sender
{
    StickViewController *vc = [[StickViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ========注册通知相应事件========
- (void)messageNotity:(NSNotification *)notification
{
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:messageVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)notify:(NSNotification *)notify
{
    self.isRefreshFlag = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isRefreshFlag) {
        self.isRefreshFlag = NO;
        [self reqHopwork];
    }
}

#pragma mark ========求职意向UI========
- (void)initJobIndustryView:(UIView *)titleView
{
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH-110, titleView.yq_height)];
    scrollView.backgroundColor = [UIColor clearColor];
    //scrollView.contentSize = CGSizeMake(self.HopworkList.count*APP_WIDTH, scrollView.yq_height);
    //scrollView.layer.masksToBounds = YES;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    //scrollView.scrollEnabled = NO;
    [titleView addSubview:scrollView];
    self.scrollView = scrollView;
    
    //CGFloat buttonW = titleView.yq_width/self.HopworkList.count;
    CGFloat buttonH = titleView.yq_height;
    
    CGFloat maxRigth = 0;
    
    for (int i = 0; i < self.hopworkList.count; i++) {
        RMJobIntentionEntity *item = [self.hopworkList objectAtIndex:i];
        
        CGFloat buttonX = maxRigth;
        CGFloat buttonY = 0;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, 0, 0)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:item.name forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:kButtonNormalColor forState:UIControlStateNormal];
        [scrollView addSubview:button];
        [button sizeToFit];
        button.yq_width += 10;
        button.yq_height = buttonH;
        
        maxRigth += button.yq_width+2;
        
        if (i == 0) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.perviousBtn = button;
        }
    }
    scrollView.contentSize = CGSizeMake(maxRigth, scrollView.yq_height);
}

#pragma mark ========搜索和添加页面布局========
- (void)initTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 44)];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
    
    NSArray *titleArr = @[@"home_add",@"home_search2"];
    int count = (int)titleArr.count;
    
    int btnW = 50;
    int btnH = titleView.yq_height;
    int btnX = titleView.yq_width-btnW*count-10;
    
    for (int i = 0; i < count; i++)
    {
        //NSLog(@"%d",(int)titleArr.count);
        //YQHeadViewItem *item = titleArr[i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX+btnW*i, 0, btnW, btnH)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        
        [btn setImage:[UIImage imageNamed:titleArr[i]] forState:UIControlStateNormal];
        
        if (i != count-1) {
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x+btnW, 15/2, 0.5, btnH-15)];
            lineview.backgroundColor = [UIColor whiteColor];
            [titleView addSubview:lineview];
        }
    }
}

#pragma mark ========遮挡视图（无数据时显示）========
- (void)initHintView
{
    if (self.titleView) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.text = @"人才";
        [label sizeToFit];
        self.navigationItem.titleView = label;
        [self.titleView removeFromSuperview];
        self.titleView = nil;
    }
//    if (self.downdropView) {
//        [self.downdropView removeFromSuperview];
//        self.downdropView = nil;
//    }
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        //        if (self.tableView.mj_header) {
        //            [self.tableView.mj_header removeFromSuperview];
        //        }
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    [self.view addSubview:view];
    self.hintView = view;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
    button.center = CGPointMake(APP_WIDTH*0.5, (APP_HEIGHT-APP_NAVH)*0.5);
    [button setTitle:@"添加求职意向" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = THEMECOLOR;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.tag = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(releaseClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}

#pragma mark ========页面布局========
- (void)initView
{
    self.tableView.yq_y = 45;
    self.tableView.yq_height = APP_HEIGHT-APP_NAVH-APP_TABH-45;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //[self tableview:self.tableView toView:self.view toY:45];
    
    UINib *nib1 = [UINib nibWithNibName:@"HomeJobCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"HomeJobCell"];
    // 设置下啦刷新
    [self setupRefresh];
    
    UIButton *footButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    footButton.backgroundColor = THEMECOLOR;
    [footButton setTitle:@"切换城市" forState:UIControlStateNormal];
    [footButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 初始化YQDowndropView数据
    NSMutableArray *headItemArr = [NSMutableArray array];
    
    NSMutableArray *mTempArr = [NSMutableArray array];
    NSArray *tempArr = @[@"推荐",@"最新"];
    for (int j = 0; j < tempArr.count; j++) {
        YQSingleTableViewItem *singleItem = [[YQSingleTableViewItem alloc] init];
        singleItem.isSelect = j==0;
        singleItem.text = tempArr[j];
        [mTempArr addObject:singleItem];
        
    }
    YQDowndropItem *headItem0 = [[YQDowndropItem alloc] init];
    headItem0.title = [NSString stringWithFormat:@""];
    headItem0.type = YQDowndropItemTypeSingleTableView;
    headItem0.singleListArray = mTempArr;
    [headItemArr addObject:headItem0];
    
    
    NSMutableArray *cityListArr = [[NSMutableArray alloc] init];
    // 设置城市列表
    if (self.downdropView == nil) {
        //        self.downdropView = [[YQDowndropView alloc] init];
        RMJobIntentionEntity *en = self.hopworkList.firstObject;
        // 根据意向城市设置城市列表
        NSString *cityStr = en.city;
        [cityListArr addObjectsFromArray:[EZPublicList getAreaListWith:cityStr]];
        [cityListArr insertObject:en.city atIndex:0];
        
        mTempArr = [NSMutableArray array];
        for (int j = 0; j < cityListArr.count; j++) {
            YQSingleTableViewItem *singleItem = [[YQSingleTableViewItem alloc] init];
            singleItem.isSelect = j==0;
            singleItem.text = cityListArr[j];
            [mTempArr addObject:singleItem];
        }
        YQDowndropItem *headItem1 = [[YQDowndropItem alloc] init];
        headItem1.title = [NSString stringWithFormat:@"城市"];
        headItem1.type = YQDowndropItemTypeSingleTableView;
        headItem1.footView = footButton;
        headItem1.singleListArray = mTempArr;
        [headItemArr addObject:headItem1];
        
        
        YQDowndropItem *headItem2 = [[YQDowndropItem alloc] init];
        headItem2.title = [NSString stringWithFormat:@"公司"];
        headItem2.type = YQDowndropItemTypeCollectionView;
        headItem2.collectionArray = [NSMutableArray array];
        [headItemArr addObject:headItem2];
        NSArray *listArr = @[[EZPublicList getFinancingList],[EZPublicList getScopeList],[self tradeList]];
        NSArray *titleArr = @[@"融资规模",@"团队规模",@"行业"];
        for (int i = 0; i < titleArr.count; i++){
            YQDDCollectionItem *item = [[YQDDCollectionItem alloc] init];
            item.isMultiselect = NO;// 单选
            item.collectionText = titleArr[i];
            NSArray *tempArr = listArr[i];
            mTempArr = [NSMutableArray array];
            for (int j = 0; j < tempArr.count; j++) {
                YQSingleTableViewItem *singleItem = [[YQSingleTableViewItem alloc] init];
                singleItem.isSelect = j==0;
                singleItem.itemId = [NSString stringWithFormat:@"%d",j];
                singleItem.text = tempArr[j];
                [mTempArr addObject:singleItem];
            }
            item.collectionList = mTempArr;
            [headItem2.collectionArray addObject:item];
        }
        
        
        YQDowndropItem *headItem3 = [[YQDowndropItem alloc] init];
        headItem3.title = [NSString stringWithFormat:@"要求"];
        headItem3.type = YQDowndropItemTypeCollectionView;
        headItem3.collectionArray = [NSMutableArray array];
        [headItemArr addObject:headItem3];
        //        listArr = @[[EZPublicList getEducationList],[EZPublicList getExperienceList],[EZPublicList getSalaryList],[EZPublicList getCostList]];
        //        titleArr = @[@"最低学历",@"经验",@"薪资",@"顾问费"];
        listArr = @[[EZPublicList getEducationList],[EZPublicList getExperienceList],[EZPublicList getSalaryList]];
        titleArr = @[@"最低学历",@"经验",@"薪资"];
        for (int i = 0; i < titleArr.count; i++){
            YQDDCollectionItem *item = [[YQDDCollectionItem alloc] init];
            if ([titleArr[i] isEqualToString:@"薪资"]) {
                item.isMultiselect = NO;//单选
            }else{
                item.isMultiselect = NO;
            }
            item.collectionText = titleArr[i];
            NSArray *tempArr = listArr[i];
            mTempArr = [NSMutableArray array];
            for (int j = 0; j < tempArr.count; j++) {
                YQSingleTableViewItem *singleItem = [[YQSingleTableViewItem alloc] init];
                singleItem.isSelect = j==0;
                singleItem.itemId = [NSString stringWithFormat:@"%d",j];
                singleItem.text = tempArr[j];
                [mTempArr addObject:singleItem];
            }
            item.collectionList = mTempArr;
            [headItem3.collectionArray addObject:item];
        }
        
#pragma mark ========创建YQDowndropView========
        YQDowndropView *view = [[YQDowndropView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 45)];
        view.item = headItemArr;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        self.downdropView = view;
        
#pragma mark ========回调刷新列表数据========
        YQWeakSelf;
        view.refreshTableList = ^(NSArray *array,NSInteger index) {
            [weakSelf refreshTable:array index:index];
        };
        
    }
}

#pragma mark ========处理筛选条件并刷新列表========
- (void)refreshTable:(NSArray *)array index:(NSInteger)index
{
    YQSingleTableViewItem *singleItem = array.firstObject;
    if (index == 0) {
        // 如果之前选择的和现在选择的一致就不刷新列表
        BOOL re = [singleItem.text isEqualToString:@"推荐"];
        if (!(re && self.isRecommend)) {
            self.isRecommend = re;
            self.resetFlag = YES;
            [self.tableView.mj_header beginRefreshing];
        }
    }else if (index == 1){
        if ([singleItem.text isEqualToString:self.cityStr]) {
            self.araeStr = @"";
        }else{
            self.araeStr = singleItem.text;
        }
        self.resetFlag = YES;
        [self.tableView.mj_header beginRefreshing];
    }else if (index == 2){
        YQSingleTableViewItem *cveditItem = array[0];
        self.cveditStr = cveditItem.itemId;
        YQSingleTableViewItem *scaleItem = array[1];
        self.scaleStr = scaleItem.itemId;
        YQSingleTableViewItem *tradeItem = array[2];
        self.tradeidStr = tradeItem.itemId;
        
        self.resetFlag = YES;
        [self.tableView.mj_header beginRefreshing];
    }else if (index == 3){
        YQSingleTableViewItem *eduItem = array[0];
        self.eduStr = eduItem.itemId;
        YQSingleTableViewItem *exprienceItem = array[1];
        self.exprienceStr = exprienceItem.itemId;
        YQSingleTableViewItem *payItem = array[2];
        self.payStr = [EZPublicList getSalaryConvert:payItem.itemId];
        //        YQSingleTableViewItem *costItem = array[3];
        //        self.costStr = costItem.text;
        
        self.resetFlag = YES;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)dealloc
{
    [_downdropView removeSubView];
}


#pragma mark ========tableview刷新事件========
- (void)headerRereshing
{
    self.pageIndex = 1;
    [self reqPostionList:[NSString stringWithFormat:@"%li",self.pageIndex]];
}

- (void)footerRereshing
{
    self.pageIndex++;
    [self reqPostionList:[NSString stringWithFormat:@"%li",self.pageIndex]];
}


#pragma mark ========tableView delegagte========
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeJobCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeJobCell"];
    HomeJobEntity *en = self.tableArr[indexPath.row];
    cell.entity = en;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeJobEntity *en = self.tableArr[indexPath.row];
    
    HomePositionDetailVC *vc = [[HomePositionDetailVC alloc] init];
    vc.jobEntity = en;
    vc.isHome = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ========添加求职意向点击事件========
- (void)releaseClick:(UIButton *)sender
{
    JobIntentionController *vc = [[JobIntentionController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ========头部导航栏下方按钮点击事件========
- (void)btnClick:(UIButton *)sender
{
    // 收起downdropView子视图
    [self.downdropView closeAllSubView];
    if (sender.tag == 1) {
        // 添加
        JobIntentionController *vc = [[JobIntentionController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.hopworkList = self.hopworkList;
        YQWeakSelf;
        vc.jobIntentionBlock = ^{
            // 刷新求职意向UI
            [weakSelf initJobIndustryView:weakSelf.titleView];
            // 需要刷新求职意向
            RMJobIntentionEntity *entity = [weakSelf.hopworkList objectAtIndex:0];
            // 意向城市
            NSString *cityStr = entity.city;
            // 根据意向职位列表
            [weakSelf refreshJobList:cityStr];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 2){
        // 搜索
        SearchViewController *vc = [[SearchViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ========求职意向点击========
- (void)buttonClick:(UIButton *)sender
{
    if (sender == self.perviousBtn) {
        return;
    }
    // 收起downdropView子视图
    [self.downdropView closeAllSubView];
    // 设置按钮样式
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.perviousBtn setTitleColor:kButtonNormalColor forState:UIControlStateNormal];
    self.perviousBtn = sender;
    
    // 刷新职位列表
    // 需要刷新求职意向
    RMJobIntentionEntity *entity = [self.hopworkList objectAtIndex:sender.tag];
    // 意向城市
    NSString *cityStr = entity.city;
    [self refreshJobList:cityStr];
    
    self.cityStr = cityStr;
    self.araeStr = @"";
    self.pnameStr = entity.position_classid;
    self.resetFlag = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ========刷新downdropView UI========
- (void)refreshJobList:(NSString *)cityStr;
{
    NSMutableArray *array = self.downdropView.item;
    YQDowndropItem *item = [array objectAtIndex:1];
    // 获取城市列表
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[EZPublicList getAreaListWith:cityStr]];
    [tempArr insertObject:cityStr atIndex:0];
    if (tempArr.count != 0) {
        if (item.type == YQDowndropItemTypeSingleTableView) {
            NSMutableArray *mTempArr = [NSMutableArray array];
            for (int j = 0; j < tempArr.count; j++) {
                YQSingleTableViewItem *singleItem = [[YQSingleTableViewItem alloc] init];
                singleItem.isSelect = j==0;
                singleItem.text = tempArr[j];
                [mTempArr addObject:singleItem];
            }
            item.singleListArray = mTempArr;
            [self.downdropView downdropViewRefreshUI:item index:1];
        }
    }
}

#pragma mark ========切换城市点击事件========
- (void)footButtonClick:(UIButton *)sender
{
    //CLog(@"切换城市");
    SelectCityController *vc = [[SelectCityController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    YQWeakSelf;
    vc.selectcity = ^(NSDictionary *dict) {
        NSString *cityStr = [dict objectForKey:@"city"];
        [weakSelf refreshJobList:cityStr];
        weakSelf.cityStr = cityStr;
    };
    // 收起downdropView子视图
    [self.downdropView closeAllSubView];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark ========获取职位列表数据========
- (void)reqPostionList:(NSString *)page
{
    NSString *recommend = self.isRecommend ? @"1" : @"2";
    
    [[RequestManager sharedRequestManager] homeGetPositionList_uid:[UserEntity getUid] page:page pagesize:KPageSize recommend:recommend city:self.cityStr area:self.araeStr scale:self.scaleStr cvedit:self.cveditStr tradeid:self.tradeidStr edu:self.eduStr exprience:self.exprienceStr pay:self.payStr pname:@"" name:self.pnameStr success:^(id resultDic) {
        [self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            
            if (self.isPullDown) {
                self.tableArr = [NSMutableArray array];
            }
            if (self.resetFlag) {
                self.resetFlag = NO;
                [self.tableArr removeAllObjects];
                [self.tableView reloadData];
            }
            for (NSDictionary *dict in list) {
                HomeJobEntity *en = [HomeJobEntity HomeJobEntityWithDict:dict];
                [self.tableArr addObject:en];
            }
            
            [self.tableView reloadData];
            
            if (list.count < [KPageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else if ([resultDic[CODE] isEqualToString:@"100003"]){
            if (self.resetFlag) {
                [self.tableArr removeAllObjects];
                [self.tableView reloadData];
            }
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark ========获取期望职位数据========
- (void)reqHopwork
{
    [self.hud show:YES];
    
    [[RequestManager sharedRequestManager] gethopwork_uid:[UserEntity getUid] success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            NSString *state = resultDic[@"restatus"];
            // 保存到本地
            [UserEntity setJobStatus:state];
            
            self.hopworkList = [NSMutableArray array];
            
            for (NSDictionary *dict in resultDic[DATA]) {
                RMJobIntentionEntity *en = [RMJobIntentionEntity JobIntentionEntity:dict];
                [self.hopworkList addObject:en];
            }
            
            if (self.hopworkList.count == 0) {
                // 遮挡视图
                [self initHintView];
            }else{
                if (self.hintView) {
                    [self.hintView removeFromSuperview];
                }
                [self initTitleView]; // 搜索和管理职位意向
                [self initView];  //首页上边按钮view
                [self initJobIndustryView:self.titleView];
                RMJobIntentionEntity *en = [self.hopworkList objectAtIndex:0];
                // 设置筛选条件
                self.pnameStr = en.position_classid;// 职位名
                self.cityStr = en.city;
                self.araeStr = @"";
                
            }
            // 添加E(推荐)按钮
            [self invitationView];
            
        }else if ([resultDic[CODE] isEqualToString:@"100003"]) {
            [self.hopworkList removeAllObjects];
            // 遮挡视图
            [self initHintView];
            // 添加E(推荐)按钮
            [self invitationView];
            
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

static NSString * extracted() {
    return SUCCESS;
}

#pragma mark ========判断版本更新========
- (void)reqVersion
{
    [[RequestManager sharedRequestManager] getNewVersion:@"" success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:extracted()]) {
            NSDictionary *info = resultDic[DATA];
            
            id curVersion = info[@"ios_version"];
            if ([curVersion isKindOfClass:[NSNumber class]]) {
                curVersion = [NSString stringWithFormat:@"%@",curVersion];
            }
            NSString *oldVersion = [YQSaveManage objectForKey:LVersion];
            // oldVersion = curVersion 就需要更新
            if (![curVersion isEqualToString:oldVersion] && oldVersion.length) {
                // oldVersion > curVersion 就不需要更新
                if ([curVersion compare:oldVersion options:NSNumericSearch] ==NSOrderedDescending)
                {
                    //CLog(@"%@ is bigger",curVersion);
                    YQNotDismissAlertView *versionAlert = [[YQNotDismissAlertView alloc] initWithTitle:@"版本信息" message:@"app有新版本上线了,马上更新" delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
                    versionAlert.tag = 1000;
                    versionAlert.notDisMiss = YES;
                    [versionAlert show];
                }else{
                    //CLog(@"%@ is bigger",oldVersion);
                }
                
            }
            appUrl = info[@"ios_url"];
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            if (appUrl.length) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://%@",appUrl]]];
            }
        }
    }
}

#pragma mark ========把行业保存到本地========
- (void)reqHoptrade
{
    [[RequestManager sharedRequestManager] getExpectIndustry_uid:nil success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSMutableArray *tempArr = [NSMutableArray array];
            [tempArr addObject:@"全部"];
            for (NSDictionary *dict in resultDic[DATA]) {
                [tempArr addObject:dict[@"tname"]];
            }
            [YQSaveManage setObject:tempArr forKey:@"TradeList"];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (NSArray *)tradeList
{
    NSArray *array = [YQSaveManage objectForKey:@"TradeList"];
    if (array == nil || array.count == 0) {
        return [EZPublicList getTradeList];
    }
    return array;
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

