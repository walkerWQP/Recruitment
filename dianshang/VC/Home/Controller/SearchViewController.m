//
//  SearchViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/21.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "SearchViewController.h"
#import "SelectCityController.h"
#import "HomePositionDetailVC.h"
#import "YQCityLocation.h"

#import "HomeJobEntity.h"
#import "HomeJobCell.h"
#import "YQDowndropItem.h"
#import "YQDowndropView.h"

#import "YQSearchView.h"
#import "YZTagList.h"

#import "YQSaveManage.h"

@interface SearchViewController ()<YQCityLocationDelegate>

@property (nonatomic, strong) YQCityLocation *cityLocation;

@property (nonatomic, strong) YQSearchView *searchView;
@property (nonatomic, strong) UITableView *recordTable;
@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) YQDowndropView *downdropView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSString *cityStr;
// 重置数据标识(切换筛选条件或者求职意向是置为YES 重置数据)
@property (nonatomic, assign) BOOL resetFlag;
@property (nonatomic, strong) NSString *scaleStr;// 团队规模
@property (nonatomic, strong) NSString *cveditStr;// 融资规模
@property (nonatomic, strong) NSString *tradeidStr;// 行业
@property (nonatomic, strong) NSString *eduStr;// 学历
@property (nonatomic, strong) NSString *exprienceStr;// 经验
@property (nonatomic, strong) NSString *payStr;// 薪资
@property (nonatomic, strong) NSString *pnameStr;// 期望职位名称

@property (nonatomic, strong) UILabel *promptLabel;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark ========在YQNavigationController中隐藏返回按钮========
    [self.navigationItem setHidesBackButton:YES];
    self.fd_interactivePopDisabled = YES;
    [self initSearchView];
    
    [self setupData];

    [self recordTableView];
    
    [self searchResultView];
    
#pragma mark ========开启定位 监听 cityName========
    YQCityLocation *city = [[YQCityLocation alloc] init];
    [city startLocation];
    city.delegate = self;
    self.cityLocation = city;
}
- (void)recordTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.tableHeaderView = [self tagListView];
    tableView.tag = 100;
    self.recordTable = tableView;
}
- (void)setupData
{
    NSArray *array = [self historyRecord];
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *str in array) {
        PersonItem *item = [PersonItem setCellItemImage:@"home_search" title:str];
        [items addObject:item];
    }
    if (items.count > 0) {
        YQGroupCellItem *item = [YQGroupCellItem setGroupItems:items headerTitle:@"   最近搜索" footerTitle:@"清空历史搜索"];
        [self.groups addObject:item];
    }
}
- (void)initSearchView
{
    YQSearchView *searchView = [[YQSearchView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 44)];
    self.cityStr = @"郑州";
    [searchView initSearchView:@[@"郑州"] placeholder:@"输入职位名" searchTitle:@"取消" keyboardType:UIKeyboardTypeDefault];
    
    YQWeakSelf;
    searchView.searchViewCancel = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    searchView.query = ^(NSString *searchStr, NSInteger type) {
        [weakSelf searchView:searchStr];
    };
    searchView.searchViewCity = ^{
        [weakSelf switchCity];
    };
    searchView.beginEdit = ^(UITextField *textField) {
        weakSelf.resetFlag = YES;
        weakSelf.resultView.hidden = YES;
    };
    self.navigationItem.titleView = searchView;
    
    self.searchView = searchView;
}

- (UIView *)tagListView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 0)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, APP_WIDTH, 30)];
    label.text = @"热门搜索";
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    NSArray *tags = @[@"PHP",@"java",@"iOS",@"android",@"Python"];
#pragma mark ========创建标签列表========
    YZTagList *tagList = [[YZTagList alloc] init];
    [view addSubview:tagList];
#pragma mark ========高度可以设置为0，会自动跟随标题计算========
    tagList.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height - 64);
#pragma mark ========设置标签背景色========
    tagList.tagBackgroundColor = [UIColor clearColor];
    tagList.borderColor = RGB(180, 180, 180);
    tagList.borderWidth = .5f;
#pragma mark ========设置标签颜色========
    tagList.tagColor = RGB(102, 102, 102);
