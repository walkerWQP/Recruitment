//
//  YQCityLocation.m
//  dianshang
//
//  Created by yunjobs on 2017/9/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQCityLocation.h"

#import "JurisdictionMethod.h"

@interface YQCityLocation ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation YQCityLocation

#pragma mark - 地理定位
//开始定位
- (void)startLocation
{
    if ([JurisdictionMethod locationJurisdiction]) {
        if ([CLLocationManager locationServicesEnabled]) {
            //        CLog(@"--------开始定位");
            self.locationManager = [[CLLocationManager alloc]init];
            self.locationManager.delegate = self;
            //控制定位精度,越高耗电量越
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            // 总是授权
            [self.locationManager requestAlwaysAuthorization];
            self.locationManager.distanceFilter = 10.0f;
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager startUpdatingLocation];
        }
    }else{
        [[JurisdictionMethod shareJurisdictionMethod] locationJurisdictionAlert];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        CLog(@"访问被拒绝");
        self.cityName = @"error";
    }
    if ([error code] == kCLErrorLocationUnknown) {
        CLog(@"无法获取位置信息");
        self.cityName = @"error";
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yq_locationManager:didUpdateLocations:)]) {
        [self.delegate yq_locationManager:manager didUpdateLocations:locations];
    }else{
        // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
            if (array.count > 0){
                CLPlacemark *placemark = [array objectAtIndex:0];
                
                //获取城市
                NSString *city = placemark.locality;
                if (!city) {
                    // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea;
                }
                self.cityName = city;
            }
            else if (error == nil && [array count] == 0)
            {
                CLog(@"No results were returned.");
                self.cityName = @"error";
            }
            else if (error != nil)
            {
                CLog(@"An error occurred = %@", error);
                self.cityName = @"error";
            }
        }];
    }
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

@end
