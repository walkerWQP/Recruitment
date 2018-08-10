//
//  CDetailRecordController.m
//  dianshang
//
//  Created by yunjobs on 2018/1/4.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "CDetailRecordController.h"
#import "YQGroupTableItem.h"
#import "YQPageScrollView.h"
#import "DetailedRecordCell.h"
#import "DetailRecordEntity.h"

@interface CDetailRecordController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger curTableIndex;
    NSIndexPath *currentPath;
}
@property (nonatomic, strong) YQPageScrollView *scrollView;

@property (nonatomic, assign) BOOL isPullDown;

@property (nonatomic, strong) NSMutableArray *tableGroups;

//@property (nonatomic, strong) UIView *headView;
//@property (nonatomic, strong) UIView *headLineView;
/// 存放选中的对象
@property (nonatomic, strong) NSMutableArray *selectedObject;
/// 存放选中的indexPath对象
@property (nonatomic, strong) NSMutableArray *selIndexPath;

@end

@implementation CDetailRecordController

- (NSMutableArray *)tableGroups
{
    if (_tableGroups == nil) {
        _tableGroups = [NSMutableArray array];
        NSArray *titleArr = @[@"账单",@"E豆"];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selIndexPath = [NSMutableArray array];
    //设置导航栏
    [self setNav];
    // 添加表
    [self initView];
    
}
//设置导航栏
- (void)setNav
{
    NSMutableArray *titleArr = [NSMutableArray array];
    for (YQGroupTableItem *item in self.tableGroups) {
        [titleArr addObject:item.title];
    }
    if (titleArr.count > 1) {
        UISegmentedControl *segmentedC = [[UISegmentedControl alloc] initWithItems:titleArr];
        segmentedC.selectedSegmentIndex = 0;
        segmentedC.tintColor = [UIColor whiteColor];
        [segmentedC addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSForegroundColorAttributeName] = THEMECOLOR;
        [segmentedC setTitleTextAttributes:dic forState:UIControlStateSelected];
        self.navigationItem.titleView = segmentedC;
    }else{
        self.navigationItem.title = [titleArr lastObject];
    }
}

- (void)backButnClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView
{
    [self initScrollerView];
    
    //根据模型创建button和tableView
    for (int i = 0; i < self.tableGroups.count; i++) {
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:i];
        
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
        UINib *nib1 = [UINib nibWithNibName:@"DetailedRecordCell" bundle:nil];
        [myTable registerNib:nib1 forCellReuseIdentifier:@"DetailedRecordCell"];
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
            //默认刷新第一个表
            [myTable.mj_header beginRefreshing];
        }
        item.tableView = myTable;
    }
}

- (void)initScrollerView
{
    self.scrollView = [[YQPageScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH-APP_BottomH)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(self.tableGroups.count*APP_WIDTH, self.scrollView.yq_height-50);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
}
- (void)segmentChange:(UISegmentedControl *)sender
{
    curTableIndex = sender.selectedSegmentIndex;
    
    // 设置滑动的偏移量
    self.scrollView.contentOffset = CGPointMake(curTableIndex*APP_WIDTH, 0);
    
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    if (item.tableViewArray.count == 0) {
        //>0 就不主动刷新
        [item.tableView.mj_header beginRefreshing];
        // ==0 默认不选中
    }else{
        // 重新设置全选按钮状态
    }
    // 设置按钮标题
}

#pragma mark - scroller

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        //线条的跟随动画
        self.isShowNoMoreData = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        
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
    return 60;
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
    NSArray *array = item.tableViewArray;
    DetailRecordEntity *en = [array objectAtIndex:indexPath.row];
    
    DetailedRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailedRecordCell"];
    cell.tableIndex = curTableIndex;
    cell.entity = en;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    [self requestRecordList:[NSString stringWithFormat:@"%li",item.pageCount]];
}

- (void)footerRereshing
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    item.pageCount++;
    [self requestRecordList:[NSString stringWithFormat:@"%li",item.pageCount]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

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

- (void)requestRecordList:(NSString *)page
{
    NSString *type = [NSString stringWithFormat:@"%li",curTableIndex+1];
    
    [[RequestManager sharedRequestManager] withdrawalsList_uid:[UserEntity getUid] type:type page:page pagesize:KPageSize success:^(id resultDic) {
        
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
        
        [item.tableView.mj_header endRefreshing];
        [item.tableView.mj_footer endRefreshing];
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]){
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            NSArray *array = resultDic[DATA];
            for (NSDictionary *dic in array) {
                DetailRecordEntity *en = [DetailRecordEntity entityWithDict:dic];
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
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
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
