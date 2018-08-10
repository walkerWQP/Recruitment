//
//  SelectCityViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define HotCityKey @"热"
#define LocCityKey @"定"
#define kNOOPEN @"-11" //开通标识

#import "SelectCityController.h"

#import "YQCellItem.h"

#import "YQHotCityCell.h"
#import "YQCityLocation.h"
#import "BMChineseSort.h"

@interface SelectCityController ()<hotCellDelegate>

@property (nonatomic, strong) YQCityLocation *cityLocation;

@property (nonatomic, strong) NSMutableArray *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SelectCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市选择";
    
    // 开启定位 监听 cityName
    YQCityLocation *city = [[YQCityLocation alloc] init];
    [city startLocation];
    self.cityLocation = city;
    [city addObserver:self forKeyPath:@"cityName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    [self getCityData];
    
    //[self initSearchBar];
    
    [self initView];
}

- (void)initSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    //_searchBar.delegate = self;
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1];
    [self.view addSubview:_searchBar];
    
    //    [[_searchBar.subviews objectAtIndex:0]removeFromSuperview];
    
    for (UIView* subview in [[self.searchBar.subviews lastObject] subviews])
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField*)subview;
            textField.layer.cornerRadius = 15;
        }
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
    }
}

//初始化headView
- (void)initView
{
    self.tableView.yq_y = _searchBar.yq_bottom;
    //self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionIndexColor = [UIColor colorWithWhite:0.573 alpha:1.000];
    [self.view addSubview:self.tableView];
}


#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [_keys objectAtIndex:indexPath.section];
    //NSArray *citySection = [_cities objectForKey:key];
    if ([key isEqualToString:HotCityKey] || [key isEqualToString:LocCityKey]) {
        return (1 / 3 + 1) * 50+10;
    }else{
        return 45;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = RGB(239, 239, 239);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor colorWithWhite:0.949 alpha:0.000];
    titleLabel.textColor = [UIColor colorWithWhite:0.580 alpha:1.000];
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    //    NSArray *arr = [self.cities allKeys];
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:HotCityKey].location != NSNotFound) {
        titleLabel.text = @"热门城市";
    }
    else if ([key rangeOfString:LocCityKey].location != NSNotFound) {
        titleLabel.text = @"定位城市";
    }
    else{
        titleLabel.text = key;
    }
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_keys];
    return arr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [_keys objectAtIndex:section];
    //NSArray *citySection = [_cities objectForKey:key];
    if ([key isEqualToString:HotCityKey] || [key isEqualToString:LocCityKey]) {
        return 1;
    }else{
        NSArray *array = [self.cities objectAtIndex:section];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [_keys objectAtIndex:indexPath.section];
    if ([key isEqualToString:HotCityKey] || [key isEqualToString:LocCityKey]) {
        
        UINib *nib1 = [UINib nibWithNibName:@"YQHotCityCell" bundle:nil];
        [tableView registerNib:nib1 forCellReuseIdentifier:@"hotCell"];
        YQHotCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setHotCell:[_cities objectAtIndex:indexPath.section]];
        cell.delegate = self;
        cell.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
        }
        cell.backgroundColor = [UIColor whiteColor];
        NSDictionary *aaa = [[self.cities objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = [aaa objectForKey:@"city"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [_keys objectAtIndex:indexPath.section];
    if ([key isEqualToString:HotCityKey] || [key isEqualToString:LocCityKey]) {
        return;
    }
    NSDictionary *dict = [[self.cities objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.selectcity) {
        self.selectcity(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)hotCell:(YQHotCityCell *)hotCell didSelectCellAtCityDict:(NSDictionary *)dict
{
    if (self.selectcity) {
        self.selectcity(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)selectcity:(void (^)(NSDictionary *))block
{
    if (block) {
        self.selectcity = block;
    }
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    //NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getCityList]];
    self.cityListArray = [NSMutableArray arrayWithArray:[EZPublicList getCityList]];
    self.keys = [NSMutableArray array];
    self.cities = [NSMutableArray array];
    for (NSDictionary *dict in self.cityListArray) {
        for (NSString *key in dict) {
            [self.keys addObject:key];
            [self.cities addObject:[dict objectForKey:key]];
        }
    }
    
    // 添加热门城市
    [self.keys insertObject:HotCityKey atIndex:0];
    [self.cities insertObject:@[@{@"city":@"郑州"},@{@"city":@"杭州"}] atIndex:0];
    
    // 添加定位城市
    // 添加定位城市
    if ([[self.loc_cityDic objectForKey:@"city"] isEqualToString:@"error"] || self.loc_cityDic == nil) {
        [self.keys insertObject:LocCityKey atIndex:0];
        [self.cities insertObject:@[@{@"city":@"正在定位...",@"citycode":@"-1"}] atIndex:0];
    }else{
        [self.keys insertObject:LocCityKey atIndex:0];
        [self.cities insertObject:@[self.loc_cityDic] atIndex:0];
    }
    
}

#pragma mark - 观察者模式
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"cityName"])
    {
        
        NSString *cityName = change[@"new"];
        if (cityName.length>0) {
            
            if ([cityName hasSuffix:@"市"]) {
                cityName = [cityName substringToIndex:cityName.length-1];
            }
            self.loc_cityDic = @{@"city":cityName};
        }
        
        [self getCityData];
        [self.tableView reloadData];
        
    }
}

- (void)dealloc
{
    [self.cityLocation removeObserver:self forKeyPath:@"cityName"];
}

- (void)reqCityList
{
//    [self.hud show:YES];
//    [[RequestManager sharedRequestManager] getCityList_uid:[UserEntity getUid] success:^(id resultDic) {
//        [self.hud hide:YES];
//        if ([resultDic[STATUS] isEqualToString:SUCCESS]) {
//            
//            NSArray *list = [resultDic objectForKey:@"list"];
//            
//            self.cityListArray = [[NSMutableArray alloc] initWithArray:list];
//            
//            [self getCityData];
//            [self.tableView reloadData];
//        }
//    } failure:nil];
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
