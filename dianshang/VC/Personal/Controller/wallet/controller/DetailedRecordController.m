//
//  DetailedRecordController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DetailedRecordController.h"

#import "YQPayDetailFilterView.h"
#import "DetailedRecordCell.h"
#import "DetailRecordEntity.h"
@interface DetailedRecordController ()
{
    int pageCount;//分页数
    
    NSInteger filterIndex;
}

@property (nonatomic, strong) YQPayDetailFilterView *filterView;
@end

@implementation DetailedRecordController

- (YQPayDetailFilterView *)filterView
{
    if (_filterView == nil) {
        YQPayDetailFilterView *filterView = [[YQPayDetailFilterView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
        YQWeakSelf;
        [filterView buttonPress:^(NSInteger index, BOOL isReset) {
            weakSelf.fd_interactivePopDisabled = NO;
            UIButton *sender = (UIButton *)weakSelf.navigationItem.rightBarButtonItem.customView;
            [sender setTitle:@"筛选" forState:UIControlStateNormal];
            if (isReset) {
                [weakSelf setFilterIndex:index];
            }
        }];
        [self.view addSubview:filterView];
        _filterView = filterView;
    }
    return _filterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收支明细";
    
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"筛选" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    
    [self initView];
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}

#pragma mark - table

- (void)headerRereshing
{
    pageCount = 1;
    [self requestRecordList:[NSString stringWithFormat:@"%d",pageCount]];
}

- (void)footerRereshing
{
    pageCount++;
    [self requestRecordList:[NSString stringWithFormat:@"%d",pageCount]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    tableView.mj_footer.hidden = self.tableArr.count == 0;
//    self.isShowNoMoreData = self.tableArr.count == 0;
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib1 = [UINib nibWithNibName:@"DetailedRecordCell" bundle:nil];
    [tableView registerNib:nib1 forCellReuseIdentifier:@"DetailedRecordCell"];
    DetailedRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailedRecordCell"];
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 事件

- (void)rightClick:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"筛选"]) {
        [sender setTitle:@"收起" forState:UIControlStateNormal];
        [self.filterView showAnimate];
        self.fd_interactivePopDisabled = YES;
    }else{
        [sender setTitle:@"筛选" forState:UIControlStateNormal];
        [self.filterView hideAnimate];
        self.fd_interactivePopDisabled = NO;
    }
}
- (void)setFilterIndex:(NSInteger)index
{
    filterIndex = index;
    //[self requestNetwork:_startTF.text andEndStr:_endTF.text];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 网络访问回调

- (void)requestRecordList:(NSString *)page
{
    [self endRereshingCustom];
    //NSString *type = [NSString stringWithFormat:@"%d",(int)filterIndex];
    
    [[RequestManager sharedRequestManager] withdrawalsList_uid:[UserEntity getUid] type:@"1" page:page pagesize:KPageSize success:^(id resultDic) {
        
        [self endRereshingCustom];
        if ([resultDic[CODE] isEqualToString:SUCCESS]){
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            NSArray *array = resultDic[DATA];
            for (NSDictionary *dic in array) {
                DetailRecordEntity *en = [DetailRecordEntity entityWithDict:dic];
                [tempArr addObject:en];
            }
            if (self.isPullDown) {
                self.tableArr = tempArr;
            }else {
                [self.tableArr addObjectsFromArray:tempArr];
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
