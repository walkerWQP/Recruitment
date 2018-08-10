//
//  YQPayManage.h
//  kuainiao
//
//  Created by yunjobs on 16/12/19.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

/********编码规范**************

 code   codeMsg
 1000   支付成功
 2000   支付失败
 3000   支付已取消
 4000   支付宝-网络连接出错
 4001   余额-网络连接出错
 5000   余额不足
 
**********************/

typedef NS_ENUM(NSInteger, YQPayOrderType) {
    YQPayOrderRechargeType,// 充值顾问费
    YQPayOrderEdouType,// e豆
    YQPayOrderEdouActivityType,// e豆活动
    YQPayOrderRedpacketType,// 红包
};

typedef NS_ENUM(NSInteger, YQPayMode) {
    YQPayModeBalance,// 余额支付
    YQPayModeAli,// 支付宝支付
    YQPayModeWX,// 微信支付
};

typedef void(^handleBlock)(NSInteger code, YQPayMode model, NSString *codeMsg, NSString *errorStr);

#import <Foundation/Foundation.h>
 
@interface YQPayManage : NSObject<UIActionSheetDelegate>

/// 通用支付方式,包括三种:余额/支付宝/微信
//- (void)handleOrderType:(YQPayOrderType)type orderid:(NSString *)orderid money:(CGFloat)money handleBlock:(handleBlock)block;

/// 直接选择交付方式
/// 指定支付方式,三种:余额/支付宝/微信 任意一种
- (void)handlePayMode:(YQPayMode)mode orderType:(YQPayOrderType)type orderid:(NSString *)orderid money:(NSString *)money handleBlock:(handleBlock)block;

/// 发送面试红包使用
- (void)handlePayMode:(YQPayMode)mode orderType:(YQPayOrderType)type orderid:(NSString *)orderid money:(NSString *)money ext:(NSDictionary *)ext handleBlock:(handleBlock)block;

@end
