//
//  CompanyHomeController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//


#define kButtonNormalColor RGBA(255, 255, 255, 0.7)

#import "CompanyHomeController.h"
#import "CompanyPersonalDetailVC.h"
#import "CompanySearchController.h"
#import "CPositionMangerController.h"
#import "CReleasePositionController.h"
#import "YQNotDismissAlertView.h"
#import "EZCPersonCenterController.h"
#import "MessageViewController.h"
#import "YQNavigationController.h"

#import "YQSaveManage.h"
#import "YQDowndropView.h"
#import "CompanyHomeCell.h"
#import "CompanyHomeEntity.h"

#import "CPositionMangerEntity.h"
#import "SelectCityController.h"

@interface CompanyHomeController ()<UIAlertViewDelegate>
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

// 重置数据标识(切换筛选条件或者求职意向是置为YES 重置数据)
@property (nonatomic, assign) BOOL resetFlag;
// 筛选条件
@property (nonatomic, assign) BOOL isRecommend;
//@property (nonatomic, strong) NSString *cityStr;
//@property (nonatomic, strong) NSString *araeStr;
//@property (nonatomic, strong) NSString *scaleStr;// 团队规模
//@property (nonatomic, strong) NSString *cveditStr;// 融资规模
//@property (nonatomic, strong) NSString *tradeidStr;// 行业
@property (nonatomic, strong) NSString *eduStr;// 学历
@property (nonatomic, strong) NSString *exprienceStr;// 经验
@property (nonatomic, strong) NSString *payStr;// 薪资
@property (nonatomic, strong) NSString *restatusStr;// 求职状态

@property (nonatomic, strong) NSString *pnameStr;// 职位名称

@property (nonatomic, strong) UIView   *hintView;
// 刷新页面标识
@property (nonatomic, assign) BOOL isRefreshFlag;
@end

@implementation CompanyHomeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isRecommend = YES;//默认推荐
    self.eduStr = @"0";//全部
    self.restatusStr = @"0";//全部
    self.exprienceStr = @"0";//不限
    self.payStr = @"0";//不限
    self.navigationItem.title = @"人才";
    self.hopworkList = [NSMutableArray array];
    
    [self reqHopwork];
    self.isRefreshFlag = NO;
    [self reqVersion];
    // 获取行业保存到本地
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"companyHomeRefresh" object:nil];
    // 注册一个消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotity:) name:myMessage object:nil];
    /*
    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_CONCURRENT); dispatch_async(queue, ^{ // 追加任务1
        [self.hud show:YES];
        for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            [self reqHopwork];
            self.isRefreshFlag = NO;
            
        } });dispatch_async(queue, ^{ // 追加任务3
                for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                    [self reqVersion];
                    
                } }); dispatch_barrier_async(queue, ^{ // 追加任务4
                    for (int i = 0; i < 2; ++i) { [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                        // 获取行业保存到本地
                         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"companyHomeRefresh" object:nil];
                        
                        // 注册一个消息通知
                       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotity:) name:myMessage object:nil];
                        
                        [self.hud hide:YES];
                        
                    } });
    
    [self.tableView reloadData];
     */
}


- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    self.isRecommend = YES;//默认推荐
    //    self.scaleStr = @"0";//全部
    //    self.cveditStr = @"0";//全部
    //    self.tradeidStr = @"0";//全部
    self.eduStr = @"0";//全部
    self.restatusStr = @"0";//全部
    self.exprienceStr = @"0";//不限
    self.payStr = @"0";//不限
    
    self.navigationItem.title = @"人才";
    
    self.hopworkList = [NSMutableArray array];
    
    [self reqHopwork];
    self.isRefreshFlag = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"companyHomeRefresh" object:nil];
    
    [self reqVersion];
    
    // 注册一个消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotity:) name:myMessage object:nil];
     */
}

#pragma mark ========注册一个消息通知相应事件========
- (void)messageNotity:(NSNotification *)notification
{
    MessageViewController  *messageVC = [[MessageViewController alloc] init];
    YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:messageVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isRefreshFlag) {
        self.isRefreshFlag = NO;
        [self reqHopwork];
    }
}

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
    //scrollView.pagingEnabled = YES;
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
        CPositionMangerEntity *item = [self.hopworkList objectAtIndex:i];
        
        CGFloat buttonX = maxRigth;
        CGFloat buttonY = 0;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, 0, 0)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:item.pname forState:UIControlStateNormal];
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

