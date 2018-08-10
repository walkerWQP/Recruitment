//
//  YQViewController+YQShareMethod.m
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController+YQShareMethod.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "YQShareSDKHelper.h"
#import "ShareIconItem.h"
#import "ShareIconView.h"

@implementation YQViewController (YQShareMethod)

- (void)userInfoWithType:(SSDKPlatformType)type onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler
{
    //BOOL is = [ShareSDK hasAuthorized:type];
    [ShareSDK getUserInfo:type onStateChanged:stateChangedHandler];
}
- (void)shareWithParameters:(NSMutableDictionary *)parameters type:(SSDKPlatformType)type
{
    //    if(_isShare)
    //    {
    //        return;
    //    }
    //_isShare = YES;
    //platformType = type;
    if(parameters.count == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请先设置分享参数" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self shreViewWillAppear];
    
    [ShareSDK share:type
         parameters:parameters
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         if(state == SSDKResponseStateBeginUPLoad){
             return ;
         }
         
         NSString *titel = @"";
         NSString *typeStr = @"";
         UIColor *typeColor = [UIColor grayColor];
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 titel = @"分享成功";
                 typeStr = @"成功";
                 typeColor = [UIColor blueColor];
                 break;
             }
              case SSDKResponseStateFail:
              {
//                  _isShare = NO;
                  NSLog(@"error :%@",error);
                  titel = @"分享失败";
                  typeStr = [NSString stringWithFormat:@"%@",error];
                  typeColor = [UIColor redColor];
                  break;
              }
              case SSDKResponseStateCancel:
              {
//                  _isShare = NO;
                  titel = @"分享已取消";
                  typeStr = @"取消";
                  break;
              }
             default:
                 break;
         }
         if (![titel isEqualToString:@""]) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titel
                                                                 message:typeStr
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
             [alertView show];
         }
     }];
}

- (void)authAct:(SSDKPlatformType)platformType
{
    [ShareSDK authorize:platformType
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
             NSString *titel = @"";
             switch (state)
             {
                 case SSDKResponseStateSuccess:
                 {
                     
                     titel = @"授权成功";
                     NSLog(@"%@",user.rawData);
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titel message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     titel = @"授权失败";
                     NSLog(@"error :%@",error);
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     titel = @"取消授权";
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titel message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 default:
                     break;
             }
         }];
}

- (void)isInstallAPP:(SSDKPlatformType)platformType
{
    NSString *titel = @"";
    if([ShareSDK isClientInstalled:platformType])
    {
        titel = @"已安装";
    }
    else
    {
        titel = @"未安装";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titel
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - 分享视图

- (void)shareView
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *array = @[@"微信",@"微信朋友圈",@"QQ"];
    NSArray *array1 = @[@"share_icon2",@"share_icon3",@"share_icon4"];
    for (int i = 0; i < array.count; i++) {
        ShareIconItem *item = [[ShareIconItem alloc] init];
        item.title = array[i];
        item.icon = array1[i];
        [items addObject:item];
    }
    
    ShareIconView *view = [[ShareIconView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    view.column = 4;
    view.items = items;
    [view showAnimate];
    YQWeakSelf;
    view.buttonPress = ^(NSInteger index) {
        [weakSelf share:index];
    };
}


- (void)share:(NSInteger)index
{
    NSArray *shareSelectorNameArray = @[@"WechatSessionShare",@"WechatTimelineShare",@"QQFriendShare"];
    NSString *selectorName = shareSelectorNameArray[index-1];
    [self funcWithSelectorName:selectorName];
}

// 微信好友
- (void)WechatSessionShare
{
    [self shareWithParameters:[self getShateParameters] type:SSDKPlatformTypeWechat];
}
// 微信朋友圈
- (void)WechatTimelineShare
{
    [self shareWithParameters:[self getShateParameters] type:SSDKPlatformSubTypeWechatTimeline];
}
// 新浪微博
- (void)SinaWeiboShare
{
    [self shareWithParameters:[self getShateParameters] type:SSDKPlatformTypeSinaWeibo];
}
// QQ好友
- (void)QQFriendShare
{
    [self shareWithParameters:[self getShateParameters] type:SSDKPlatformSubTypeQQFriend];
}
- (void)funcWithSelectorName:(NSString *)selectorName
{
    SEL sel = NSSelectorFromString(selectorName);
    if([self respondsToSelector:sel])
    {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL) = (void *)imp;
        func(self, sel);
    }
}
- (NSMutableDictionary *)getShateParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置
    NSLog(@"aaaaaa %@",[NSBundle mainBundle]);
    
    
    
    [parameters SSDKSetupShareParamsByText:@"EZhao"
                                    images:[[NSBundle mainBundle] pathForResource:@"ceshi" ofType:@"jpg"]
                                       url:nil
                                     title:nil
                                      type:SSDKContentTypeImage];
    return parameters;
}
// 将要执行分享的时候调用
- (void)shreViewWillAppear
{
    NSLog(@"看看走这里没有");
    //有需要的时候子类重写该方法
    //CLog(@"有需要的时候子类重写该方法");
}

@end
