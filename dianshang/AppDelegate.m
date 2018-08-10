//
//  AppDelegate.m
//  dianshang
//
//  Created by yunjobs on 2017/7/12.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "AppDelegate.h"
#import "YQSaveManage.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>

#import "JPushManager.h"
#import "YQGuideManage.h"

#import "ChatDemoHelper.h"
#import "YQRootViewController.h"

#import "NSString+RegularExpression.h"
#import "NSString+Hash.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*------极光推送-------*/
    // Override point for customization after application launch.
    [[JPushManager shareJPushManager] registerJPush:launchOptions];
    
    // 设置别名
//    [[JPushManager shareJPushManager] setAlias:@"bieming" resBlock:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"%ld--%@--%ld",(long)iResCode, iAlias, (long)seq);
//    }];
    /*------环信-------*/
    
#pragma mark ========环信配置========
    NSString *cerName = @"iosstore_pro";
    NSString *EM_APPKEY = @"1103171009178395#liaoliao";
    
#pragma mark ========初始化SDK========
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:EM_APPKEY
                                         apnsCertName:cerName
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES],@"easeSandBox":[NSNumber numberWithBool:NO]}];
    
    [ChatDemoHelper shareHelper];
    
    [self loginHuanXin];
    
#pragma mark ========设置主窗口========
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *rootVC = [YQGuideManage chooseRootController];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    // xxxxxxxx
    
    if ([rootVC isKindOfClass:[YQRootViewController class]]) {
        
        //self.mainController = (YQRootViewController *)rootVC;
        
        //[ChatDemoHelper shareHelper].mainVC = self.mainController;
        [ChatDemoHelper shareHelper].mainVC = (YQRootViewController *)rootVC;
        //NSLog(@"%@",self.mainController.chatListVC);
        //[ChatDemoHelper shareHelper].conversationListVC = self.mainController.chatListVC;
        //        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
        //        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
        //        [[ChatDemoHelper shareHelper] asyncPushOptions];
    }
    
    
    // 预先获取token备用
//    if ([UserEntity getToken].length == 0) {
//        [[RequestManager sharedRequestManager] getToken_success:^(id resultDic) {
//            
//            if ([resultDic[@"code"] isEqualToString:@"100001"]){
//                NSDictionary *dict = resultDic[DATA];
//                [UserEntity setToken:dict[@"token_ez"]];
//            }
//            
//        } failure:nil];
//    }
    
    return YES;
}

#pragma mark ========登录环信========
- (void)loginHuanXin {
    NSString *hxname = [UserEntity getHXUserName];
    NSString *hxpass = @"123456".md5String;
//    [[EMClient sharedClient] loginWithUsername:hxname password:hxpass completion:^(NSString *aUsername, EMError *aError) {
//        if (!aError) {
//            CLog(@"环信->登录成功");
//            [[EMClient sharedClient].options setIsAutoLogin:YES];
//        } else {
//            CLog(@"环信->登录失败");
//        }
//    }];
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:hxname password:hxpass];
        CLog(@"%@",error);
    } else {
        NSLog(@"设置过自动登录");
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    CLog(@"\n ===> 程序暂停!");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    CLog(@"\n ===> 程序进入后台 !");
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    CLog(@"\n ===> 程序进入前台 !");
    // 清零角标
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //[application cancelAllLocalNotifications];
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    CLog(@"\n ===> 程序重新激活 !");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //判断有没有登录  如果登录过就进入主框架界面
    NSString *status = [YQSaveManage objectForKey:LOGINSTATUS];
    if (status != nil && [status isEqualToString:@"1"])
    {
        [self reqUserInfo];
    }
    
    NSString *hxname = [UserEntity getHXUserName];
    NSString *hxpass = @"123456".md5String;
    [[EMClient sharedClient] loginWithUsername:hxname password:hxpass completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            CLog(@"环信->登录成功");
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        } else {
            CLog(@"环信->登录失败");
        }
    }];
    
}
- (void)reqUserInfo
{
    [[RequestManager sharedRequestManager] getUserInfo_uid:[UserEntity getUid] success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSDictionary *dict = resultDic[DATA];
//            [UserEntity setRealAuth:dict[@"approve"]];
//            [UserEntity setIsCompany:NO];
            
            NSString *oldcheck = [[UserEntity userInfo] objectForKey:@"check"];
            NSString *newcheck = [dict objectForKey:@"check"];
            if (![oldcheck isEqualToString:newcheck]) {
                [self outLogin];
            }else{
                [UserEntity setUserInfo:dict];
            }
        }
    } failure:^(NSError *error) {
        
        NSLog(@"网络连接错误");
    }];
}

- (void)outLogin
{
    // 退出登录
    // 把密码清除
    NSDictionary *accountDic = [YQSaveManage objectForKey:MYACCOUNT];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:accountDic];
    [dict removeObjectForKey:@"password"];
    [YQSaveManage setObject:dict forKey:MYACCOUNT];
    // 清除用户信息
    [YQSaveManage removeObjectForKey:USERINFO];
    // 修改登录状态
    [YQSaveManage setObject:@"0" forKey:LOGINSTATUS];
    // 清除推送别名
    [[JPushManager shareJPushManager] setAlias:@"" resBlock:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    }];
    // 删除分享图片
    //[self deleteShareImage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 退出环信登录
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        [[EMClient sharedClient] logout:YES];
    });
    
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    keyWindow.rootViewController = [YQGuideManage chooseRootController];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    CLog(@"\n ===> 程序意外暂停!");
}

#pragma mark ========推送通知========

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //CLog(@"%@", [NSString stringWithFormat:@"推送令牌Device Token: %@", deviceToken]);
    // 注册推送令牌
    [JPUSHService registerDeviceToken:deviceToken];
    
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    CLog(@"推送注册失败did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    CLog(@"1--iOS6及以下系统，收到通知");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    CLog(@"2--iOS7及以上系统，收到通知");
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    // 收到本地通知
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//}

/******************************* end推送通知 *****************************************/

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

#pragma mark ========NOTE: 9.0以后使用新API接口========
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

@end