#pragma mark ========这里一定先设置标签列表属性，然后最后去添加标签========
    [tagList addTags:tags];
    
    view.yq_height = tagList.yq_bottom+8;
    YQWeakSelf;
    tagList.clickTagBlock = ^(NSString *tag) {
        [weakSelf searchView:tag];
    };
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 100) {
        return self.groups.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        return group.items.count;
    }else{
        return self.tableArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        return 45;
    }else{
        return 175;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        YQTableViewCell *cell = [YQTableViewCell cellWithTableView:tableView tableViewCellStyle:self.cellStyle];
        
        YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
        YQCellItem *item = [group.items objectAtIndex:indexPath.row];
        
        cell.item = item;
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == group.items.count-1) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        return cell;
    }else{
        HomeJobCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeJobCell"];
        HomeJobEntity *en = self.tableArr[indexPath.row];
        cell.entity = en;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 100) {
        [self.searchView.textfield resignFirstResponder];
        
        YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
        YQCellItem *item = [group.items objectAtIndex:indexPath.row];
        
        [self searchView:item.title];
        
    }else{
#pragma mark ========跳转到对应页面========
        HomeJobEntity *en = self.tableArr[indexPath.row];
        
        HomePositionDetailVC *vc = [[HomePositionDetailVC alloc] init];
        vc.jobEntity = en;
        vc.isHome = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        if (self.groups.count > 0) {
            YQGroupCellItem *group = [self.groups objectAtIndex:section];
            return group.headerTitle;
        }
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        if (self.groups.count > 0) {
            YQGroupCellItem *group = [self.groups objectAtIndex:section];
            return group.footerTitle;
        }
    }
    return @"";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        if (self.groups.count > 0) {
            YQGroupCellItem *group = [self.groups objectAtIndex:section];
            if (![group.headerTitle isEqualToString:@""] && group.headerTitle != nil) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, APP_WIDTH, 30)];
                label.text = group.headerTitle;
                label.textColor = RGB(51, 51, 51);
                label.font = [UIFont systemFontOfSize:15];
                return label;
            }
        }
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        if (self.groups.count > 0) {
            YQGroupCellItem *group = [self.groups objectAtIndex:section];
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
            button.tag = section;
            [button addTarget:self action:@selector(fotterClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
            [button setTitle:group.footerTitle forState:UIControlStateNormal];
            
            [view addSubview:button];
            return view;
        }
    }
    return nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchView.textfield resignFirstResponder];
}

- (void)searchView:(NSString *)searchStr
{
    if ([searchStr isEqualToString:@""]) {
        return;
    }
    [self.searchView.textfield resignFirstResponder];
    self.searchView.textfield.text = searchStr;
    
    if (self.groups.count == 0) {
        NSMutableArray *array = [NSMutableArray array];
        PersonItem *item0 = [PersonItem setCellItemImage:@"home_search" title:searchStr];
        [array addObject:item0];
        YQGroupCellItem *item = [YQGroupCellItem setGroupItems:array headerTitle:@"   最近搜索" footerTitle:@"清空历史搜索"];
        [self.groups addObject:item];
        [self.recordTable reloadData];
#pragma mark ========保存到本地========
        [self saveHistoryRecord:searchStr];
    }else{
#pragma mark ========保存到最近搜索========
        YQGroupCellItem *group = [self.groups objectAtIndex:0];
        NSMutableArray *array = [NSMutableArray arrayWithArray:group.items];
        int flag = 0;
        for (PersonItem *item in array) {
            if ([item.title isEqualToString:searchStr]) {
                flag = 1;
                break;
            }
        }
        if (flag == 0) {
            PersonItem *item = [PersonItem setCellItemImage:@"home_search" title:searchStr];
            [array insertObject:item atIndex:0];
            group.items = array;
            [self.recordTable reloadData];
#pragma mark ========保存到本地========
            [self saveHistoryRecord:searchStr];
        }
    }
    self.pnameStr = searchStr;
#pragma mark ========搜索========
    self.pageIndex = 1;
    self.resetFlag = YES;
    [self reqSearchResult:[NSString stringWithFormat:@"%li",self.pageIndex]];
}