#pragma mark ========导航栏下边按钮布局========
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
    if (self.downdropView) {
        [self.downdropView removeFromSuperview];
        self.downdropView = nil;
    }
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        //        if (self.tableView.mj_header) {
        //            [self.tableView.mj_header removeFromSuperview];
        //        }
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    [self.view addSubview:view];
    self.hintView = view;
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    button.center = CGPointMake(APP_WIDTH*0.5, (APP_HEIGHT-APP_NAVH)*0.5);
    [button setTitle:@"发布职位" forState:UIControlStateNormal];
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
    
    UINib *nib1 = [UINib nibWithNibName:@"CompanyHomeCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"CompanyHomeCell"];
    // 设置下啦刷新
    [self setupRefresh];
    
    // 初始化YQDowndropView数据
    NSMutableArray *headItemArr = [NSMutableArray array];
    
    NSMutableArray *mTempArr = [NSMutableArray array];
    NSArray *tempArr = @[@"最新",@"急速求职"];
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
    
    
    if (self.downdropView == nil) {
        
        YQDowndropItem *headItem3 = [[YQDowndropItem alloc] init];
        headItem3.title = [NSString stringWithFormat:@"要求"];
        headItem3.type = YQDowndropItemTypeCollectionView;
        headItem3.collectionArray = [NSMutableArray array];
        [headItemArr addObject:headItem3];
        NSArray *listArr = @[[EZPublicList getEducationList],[EZPublicList getExperienceList],[EZPublicList getSalaryList],[EZPublicList getJobIntentionStateList]];
        NSArray *titleArr = @[@"最低学历",@"经验要求",@"薪资要求",@"求职状态"];
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
        
        // 创建YQDowndropView
        YQDowndropView *view = [[YQDowndropView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 45)];
        view.item = headItemArr;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        self.downdropView = view;
        
        
        // 回调刷新列表数据
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
        BOOL re = [singleItem.text isEqualToString:@"最新"];
        if (!(re && self.isRecommend)) {
            self.isRecommend = re;
            self.resetFlag = YES;
            [self.tableView.mj_header beginRefreshing];
        }
    } else if (index == 1){
        YQSingleTableViewItem *eduItem = array[0];
        self.eduStr = eduItem.itemId;
        YQSingleTableViewItem *exprienceItem = array[1];
        self.exprienceStr = exprienceItem.itemId;
        YQSingleTableViewItem *payItem = array[2];
        self.payStr = [EZPublicList getSalaryConvert:payItem.itemId];
        YQSingleTableViewItem *restatusItem = array[3];
        self.restatusStr = restatusItem.itemId;
        self.resetFlag = YES;
        [self.tableView.mj_header beginRefreshing];
        
    }
    //    else if (index == 2){
    //        YQSingleTableViewItem *cveditItem = array[0];
    //        self.cveditStr = cveditItem.itemId;
    //        YQSingleTableViewItem *scaleItem = array[1];
    //        self.scaleStr = scaleItem.itemId;
    //        YQSingleTableViewItem *tradeItem = array[2];
    //        self.tradeidStr = tradeItem.itemId;
    //
    //        self.resetFlag = YES;
    //        [self.tableView.mj_header beginRefreshing];
    //    }else if (index == 3){
    //        YQSingleTableViewItem *eduItem = array[0];
    //        self.eduStr = eduItem.itemId;
    //        YQSingleTableViewItem *exprienceItem = array[1];
    //        self.exprienceStr = exprienceItem.itemId;
    //        YQSingleTableViewItem *payItem = array[2];
    //        self.payStr = [EZPublicList getSalaryConvert:payItem.itemId];
    //
    //        self.resetFlag = YES;
    //        [self.tableView.mj_header beginRefreshing];
    //    }
}

- (void)dealloc
{
    [_downdropView removeSubView];
}

#pragma mark - tableview

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
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
    CompanyHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyHomeCell"];
    CompanyHomeEntity *en = self.tableArr[indexPath.row];
    
    if ([en.isfast isEqualToString:@"1"]) {
        cell.rapidImageView.hidden = YES;
        cell.rapidLabel.hidden     = YES;
    } else {
        cell.rapidImageView.hidden = NO;
        cell.rapidLabel.hidden     = NO;
    }
    cell.entity = en;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CompanyHomeEntity *en = self.tableArr[indexPath.row];
    
    CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
    vc.entity = en;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ========发布职位点击事件========
