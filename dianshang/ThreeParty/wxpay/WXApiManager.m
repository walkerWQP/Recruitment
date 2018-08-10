//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@interface WXApiManager ()

@property (nonatomic, strong) void(^callBlock)(NSDictionary *resp);

@end

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
    //[super dealloc];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSDictionary *userInfo;
        switch (resp.errCode) {
            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"resp", nil];
                break;
                
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"resp", nil];
                break;
        }
        if (self.callBlock) {
            self.callBlock(userInfo);
        }
    }

}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}


- (void)reqWXPayParams:(NSString *)orderID success:(void(^)(NSDictionary *resultDic))successBlock failure:(void(^)(NSError *error))failureBlock
{
    //访问网络根据订单号获取支付宝支付参数并把支付结果返回
    if ([WXApi isWXAppInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
//        [[RequestManager sharedRequestManager] getWXpayOrderid:orderID success:^(id resultDic) {
//            
//            NSNumber *status = resultDic[STATUS];
//            if (![status isEqualToNumber:@-1]) {
//                
//                [self wxpayWithDic:resultDic[INFO]];
//                self.callBlock = successBlock;
//                
//            }else{
//                //获取支付参数失败
//                NSError *error = [NSError errorWithDomain:resultDic[INFO] code:-1001 userInfo:@{@"errorkey":resultDic[INFO]}];
//                failureBlock(error);
//            }
//        } failure:^(NSError *error) {
//            failureBlock(error);
//        }];
    }else{
        //获取支付参数失败
        NSError *error = [NSError errorWithDomain:@"没有安装微信客户端不能完成支付!" code:-10086 userInfo:@{@"errorkey":@"没有安装微信客户端不能完成支付!"}];
        failureBlock(error);
    }

    
}

/*!
 *  @brief 微信支付
 *
 *  @param dict 支付参数
 */
- (void)wxpayWithDic:(NSDictionary *)dict
{
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    
    if(dict != nil){
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
        // 潜在泄露问题
        //[req autorelease];
        //日志输出
        CLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        
    }else{
        CLog(@"%@",@"服务器返回错误，未获取到json对象");
    }
}

@end
