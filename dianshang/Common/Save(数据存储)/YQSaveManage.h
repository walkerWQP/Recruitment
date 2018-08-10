//
//  YQSaveManage.h
//  caipiao
//
//  Created by yunjobs on 16/8/5.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

/// lyq: 设置需要存储的key
// 版本
#define LVersion @"version"
// 注册页面跳转到首页的标识
#define LRegistFlag @"RegistFlag"
// 是否登录过标识登录的状态(1=登录,0=没有登录)
#define LOGINSTATUS @"loginStatus"
// 保存帐号密码
#define MYACCOUNT @"myAccount"

// 是否进入全屏广告页(1=进入,0=不进入)
#define LAdvertisement @"Advertisement"

// 保存认证状态(0未认证1已认证2芝麻信用3认证协议)
#define LAuthState @"AuthState"

//// 保存用户余额信息
//#define BALANCE @"BALANCE"
// 保存登录后的用户信息
#define USERINFO @"USERINFO"
// 保存登录后的token
#define LTOKEN @"token"
/// 保存提现账户
#define LTixianAccount @"WithdrawalAccount"
//保存消息通知的状态
#define PROMPT @"promptManage"

// 历史搜索记录
#define LHistoryRecord @"searchHistoryRecord"
// 企业历史搜索记录
#define LCHistoryRecord @"searchCHistoryRecord"

#import <Foundation/Foundation.h>

@interface YQSaveManage : NSObject

+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (id)objectForKey:(NSString *)defaultName;

+ (void)removeObjectForKey:(NSString *)defaultName;

+ (void)yq_addObject:(id)value forKey:(NSString *)defaultName;
+ (void)yq_removeIndex:(NSInteger)index forKey:(NSString *)defaultName;
+ (void)yq_updateIndex:(NSInteger)index object:(id)value forKey:(NSString *)defaultName;

@end