- (void)switchCity
{
    SelectCityController *vc = [[SelectCityController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    YQWeakSelf;
    vc.selectcity = ^(NSDictionary *dict) {
        NSString *cityStr = [dict objectForKey:@"city"];
        weakSelf.searchView.cityStr = cityStr;
        weakSelf.cityStr = cityStr;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)fotterClick:(UIButton *)sender
{
    [self deleteHistoryRecord];
    [self.groups removeAllObjects];
    [self.recordTable reloadData];
}

#pragma mark - 搜索结果

- (void)reqSearchResult:(NSString *)page
{
    NSString *recommend = @"1";
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] homeGetPositionList_uid:[UserEntity getUid] page:page pagesize:KPageSize recommend:recommend city:self.cityStr area:@"" scale:self.scaleStr cvedit:self.cveditStr tradeid:self.tradeidStr edu:self.eduStr exprience:self.exprienceStr pay:self.payStr pname:self.pnameStr name:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        [self endRereshingCustom];
        self.resultView.hidden = NO;
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
            //self.promptLabel.hidden = self.tableArr.count != 0;
            [self.tableView reloadData];
            
            if (list.count < [KPageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else if ([resultDic[CODE] isEqualToString:@"100003"]){
            if (self.resetFlag) {
                [self.tableArr removeAllObjects];
                [self.tableView reloadData];
            }
            //self.promptLabel.hidden = self.tableArr.count != 0;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)searchResultView
{
    self.scaleStr = @"0";//全部
    self.cveditStr = @"0";//全部
    self.tradeidStr = @"0";//全部
    self.eduStr = @"0";//全部
    self.exprienceStr = @"0";//不限
    self.payStr = @"0";//不限
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    bgview.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:bgview];
    self.resultView = bgview;
    self.resultView.hidden = YES;
    
#pragma mark ========初始化YQDowndropView数据========
    NSMutableArray *headItemArr = [NSMutableArray array];
    
    YQDowndropItem *headItem2 = [[YQDowndropItem alloc] init];
    headItem2.title = [NSString stringWithFormat:@"公司"];
    headItem2.type = YQDowndropItemTypeCollectionView;
    headItem2.collectionArray = [NSMutableArray array];
    [headItemArr addObject:headItem2];
    NSArray *listArr = @[[EZPublicList getFinancingList],[EZPublicList getScopeList],[EZPublicList getTradeList]];
    NSArray *titleArr = @[@"融资规模",@"团队规模",@"行业"];
    for (int i = 0; i < titleArr.count; i++){
        YQDDCollectionItem *item = [[YQDDCollectionItem alloc] init];
        item.isMultiselect = NO;// 单选
        item.collectionText = titleArr[i];
        NSArray *tempArr = listArr[i];
        NSMutableArray *mTempArr = [NSMutableArray array];
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
        NSMutableArray *mTempArr = [NSMutableArray array];
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
    [bgview addSubview:view];
    self.downdropView = view;
    
#pragma mark ========回调刷新列表数据========
    YQWeakSelf;
    view.refreshTableList = ^(NSArray *array,NSInteger index) {
        
        [weakSelf refreshTable:array index:index];
        
    };
    
    [bgview addSubview:self.tableView];
    self.tableView.yq_y = view.yq_bottom;
    self.tableView.yq_height -= view.yq_height;
    
    UINib *nib1 = [UINib nibWithNibName:@"HomeJobCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"HomeJobCell"];
    
    //__weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isPullDown = YES;
        [weakSelf headerRereshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isPullDown = NO;
        [weakSelf footerRereshing];
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:bgview.bounds];
    label.text = @"没有相关职位";
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = RGB(239, 239, 239);
    label.textAlignment = NSTextAlignmentCenter;
    self.promptLabel = label;
    label.hidden = YES;
    [bgview addSubview:label];
}

- (void)headerRereshing
{
    self.pageIndex = 1;
    [self reqSearchResult:[NSString stringWithFormat:@"%li",self.pageIndex]];
}

- (void)footerRereshing
{
    self.pageIndex++;
    [self reqSearchResult:[NSString stringWithFormat:@"%li",self.pageIndex]];
}

#pragma mark ========处理筛选条件并刷新列表========
- (void)refreshTable:(NSArray *)array index:(NSInteger)index
{
    //YQSingleTableViewItem *singleItem = array.firstObject;
    if (index == 0){
        YQSingleTableViewItem *cveditItem = array[0];
        self.cveditStr = cveditItem.itemId;
        YQSingleTableViewItem *scaleItem = array[1];
        self.scaleStr = scaleItem.itemId;
        YQSingleTableViewItem *tradeItem = array[2];
        self.tradeidStr = tradeItem.itemId;
        
        self.resetFlag = YES;
        [self.tableView.mj_header beginRefreshing];
    }else if (index == 1){
        YQSingleTableViewItem *eduItem = array[0];
        self.eduStr = eduItem.itemId;
        YQSingleTableViewItem *exprienceItem = array[1];
        self.exprienceStr = exprienceItem.itemId;
        YQSingleTableViewItem *payItem = array[2];
        self.payStr = [EZPublicList getSalaryConvert:payItem.itemId];
        
        self.resetFlag = YES;
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 历史记录

- (NSArray *)historyRecord
{
    NSArray *array = [YQSaveManage objectForKey:LHistoryRecord];
    if (array == nil) {
        array = [NSArray array];
    }
    return array;
}

- (void)saveHistoryRecord:(NSString *)str
{
    NSArray *array = [YQSaveManage objectForKey:LHistoryRecord];
    if (array == nil) {
        array = [NSArray array];
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    [arr insertObject:str atIndex:0];
    [YQSaveManage setObject:arr forKey:LHistoryRecord];
}
- (void)deleteHistoryRecord
{
    NSArray *array = [YQSaveManage objectForKey:LHistoryRecord];
    if (array == nil) {
        array = [NSArray array];
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    [arr removeAllObjects];
    [YQSaveManage setObject:arr forKey:LHistoryRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定位

- (void)yq_locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            self.cityStr = [city hasSuffix:@"市"] ? [city substringToIndex:city.length-1] : city;
            
            self.searchView.cityStr = self.cityStr;
        }
        else if (error == nil && [array count] == 0)
        {
            CLog(@"No results were returned.");
            //self.cityName = @"error";
        }
        else if (error != nil)
        {
            CLog(@"An error occurred = %@", error);
            //self.cityName = @"error";
        }
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
