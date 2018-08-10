//
//  RMAddEditJobIntention.m
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RMAddEditJobIntention.h"
#import "RMExpectindustry.h"
#import "RMJobPosition.h"
#import "YQCityListView.h"
#import "RMSalarySelectView.h"

#import "RMExpectindustryEntity.h"

@interface RMAddEditJobIntention ()
{
    NSIndexPath *currentIndexPath;
}
// 期望职位
@property (nonatomic, strong) RMJobPositionEntity *jobPositionEntity;

// 期望行业标签
@property (nonatomic, strong) NSArray *expectArray;
// 选择城市
@property (nonatomic, strong) NSString *cityStr;
// 选择薪资
@property (nonatomic, strong) NSString *salaryStr;

/// 选择城市视图
@property (nonatomic, strong) YQCityListView *cityView;
/// 选择薪资视图
@property (nonatomic, strong) RMSalarySelectView *salarySelectView;

/// 求职状态
@property (nonatomic, strong) NSString *restatus;
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation RMAddEditJobIntention

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.entity != nil) {
        self.navigationItem.title = @"编辑期望职位";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"保存" titleColor:[UIColor whiteColor] target:self action:@selector(saveClick:)];
        
        if (self.isDelBtn) {
            [self initDeleteView];
            self.tableView.yq_height -= (60+APP_BottomH);
        }
    }else{
        self.navigationItem.title = @"添加期望职位";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"确认添加" titleColor:[UIColor whiteColor] target:self action:@selector(addClick:)];
    }
    
    [self setUpdata];
    
    [self.view addSubview:self.tableView];
}

- (void)initDeleteView
{
    NSArray *array = @[@"删除"];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT-APP_NAVH-APP_BottomH-60, APP_WIDTH, 60)];
    bottomView.backgroundColor = RGB(243, 243, 243);
    
    CGFloat jianju = 10;
    CGFloat w = (APP_WIDTH - jianju*(array.count+1))/array.count;
    CGFloat h = 35;
    CGFloat y = (40-35)*0.5+10;
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(jianju*(i+1)+i*w, y, w, h)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [bottomView addSubview:button];
        [button addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setButton1:button];
    }
    [self.view addSubview:bottomView];
}

- (void)setButton1:(UIButton *)sender
{
    sender.backgroundColor = THEMECOLOR;
    sender.layer.cornerRadius = 3;
    sender.layer.masksToBounds = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:BTNBACKGROUND forState:UIControlStateHighlighted];
}

