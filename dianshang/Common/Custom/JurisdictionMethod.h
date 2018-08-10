//
//  JurisdictionMethod.h
//  kuainiao
//
//  Created by yunjobs on 16/4/29.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JurisdictionMethod : NSObject

+ (JurisdictionMethod *)shareJurisdictionMethod;
//相机权限
+ (BOOL)videoJurisdiction;
//没有相机权限时执行
- (void)photoJurisdictionAlert;

//相册权限
+ (BOOL)libraryJurisdiction;
//没有相册权限时执行
- (void)libraryJurisdictionAlert;

//定位权限
+ (BOOL)locationJurisdiction;
//没有定位权限时执行
- (void)locationJurisdictionAlert;

@end