- (void)releaseClick:(UIButton *)sender
{
    NSInteger flag = 0;
    NSInteger auth = [[UserEntity getRealAuth] integerValue];
    if (auth == 1) {
        flag = 1;
    }else if (auth == 2 || auth == 0){
        //去认证
        [self goAuth];
    }else if (auth == 3){
        // 等待审核
        [self waitExamine];
    }
    
    if (flag == 1) {
        CReleasePositionController *vc = [[CReleasePositionController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark ========判断是否实名认证========
- (void)goAuth
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"您未实名认证,暂不能发布职位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
    alert.tag = 2000;
    [alert show];
}

- (void)waitExamine
{
    [YQToast yq_AlertText:@"您的资料正在审核中,请耐心等待"];
}

#pragma mark ========搜索和添加点击事件========
- (void)btnClick:(UIButton *)sender
{
    // 收起downdropView子视图
    [self.downdropView closeAllSubView];
    if (sender.tag == 1) {
        // 添加
        CPositionMangerController *vc = [[CPositionMangerController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 2){
        // 搜索
        CompanySearchController *vc = [[CompanySearchController alloc] init];
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
    CPositionMangerEntity *entity = [self.hopworkList objectAtIndex:sender.tag];
    // 意向城市
    //NSString *cityStr = entity.city;
    //[self refreshJobList:cityStr];
    
    //    self.cityStr = cityStr;
    //    self.araeStr = @"";
    self.pnameStr = entity.position_class_name;
    self.resetFlag = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ========首页人才列表========
- (void)reqPostionList:(NSString *)page
{
    NSString *recommend = self.isRecommend ? @"1" : @"2";
    
    [[RequestManager sharedRequestManager] getCPersonnelList_uid:[UserEntity getUid] restatus:self.restatusStr recommend:recommend pname:self.pnameStr pay:self.payStr experience:self.exprienceStr edu:self.eduStr city:@"" pagesize:KPageSize page:page success:^(id resultDic) {
        [self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            
            //[EZPublicList printPropertyWithDict:list.firstObject];
            if (self.isPullDown) {
                self.tableArr = [NSMutableArray array];
            }
            if (self.resetFlag) {
                self.resetFlag = NO;
                [self.tableArr removeAllObjects];
                [self.tableView reloadData];
            }
            for (NSDictionary *dict in list) {
                CompanyHomeEntity *en = [CompanyHomeEntity CompanyHomeEntityWithDict:dict];
                [self.tableArr addObject:en];
            }
            
            [self.tableView reloadData];
            
            if (list.count < [KPageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else if ([resultDic[CODE] isEqualToString:@"100003"]){
            if (self.resetFlag) {
                if (self.isPullDown) {
                    [self.tableArr removeAllObjects];
                    [self.tableView reloadData];
                }
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark ========企业发布的职位列表========
- (void)reqHopwork
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getCPositionList_uid:[UserEntity getUid] success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            self.hopworkList = [NSMutableArray array];
            for (NSDictionary *dict in resultDic[DATA]) {
                CPositionMangerEntity *en = [CPositionMangerEntity CPositionEntityWithDict:dict];
                if ([en.issue isEqualToString:@"1"]) {
                    [self.hopworkList addObject:en];
                }
            }
            
            if (self.hopworkList.count == 0) {
                // 遮挡视图
                [self initHintView];
                
            }else{
                if (self.hintView) {
                    [self.hintView removeFromSuperview];
                }
                [self initTitleView];
                [self initView];
                [self initJobIndustryView:self.titleView];
                CPositionMangerEntity *en = [self.hopworkList objectAtIndex:0];
                //                // 设置筛选条件
                self.pnameStr = en.position_class_name;// 职位名
                //                self.cityStr = en.city;
                //                self.araeStr = @"";
            }
            
        }else if ([resultDic[CODE] isEqualToString:@"100003"]) {
            [self.hopworkList removeAllObjects];
            // 遮挡视图
            [self initHintView];
            //            [self initView];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark ========版本更新========
- (void)reqVersion
{
    [[RequestManager sharedRequestManager] getNewVersion:@"" success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSDictionary *info = resultDic[DATA];
            
            id curVersion = info[@"ios_version"];//2.0.7
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
    } else if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            if ([UserEntity getIsCompany]) {
                EZCPersonCenterController *vc = [[EZCPersonCenterController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)notify:(NSNotification *)notify
{
    self.isRefreshFlag = YES;
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

