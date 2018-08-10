//
//  StickViewController.m
//  dianshang
//
//  Created by yunjobs on 2018/3/5.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "StickViewController.h"
#import "HomeJobEntity.h"
#import "HomeJobCell.h"
#import "HomePositionDetailVC.h"

#import "YQCityLocation.h"


@interface StickViewController ()<YQCityLocationDelegate>

@property (nonatomic, strong) YQCityLocation *cityLocation;

@end

@implementation StickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"每日E招推荐";
    
    // 开启定位 监听 cityName
    YQCityLocation *city = [[YQCityLocation alloc] init];
    [city startLocation];
    city.delegate = self;
    self.cityLocation = city;
    
    [self initTableV];
}

- (void)initTableV
{
    self.tableView.yq_height = APP_HEIGHT-APP_NAVH-APP_BottomH;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UINib *nib1 = [UINib nibWithNibName:@"HomeJobCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"StickCell"];
}
- (void)reqStickPosition:(NSString *)city
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getStickPositionList_uid:[UserEntity getUid] city:city page:@"" pagesize:KPageSize success:^(id resultDic) {
        [self.hud hide:YES];
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            
            for (NSDictionary *dict in list) {
                HomeJobEntity *en = [HomeJobEntity HomeJobEntityWithDict:dict];
                [self.tableArr addObject:en];
            }
            
            [self.tableView reloadData];
            
        }else if ([resultDic[CODE] isEqualToString:@"100003"]){
            self.hintLabel.hidden = NO;
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
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
            
            NSString *cityStr = [city hasSuffix:@"市"] ? [city substringToIndex:city.length-1] : city;
            
            [self reqStickPosition:cityStr];
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
#pragma mark - tableview

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
    HomeJobCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StickCell"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
