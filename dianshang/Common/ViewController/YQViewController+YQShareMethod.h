//
//  YQViewController+YQShareMethod.h
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface YQViewController (YQShareMethod)

- (void)shareView;
// 微信好友
- (void)WechatSessionShare;
// 微信朋友圈
- (void)WechatTimelineShare;
// 新浪微博
- (void)SinaWeiboShare;
// QQ好友
- (void)QQFriendShare;

// 设置分享参数
- (NSMutableDictionary *)getShateParameters;
// 将要执行分享的时候调用
- (void)shreViewWillAppear;

/**
 传入定义分享参数进行分享
 
 @param parameters 分享参数
 */
- (void)shareWithParameters:(NSMutableDictionary *)parameters type:(SSDKPlatformType)type;

/**
 传入平台类型返回个人信息
 
 @param parameters 平台类型
 */
- (void)userInfoWithType:(SSDKPlatformType)type onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler;

- (void)authAct:(SSDKPlatformType)platformType;

- (void)isInstallAPP:(SSDKPlatformType)platformType;

@end