- (void)setUpdata
{
    
    if (self.typeStr == nil) {
        NSMutableArray *Arr = [[NSMutableArray alloc] init];
        //    [Arr removeAllObjects];
        YQCellItem *item0 = [YQCellItem setCellItemImage:nil title:@"期望职位"];
        item0.subTitle = @"";
        [Arr addObject:item0];
        YQCellItem *item1 = [YQCellItem setCellItemImage:nil title:@"期望行业"];
        item1.subTitle = @"不限";
        [Arr addObject:item1];
        YQCellItem *item2 = [YQCellItem setCellItemImage:nil title:@"工作城市"];
        item2.subTitle = @"郑州";
        [Arr addObject:item2];
        YQCellItem *item3 = [YQCellItem setCellItemImage:nil title:@"薪资要求"];
        item3.subTitle = @"";
        [Arr addObject:item3];
        YQCellItem *item4 = [YQCellItem setCellItemImage:nil title:@"极速求职"];
        item4.subTitle = @"关闭";
        [Arr addObject:item4];
        
        YQGroupCellItem *group = [YQGroupCellItem setGroupItems:Arr headerTitle:nil footerTitle:nil];
        [self.groups removeAllObjects];
        [self.groups addObject:group];
        
        
        if (self.entity != nil) {
            
            item0.subTitle = self.entity.name;
            item2.subTitle = self.entity.city;
            item1.subTitle = self.entity.tradename;
            
            NSString *salary = @"";
            if ([self.entity.low_salary isEqualToString:@"0"]) {
                salary = @"面议";
            }else{
                salary = [NSString stringWithFormat:@"%@-%@k",self.entity.low_salary,self.entity.top_salary];
            }
            item3.subTitle = salary;
            self.salaryStr = salary;
            
            
            if ([self.entity.isfast isEqualToString:@"1"] && self.restatus == nil) {
                item4.subTitle = @"关闭";
                self.restatus  = @"1";
            } else if ([self.entity.isfast isEqualToString:@"2"] || [self.restatus isEqualToString:@"2"]) {
                item4.subTitle = @"开启";
                self.restatus  = @"2";
            }
            // 设置选择职位
            RMJobPositionEntity *en = [[RMJobPositionEntity alloc] init];
            en.name = self.entity.name;
            en.uid = self.entity.position_classid;
            
            self.jobPositionEntity = en;
            // 设置期望行业
            NSMutableArray *temp = [NSMutableArray array];
            NSArray *tempstr = [self.entity.tradename componentsSeparatedByString:@","];
            NSArray *tempid = [self.entity.tradeid componentsSeparatedByString:@","];
            int i = 0;
            for (NSString *str in tempstr) {
                RMExpectindustryEntity *en = [[RMExpectindustryEntity alloc] init];
                en.tname = str;
                en.uid = tempid[i++];
                [temp addObject:en];
            }
            self.expectArray = temp;
        }
        
        self.cityStr = item2.subTitle;
    } else {
        
        NSMutableArray *Arr = [[NSMutableArray alloc] init];
        YQCellItem *item0 = [YQCellItem setCellItemImage:nil title:@"期望职位"];
        item0.subTitle = self.jobPositionEntity.name;
        [Arr addObject:item0];
        
        YQCellItem *item1 = [YQCellItem setCellItemImage:nil title:@"期望行业"];
        
        if (self.expectArray.count > 0) {
            item1.subTitle = [NSString stringWithFormat:@"%li个标签",self.expectArray.count];
            [Arr addObject:item1];
        } else {
            item1.subTitle = @"不限";
            [Arr addObject:item1];
        }
        
        
        YQCellItem *item2 = [YQCellItem setCellItemImage:nil title:@"工作城市"];
        
        if (self.cityStr == nil) {
            item2.subTitle = @"郑州";
            [Arr addObject:item2];
        } else {
            item2.subTitle = self.cityStr;
            [Arr addObject:item2];
        }
        
        
        YQCellItem *item3 = [YQCellItem setCellItemImage:nil title:@"薪资要求"];
        if (self.salaryStr == nil) {
            item3.subTitle = @"";
            [Arr addObject:item3];
        } else {
            item3.subTitle = self.salaryStr;
            [Arr addObject:item3];
        }
        
        
        YQCellItem *item4 = [YQCellItem setCellItemImage:nil title:@"极速求职"];
        
        if ([self.restatus isEqualToString:@"1"]) {
            item4.subTitle = @"关闭";
            [Arr addObject:item4];
        } else if ([self.restatus isEqualToString:@"2"]) {
            item4.subTitle = @"开启";
            [Arr addObject:item4];
        }
        
        YQGroupCellItem *group = [YQGroupCellItem setGroupItems:Arr headerTitle:nil footerTitle:nil];
        [self.groups removeAllObjects];
        [self.groups addObject:group];
        
    }
    
    
}
#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndexPath = indexPath;
    if (indexPath.row == 1) {
        RMExpectindustry *vc = [[RMExpectindustry alloc] init];
        vc.expectArray = self.expectArray;
        // 根据数据刷新
        YQWeakSelf;
        vc.expectIndustryBlock = ^(NSArray *array) {
            [weakSelf refreshTable:array];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 0){
        RMJobPosition *vc = [[RMJobPosition alloc] init];
        //vc.j = self.expectArray;
        // 根据数据刷新
        YQWeakSelf;
        vc.JobPositionBlock = ^(RMJobPositionEntity *entity) {
            [weakSelf jobRefreshTable:entity];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        [self.cityView showAnimate];
    }else if (indexPath.row == 3){
        [self.salarySelectView showAnimate];
    } else if (indexPath.row == 4) {
        CLog(@"点击急速求职");
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"联系方式" message:@"急速求职：急速求职：是求职者的一种求职紧迫度状态，作为企业查找求职者时的一种标识，系统默认为关闭状态。该项为求职者增值服务，目前为免费开通，开通后您的简历搜索排名将靠前，企业亦可直接获取您的联系电话，用于高效沟通。我们会根据求职效果数据分析，后续作付费开通，但已开通极速求职的，不再收费。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.typeStr = @"1";
            self.restatus = @"2";
            [self setUpdata];
            [self.tableView reloadData];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.typeStr = @"1";
            self.restatus = @"1";
            [self setUpdata];
            [self.tableView reloadData];
        }];
        
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

#pragma mark - 事件处理
- (void)deleteClick:(UIButton *)sender
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] deletehopwork_uid:self.entity.uid success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"删除成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addEditBlock) {
                self.addEditBlock(NO, self.entity);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeRefresh" object:nil userInfo:nil];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)saveClick:(UIButton *)sender
{
    NSString *tradeStr = @"";
    if (self.expectArray.count > 0) {
        for (RMExpectindustryEntity *en in self.expectArray) {
            tradeStr = [tradeStr stringByAppendingString:en.uid];
            if (![en isEqual:[self.expectArray lastObject]]) {
                tradeStr = [tradeStr stringByAppendingString:@","];
            }
        }
    }else{
        //tradeStr = @"不限";
        tradeStr = @"0";
    }
    
    // 薪资
    NSString *selary = [self.salaryStr stringByReplacingOccurrencesOfString:@"k" withString:@""];
    
    NSLog(@"2     %@",self.entity.workID);
    NSLog(@"是否开启急速求职     %@",self.restatus);
    
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] addHopwork_uid:@"" workId:self.entity.workID positionClassid:self.jobPositionEntity.uid genre:@"" city:self.cityStr trade:tradeStr salary:selary explanation:@"" isfast:self.restatus success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addEditBlock) {
                self.addEditBlock(NO, self.entity);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeRefresh" object:nil userInfo:nil];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)addClick:(UIButton *)sender
{
    NSString *tradeStr = @"";
    if (self.expectArray.count > 0) {
        for (RMExpectindustryEntity *en in self.expectArray) {
            tradeStr = [tradeStr stringByAppendingString:en.uid];
            if (![en isEqual:[self.expectArray lastObject]]) {
                tradeStr = [tradeStr stringByAppendingString:@","];
            }
        }
    }else{
        //tradeStr = @"不限";
        tradeStr = @"0";
    }
    if (self.jobPositionEntity == nil) {
        [YQToast yq_ToastText:@"请选择期望职位" bottomOffset:100];
    }else if ([self.salaryStr isEqualToString:@""] || self.salaryStr == nil) {
        [YQToast yq_ToastText:@"请选择薪资要求" bottomOffset:100];
    }else{
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] addHopwork_uid:[UserEntity getUid] workId:@"" positionClassid:self.jobPositionEntity.uid genre:@"" city:self.cityStr trade:tradeStr salary:self.salaryStr explanation:@"" isfast:self.restatus success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [YQToast yq_ToastText:@"添加成功" bottomOffset:100];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.addEditBlock) {
                    self.addEditBlock(YES, self.entity);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeRefresh" object:nil userInfo:nil];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}

// 选择职位刷新
- (void)jobRefreshTable:(RMJobPositionEntity *)entity
{
    YQGroupCellItem *items = [self.groups objectAtIndex:0];
    YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
    item.subTitle = entity.name;
    
    self.jobPositionEntity = entity;
    
    [self.tableView reloadData];
}
// 选择期望行业刷新
- (void)refreshTable:(NSArray *)array
{
    self.expectArray = array;
    YQGroupCellItem *items = [self.groups objectAtIndex:0];
    YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
    if (array.count > 0) {
        item.subTitle = [NSString stringWithFormat:@"%li个标签",array.count];
    }else{
        item.subTitle = @"不限";
    }
    
    [self.tableView reloadData];
}

// 城市view
- (YQCityListView *)cityView
{
    if (_cityView == nil) {
        YQCityListView *cityView = [[YQCityListView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
        YQGroupCellItem *items = [self.groups objectAtIndex:0];
        YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
        cityView.defultCityStr = item.subTitle;
//        if ([item.subTitle hasSuffix:@"县"]||[item.subTitle hasSuffix:@"区"]||[item.subTitle hasSuffix:@"州"]) {
//        }else{
//            cityView.defultCityStr = [item.subTitle stringByAppendingString:@"市"];
//        }
        YQWeakSelf;
        [cityView buttonPress:^(NSString *provStr, NSString *cityStr, NSString *areaStr) {
            CLog(@"%@->%@->%@",provStr,cityStr,areaStr);
            [weakSelf setSelectCity:cityStr];
            
        }];
        _cityView = cityView;
    }
    return _cityView;
}
// 选择城市刷新
- (void)setSelectCity:(NSString *)city
{
    YQGroupCellItem *items = [self.groups objectAtIndex:0];
    YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
    
    if ([city hasSuffix:@"市"]) {
        city = [city substringToIndex:city.length-1];
    }
    item.subTitle = city;
    self.cityStr = item.subTitle;
    [self.tableView reloadData];
}

// 薪资view
- (RMSalarySelectView *)salarySelectView
{
    if (_salarySelectView == nil) {
        RMSalarySelectView *cityView = [[RMSalarySelectView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
        YQGroupCellItem *items = [self.groups objectAtIndex:0];
        YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
        if (item.subTitle.length > 0) {            
            NSString *temp = [item.subTitle substringToIndex:item.subTitle.length-1];
            NSArray *array = [temp componentsSeparatedByString:@"k-"];
            [cityView setMinStr:array.firstObject MaxStr:array.lastObject];
        }
        
        YQWeakSelf;
        cityView.selectSalaryBlock = ^(NSString *minStr, NSString *maxStr) {
            [weakSelf setSalarySelect:minStr maxStr:maxStr];
        };
        _salarySelectView = cityView;
    }
    return _salarySelectView;
}
// 选择薪资刷新
- (void)setSalarySelect:(NSString *)minStr maxStr:(NSString *)maxStr
{
    YQGroupCellItem *items = [self.groups objectAtIndex:0];
    YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
    
    if ([minStr isEqualToString:@"面议"]) {
        item.subTitle = minStr;
        self.salaryStr = minStr;
    }else{
        item.subTitle = [NSString stringWithFormat:@"%@-%@k",minStr,maxStr];
        self.salaryStr = item.subTitle;
    }
    
    [self.tableView reloadData];
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
