//
//  JPushManager.m
//  kuainiao
//
//  Created by yunjobs on 16/4/28.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "JPushManager.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

@interface JPushManager ()<JPUSHRegisterDelegate,UIAlertViewDelegate>
{
    NSDictionary *userInfoDic;
}
@end

static JPushManager *jpushManager;
@implementation JPushManager

+ (JPushManager *)shareJPushManager
{
    if (jpushManager == nil) {
        jpushManager = [[JPushManager alloc] init];
    }
    return jpushManager;
}

/** 注册JPush */
-(void)registerJPush:(NSDictionary *)launchOptions{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel apsForProduction:isProduction];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
//    if ([UserEntity uid].length) {        
//        NSString *alias = [NSString stringWithFormat:@"kbird_%@",[UserEntity uid]];
//        [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//            
//        }];
//    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSLog(@"收到消息");
}

- (void)setAlias:(NSString *)alias resBlock:(void(^)(NSInteger iResCode, NSString *iAlias, NSInteger seq))block
{
    if ([JPUSHService registrationID]) {
        //注册推送别名
        [JPUSHService setAlias:alias completion:block seq:0];
        
    }
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //CLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        CLog(@"iOS10 前台收到远程通知:%@", title);
        
        userInfoDic = userInfo;
        UIAlertView *notifyAlert = [[UIAlertView alloc] initWithTitle:@"" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        notifyAlert.tag = 1000;
        [notifyAlert show];
        
        NSString *a = userInfo[@"type"];
        if ([a isEqualToString:@"2"]) {
            [UserEntity setRealAuth:@"1"];
        }else if ([a isEqualToString:@"6"]){
            [UserEntity setRealAuth:@"2"];
        }
        
    }
    else {
        // 判断为本地通知
        CLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    //completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //CLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        CLog(@"iOS10 收到远程通知:%@",title);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:myMessage object:userInfo];
        NSString *a = userInfo[@"type"];
        if ([a isEqualToString:@"2"]) {
            [UserEntity setRealAuth:@"1"];
        }else if ([a isEqualToString:@"6"]){
            [UserEntity setRealAuth:@"2"];
        }
    }
    else {
        // 判断为本地通知
        CLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}

//// log NSSet with UTF8
//// if not ,log will be \Uxxx
//- (NSString *)logDic:(NSDictionary *)dic {
//    if (![dic count]) {
//        return nil;
//    }
//    NSString *tempStr1 =
//    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
//                                                 withString:@"\\U"];
//    NSString *tempStr2 =
//    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *tempStr3 =
//    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *str =
//    [NSPropertyListSerialization propertyListFromData:tempData
//                                     mutabilityOption:NSPropertyListImmutable
//                                               format:NULL
//                                     errorDescription:NULL];
//    return str;
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:myMessage object:userInfoDic];
        }
    }
}
#pragma mark - 声音
- (void)playSound
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ddddd.wav" withExtension:nil];
    SystemSoundID soundID = 10;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
//    if ([[UserEntity vibrationStatus] isEqualToString:@"1"]) {
//        AudioServicesPlayAlertSound(soundID);
//    }else{
        AudioServicesPlaySystemSound(soundID);
//    }
}

- (void)playLudanSound:(NSString *)soundName
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
    SystemSoundID soundID = 10;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
    if ([soundName isEqualToString:@"error.wav"]) {
        [self playVibrate];
    }
}

- (void)playVibrate
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);//震动
}
@end
