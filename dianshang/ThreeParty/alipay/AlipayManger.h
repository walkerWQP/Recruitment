//
//  AlipayManger.h
//  kuainiao
//
//  Created by yunjobs on 16/9/13.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayManger : NSObject

/// 访问网络根据订单号获取支付宝支付参数并把支付结果返回
- (void)reqAlipayParams:(NSString *)orderID success:(void(^)(NSDictionary *resultDic))successBlock failure:(void(^)(NSError *error))failureBlock;


- (void)reqAlipayParams:(NSString *)orderID money:(NSString *)money type:(NSString *)type success:(void(^)(NSDictionary *resultDic))successBlock failure:(void(^)(NSError *error))failureBlock;

- (void)reqAlipayParams:(NSString *)orderID money:(NSString *)money type:(NSString *)type ext:(NSDictionary *)ext success:(void(^)(NSDictionary *resultDic))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
