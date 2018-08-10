//
//  YQGuideManage.m
//  caipiao
//
//  Created by yunjobs on 16/8/5.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQGuideManage.h"
#import "YQNavigationController.h"

#import "YQSaveManage.h"
#import "YQRootViewController.h"
#import "LoginViewController.h"
#import "YQGuideViewController.h"

@implementation YQGuideManage

//#warning lyq:需要根据业务重新修改引导页逻辑
+ (UIViewController *)chooseRootController
{
    //    // 定义一个窗口的根控制器
    UIViewController *rootVc = nil;
    
    //   获取当前的最新版本号 2.0
    NSString *curVersion =  [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    // 获取上一次的版本号  1.0.1
    NSString *oldVersion = [YQSaveManage objectForKey:LVersion];
    
    
    if ((curVersion!=nil&&![curVersion isEqualToString:oldVersion]) || oldVersion==nil) {
        [YQSaveManage setObject:curVersion forKey:LVersion];
        
        YQGuideViewController *newFeatureVc = [[YQGuideViewController alloc] init];
        
        rootVc = newFeatureVc;
        
    } else { // 没有最新的版本号
        
        if ([[YQSaveManage objectForKey:LRegistFlag] isEqualToString:@"1"]) {
            YQRootViewController *tabBarVc = [[YQRootViewController alloc] init];
            rootVc = tabBarVc;
        }else{
            //判断有没有登录  如果登录过就进入主框架界面
            NSString *status = [YQSaveManage objectForKey:LOGINSTATUS];
            if (status != nil && [status isEqualToString:@"1"])
            {
                YQRootViewController *tabBarVc = [[YQRootViewController alloc] init];
                rootVc = tabBarVc;
            }else{// 否则就进入登录页
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                YQNavigationController *loginVCNav = [[YQNavigationController alloc] initWithRootViewController:loginVC];
                rootVc = loginVCNav;
            }
        }
    }
    
    return rootVc;
}

@end
