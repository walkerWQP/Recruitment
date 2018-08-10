//
//  YQCityLocation.h
//  dianshang
//
//  Created by yunjobs on 2017/9/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@protocol YQCityLocationDelegate;

@interface YQCityLocation : NSObject

//开始定位
- (void)startLocation;

@property (nonatomic, strong) NSString *cityName;

// deleagte
@property (nonatomic, weak) id<YQCityLocationDelegate> delegate;

@end

@protocol YQCityLocationDelegate <NSObject>

- (void)yq_locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations;

@end
