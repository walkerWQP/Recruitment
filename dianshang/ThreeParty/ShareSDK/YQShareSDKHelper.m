//
//  YQShareSDKHelper.m
//  dianshang
//
//  Created by yunjobs on 2017/9/19.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#import "YQShareSDKHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//新浪微博需要引入的头文件
#ifdef IMPORT_SINA_WEIBO
#import "WeiboSDK.h"
#endif
//QQ需要引入的头文件
#if (defined IMPORT_SUB_QQFriend) || (defined IMPORT_SUB_QZone)
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#endif
//微信需要引入的头文件
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
#import "WXApi.h"
#endif

//微信回调
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
@interface YQShareSDKHelper ()<WXApiDelegate>
{
    
}
@end
#endif

@implementation YQShareSDKHelper

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasGetAppKey:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}

+ (void)hasGetAppKey:(NSNotification *)notification
{
    [YQShareSDKHelper shareInstance].platforems = [YQShareSDKHelper _getPlatforems];
    [ShareSDK registerActivePlatforms:[YQShareSDKHelper shareInstance].platforems
                             onImport:^(SSDKPlatformType platformType) {
                                 [YQShareSDKHelper _setConnectorWithPlatformType:platformType];
                             }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                          [YQShareSDKHelper _setConfigurationWithPlatformType:platformType appInfo:appInfo];
                      }];
}
//注册平台
+ (NSArray *)_getPlatforems
{
    NSMutableArray *platforems = [NSMutableArray array];
    //QQ好友
#ifdef IMPORT_SUB_QQFriend
    [platforems addObject:@(SSDKPlatformSubTypeQQFriend)];
#endif
    //微信好友
#ifdef IMPORT_SUB_WechatSession
    [platforems addObject:@(SSDKPlatformSubTypeWechatSession)];
#endif
    //微信朋友圈
#ifdef IMPORT_SUB_WechatTimeline
    [platforems addObject:@(SSDKPlatformSubTypeWechatTimeline)];
#endif
    //微博
#ifdef IMPORT_SINA_WEIBO
    [platforems addObject:@(SSDKPlatformTypeSinaWeibo)];
#endif
    return platforems;
}

//注册平台依赖 Connector
+ (void)_setConnectorWithPlatformType:(SSDKPlatformType)platformType
{
    switch (platformType) {
            //新浪微博
        case SSDKPlatformTypeSinaWeibo:
#ifdef IMPORT_SINA_WEIBO
            [ShareSDKConnector connectWeibo:[WeiboSDK class]];
#endif
            break;
            //QQ
        case SSDKPlatformTypeQQ:
#if (defined IMPORT_SUB_QQFriend) || (defined IMPORT_SUB_QZone)
            [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
#endif
            break;
            //微信
        case SSDKPlatformTypeWechat:
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
            //如需要获取微信的回调则 在delegate中设置 需实现 WXApiDelegate协议
            [ShareSDKConnector connectWeChat:[WXApi class] delegate:[YQShareSDKHelper shareInstance]];
#endif
            break;
        default:
            break;
    }
}

//注册平台信息
+ (void)_setConfigurationWithPlatformType:(SSDKPlatformType)platformType appInfo:(NSMutableDictionary *)appInfo
{
    switch (platformType) {
            //新浪微博
        case SSDKPlatformTypeSinaWeibo:
#ifdef IMPORT_SINA_WEIBO
#pragma mark - 新浪微博 增加权限
            //增加默认权限 如：关注官方微博
            //                   [appInfo SSDKSetAuthSettings:@[@"follow_app_official_microblog"]];
            [appInfo SSDKSetupSinaWeiboByAppKey:MOBSSDKSinaWeiboAppKey
                                      appSecret:MOBSSDKSinaWeiboAppSecret
                                    redirectUri:MOBSSDKSinaWeiboRedirectUri
                                       authType:MOBSSDKSinaWeiboAuthType];
#endif
            break;
            //QQ
        case SSDKPlatformTypeQQ:
#if (defined IMPORT_SUB_QQFriend) || (defined IMPORT_SUB_QZone)
            [appInfo SSDKSetupQQByAppId:MOBSSDKQQAppID
                                 appKey:MOBSSDKQQAppKey
                               authType:MOBSSDKQQAuthType
                                 useTIM:MOBSSDKQQUseTIM];
#endif
            break;
            //微信
        case SSDKPlatformTypeWechat:
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
            [appInfo SSDKSetupWeChatByAppId:MOBSSDKWeChatAppID
                                  appSecret:MOBSSDKWeChatAppSecret];
#endif
            break;
        default:
            break;
    }
}
+ (YQShareSDKHelper *)shareInstance
{
    static YQShareSDKHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[YQShareSDKHelper alloc] init];
    });
    return helper;
}

- (void)cancelAllAuthorize
{
    NSArray *platforems = [YQShareSDKHelper _getPlatforems];
    [platforems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SSDKPlatformType type = [obj integerValue];
        if ([ShareSDK hasAuthorized:type]) {
            [ShareSDK cancelAuthorize:type];
        }
    }];
}

#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
//微信的回调
-(void) onReq:(BaseReq*)req
{
    NSLog(@"wechat req %@",req);
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"wechat resp %@",resp);
}
#endif

@end
