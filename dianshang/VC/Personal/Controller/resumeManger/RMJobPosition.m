//
//  RMJobPosition.m
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RMJobPosition.h"
#import "RMExpectindustryEntity.h"

@interface RMJobPosition ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *previousTableViewIndexPath;
    NSIndexPath *previousOneTableIndexPath;
}
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *tablesView;
@property (nonatomic, strong) UITableView *subOneTable;
@property (nonatomic, strong) UITableView *subTwoTable;
@property (nonatomic, strong) NSMutableArray *subOneTableArray;
@property (nonatomic, strong) NSMutableArray *subTwoTableArray;
@end

@implementation RMJobPosition

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择职位类型";
    self.tableArray = [NSMutableArray array];
    self.subOneTableArray = [NSMutableArray array];
    self.subTwoTableArray = [NSMutableArray array];
    
    [self reqJobPosition];
    
    [self initView];
}

- (void)initView
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableView = tableview;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableview];
    if (IOS_VERSION_11_OR_ABOVE) {
        tableview.estimatedRowHeight = 0;
        tableview.estimatedSectionHeaderHeight = 0;
        tableview.estimatedSectionFooterHeight = 0;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:tableview.bounds];
    bgView.hidden = YES;
    bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapClick:)];
    [bgView addGestureRecognizer:tap];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    UIView *tablesView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, APP_WIDTH-80, APP_HEIGHT-APP_NAVH)];
    tablesView.yq_x = APP_WIDTH;
    [self.view addSubview:tablesView];
    self.tablesView = tablesView;
    
    CGFloat w = tablesView.yq_width*0.5;
    
    UITableView *subOneTable =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, tablesView.yq_height)];
    subOneTable.delegate = self;
    subOneTable.dataSource = self;
    subOneTable.tag = 10;
    subOneTable.backgroundColor = RGB(250, 250, 250);
    subOneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [subOneTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"subOneTable"];
    [tablesView addSubview:subOneTable];
    self.subOneTable = subOneTable;
    if (IOS_VERSION_11_OR_ABOVE) {
        subOneTable.estimatedRowHeight = 0;
        subOneTable.estimatedSectionHeaderHeight = 0;
        subOneTable.estimatedSectionFooterHeight = 0;
    }
    
    UITableView *subTwoTable =  [[UITableView alloc] initWithFrame:CGRectMake(subOneTable.yq_right, 0, w, tablesView.yq_height)];
    subTwoTable.delegate = self;
    subTwoTable.dataSource = self;
    subTwoTable.tag = 20;
    subTwoTable.backgroundColor = RGB(237, 242, 242);
    subTwoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [subTwoTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"subTwoTable"];
    [tablesView addSubview:subTwoTable];
    self.subTwoTable = subTwoTable;
    if (IOS_VERSION_11_OR_ABOVE) {
        subTwoTable.estimatedRowHeight = 0;
        subTwoTable.estimatedSectionHeaderHeight = 0;
        subTwoTable.estimatedSectionFooterHeight = 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 10) {
        return _subOneTableArray.count;
    }else if (tableView.tag == 20){
        return _subTwoTableArray.count;
    }
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    RMJobPositionEntity *en = nil;
    if (tableView.tag == 10) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"subOneTable"];
        en = [self.subOneTableArray objectAtIndex:indexPath.row];
    }else if (tableView.tag == 20){
        cell = [tableView dequeueReusableCellWithIdentifier:@"subTwoTable"];
        en = [self.subTwoTableArray objectAtIndex:indexPath.row];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        en = [self.tableArray objectAtIndex:indexPath.row];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = en.name;
    cell.textLabel.textColor = en.isSelect ? THEMECOLOR : RGB(51, 51, 51);
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 10) {
        if (previousOneTableIndexPath != nil) {
            RMJobPositionEntity *oneEn = [self.subOneTableArray objectAtIndex:previousOneTableIndexPath.row];
            oneEn.isSelect = NO;
        }else{
            RMJobPositionEntity *oneEn = [self.subOneTableArray objectAtIndex:0];
            oneEn.isSelect = NO;
        }

        RMJobPositionEntity *oneEn = [self.subOneTableArray objectAtIndex:indexPath.row];
        oneEn.isSelect = YES;
        [self.subOneTable reloadData];
        previousOneTableIndexPath = indexPath;
        if (oneEn.child.count>0) {
            self.subTwoTableArray = oneEn.child;
            
            [self.subTwoTable reloadData];
        }
        
    }else if (tableView.tag == 20){
        // 执行回调
        if (self.JobPositionBlock) {
            RMJobPositionEntity *twoEn = [self.subTwoTableArray objectAtIndex:indexPath.row];
            self.JobPositionBlock(twoEn);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
    
        if (previousTableViewIndexPath != nil) {
            RMJobPositionEntity *en = [self.tableArray objectAtIndex:previousTableViewIndexPath.row];
            en.isSelect = NO;
        }
        RMJobPositionEntity *en = [self.tableArray objectAtIndex:indexPath.row];
        en.isSelect = YES;
        [self.tableView reloadData];
        previousTableViewIndexPath = indexPath;
        if (en.child.count>0) {
            self.subOneTableArray = en.child;
            RMJobPositionEntity *oneEn = [en.child objectAtIndex:0];
            self.subTwoTableArray = oneEn.child;
            
            // 首个置为YES其他全部置为NO
            for (RMJobPositionEntity *e in en.child) {
                e.isSelect = [e isEqual:[en.child firstObject]];
            }
            
            [self.subOneTable reloadData];
            [self.subTwoTable reloadData];
            
            self.bgView.hidden = NO;
            self.bgView.alpha = 0;
            [UIView animateWithDuration:.3 animations:^{
                self.bgView.alpha = 0.5;
                
                self.tablesView.yq_x = 80;
            }];
        }
    }
}





- (void)bgViewTapClick:(UIGestureRecognizer *)sender
{
    [UIView animateWithDuration:.3 animations:^{
        self.bgView.alpha = 0.0;
        self.tablesView.yq_x = APP_WIDTH;
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
    }];
}


- (void)reqJobPosition
{
    [[RequestManager sharedRequestManager] getJobPosition_uid:nil success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            for (NSDictionary *dict in resultDic[DATA]) {
                
                RMJobPositionEntity *en = [RMJobPositionEntity JobPositionEntity:dict];
                en.isSelect = NO;
//                for (RMExpectindustryEntity *item in self.expectArray) {
//                    if ([item.uid isEqualToString:en.uid]) {
//                        en.isSelect = YES;
//                        break;
//                    }
//                }
                
                [self.tableArray addObject:en];
            }
            
            [self.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

//-(void)dealloc
//{
//    NSLog(@"%@",NSStringFromClass([self class]));
//}

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
