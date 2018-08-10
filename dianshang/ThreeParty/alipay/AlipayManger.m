//
//  AlipayManger.m
//  kuainiao
//
//  Created by yunjobs on 16/9/13.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "AlipayManger.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AlipayManger ()

@end

@implementation AlipayManger

#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)yq_AlipayWithParamsDic:(NSDictionary *)paramsDic callBack:(void(^)(NSDictionary *resultDic))block
{
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    NSString *partner = [paramsDic objectForKey:@"partner"];
//    NSString *seller = [paramsDic objectForKey:@"seller_id"];
    NSString *privateKey = [paramsDic objectForKey:@"sign"];
        NSString *partner = @"2088611219336019";
        NSString *seller = @"2088611219336019";
    //    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMaxNMUDMOhS96Gdcc4qL+OvB3PuwjnZ3uhZgqODNhkitxTdeRR14CyqlC1mpD8NkltPtjKfG2SRRq/XqUw4STN9VNSVA1pNYeRJn6DQU6QAoUmwiwgGyPJeuXZ+daEt63A4yAKXfddNGbaCaNWlkP5vpioGj5ZSNFAs7W30NasPAgMBAAECgYEAvG07NQb0r65W5u6QCcsaRVssvzYS/Zfve/u/F2AMwsOYSnJKLCwpX1KZWYD4jE9Ll8q9Z75Z1QKsvX/RLtZGG6GZCivMMeFnP4Bpz7dIDJc/KGRC/XF2Pf356UIncOUoH7O2OQQdB+Xq/LlnnlSmHyJcXJQob6eJaaov3TnWTLkCQQDkJUqoT9nxkoztxGdjuNRKtoGWY9OPIErwoGAnhKBEVBEKMVZcEPLFkSpIBMLKncLyRLVqMjxtud/ATIbuHc1DAkEA3vNYOsNR1x2k0nc+R7hVMJHTOMOUdGoRbGSkILD5NzjWUyMDKpc/kmh0OI+HuxZ5tqldgmHGlbTL3AuZbVvIRQJBAN/VHnwna6IwsAeOjAkwi0eJ63XLFwLzIdMW5X+gBUVEXTts0FefYTAojhz+XsY/JcZfVsWL5/GXTUjzS+ZOYtUCQDWdL0pyTev9JPW31zJIEbRsXO75mWmlWCtIyG9UH5o4ANJdSRWk6ZS7qbcwTOOgtARJFkOUX70AjUWNRIgX2kECQQDAEchg2WsKCOWW8lnr1jmi/9XeOiNACjpIQMLuXErWBQXYg4zEhLH2BI81GjXCLBVfecFxi/iY8FQqybsbB/qD";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [paramsDic objectForKey:@"out_trade_no"]; //订单ID（由商家自行制定）
    order.productName = [paramsDic objectForKey:@"body"]; //商品标题
    order.productDescription = [paramsDic objectForKey:@"subject"]; //商品描述
    order.amount = [paramsDic objectForKey:@"total_fee"]; //商品价格
    //    order.amount = [NSString stringWithFormat:@"0.01"]; //商品测试价格
    order.notifyURL = [paramsDic objectForKey:@"notify_url"];//回调URL
    
    order.service = [paramsDic objectForKey:@"service"];
    order.paymentType = [paramsDic objectForKey:@"payment_type"];
    order.inputCharset = [paramsDic objectForKey:@"_input_charset"];
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"kbrid.com";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    CLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    NSString *signTpye = [paramsDic objectForKey:@"sign_type"];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, signTpye];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:block];
    }
}

// 访问网络根据订单号获取支付宝支付参数并把支付结果返回
- (void)reqAlipayParams:(NSString *)orderID success:(void(^)(NSDictionary *resultDic))successBlock failure:(void(^)(NSError *error))failureBlock
{
    //访问网络根据订单号获取支付宝支付参数并把支付结果返回
    //__weak typeof(self) weakSelf = self;
    [[RequestManager sharedRequestManager] getAlipayOrderid:@"" success:^(id resultDic) {
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            NSDictionary *dict = resultDic[DATA];
            
//            [self yq_AlipayWithParamsDic:[dict objectForKey:@"alipayinfo"] callBack:successBlock];
            
            [[AlipaySDK defaultService] payOrder:[dict objectForKey:@"alipayinfo"] fromScheme:@"EZAli.com" callback:successBlock];
        }else{
            //获取支付参数失败
            NSError *error = [NSError errorWithDomain:resultDic[INFO] code:-1001 userInfo:@{@"errorkey":resultDic[INFO]}];
            failureBlock(error);
        }
        
    } failure:failureBlock];
}


- (void)reqAlipayParams:(NSString *)orderID money:(NSString *)money type:(NSString *)type success:(void(^)(NSDictionary *resultDic))successBlock failure:(void(^)(NSError *error))failureBlock
{
    [[RequestManager sharedRequestManager] accountRecharge_uid:[UserEntity getUid] ordernum:orderID money:money type:type success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            NSDictionary *dict = resultDic[DATA];
            
            [[AlipaySDK defaultService] payOrder:[dict objectForKey:@"alipayinfo"] fromScheme:@"EZAli.com" callback:successBlock];
        }else if([resultDic[CODE] isEqualToString:@"100002"]){
            //获取支付参数失败
            NSError *error = [NSError errorWithDomain:resultDic code:-1002 userInfo:@{@"errorkey":resultDic}];
            failureBlock(error);
            [YQToast yq_AlertText:resultDic[@"msg"]];
        }else{
            //获取支付参数失败
            NSError *error = [NSError errorWithDomain:resultDic[DATA] code:-1001 userInfo:@{@"errorkey":resultDic[DATA]}];
            failureBlock(error);
        }
    } failure:^(NSError *error) {
        NSLog(@"网络连接错误");
    }];
}
- (void)reqAlipayParams:(NSString *)orderID money:(NSString *)money type:(NSString *)type ext:(NSDictionary *)ext success:(void(^)(NSDictionary *resultDic))successBlock failure:(void(^)(NSError *error))failureBlock
{
    [[RequestManager sharedRequestManager] redpacketRecharge_uid:[UserEntity getUid] ordernum:orderID money:money type:type ext:ext success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            NSDictionary *dict = resultDic[DATA];
            
            [[AlipaySDK defaultService] payOrder:[dict objectForKey:@"alipayinfo"] fromScheme:@"EZAli.com" callback:successBlock];
        }else if([resultDic[CODE] isEqualToString:@"100002"]){
            //获取支付参数失败
            NSError *error = [NSError errorWithDomain:resultDic code:-1002 userInfo:@{@"errorkey":resultDic}];
            failureBlock(error);
            [YQToast yq_AlertText:resultDic[@"msg"]];
        }else{
            //获取支付参数失败
            NSError *error = [NSError errorWithDomain:resultDic[@"msg"] code:-1001 userInfo:@{@"errorkey":resultDic[@"msg"]}];
            failureBlock(error);
        }
    } failure:^(NSError *error) {
        NSLog(@"网络连接错误");
    }];
}

#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
