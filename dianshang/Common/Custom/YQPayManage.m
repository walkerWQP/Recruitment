//
//  YQPayManage.m
//  kuainiao
//
//  Created by yunjobs on 16/12/19.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQPayManage.h"
//#import "TPPasswordTextView.h"
#import "AlipayManger.h"
#import "WXApiManager.h"

@interface YQPayManage ()
{
    NSString *orderID;
}

@property (nonatomic, assign) NSString *money;
@property (nonatomic, assign) YQPayOrderType type;

@property (nonatomic, strong) handleBlock handleOrderBlock;

@end

@implementation YQPayManage

// 通用支付方式,包括三种:余额/支付宝/微信
- (void)handleOrderType:(YQPayOrderType)type orderid:(NSString *)orderid money:(CGFloat)money handleBlock:(handleBlock)block
{
    //self.money = money;
    orderID = orderid;
    if (block) {
        self.handleOrderBlock = block;
    }
    //弹出缴纳方式选择
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"余额(%@元)",[UserEntity getBalance]],@"支付宝支付",@"微信支付", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
// 指定支付方式,三种:余额/支付宝/微信 任意一种
- (void)handlePayMode:(YQPayMode)mode orderType:(YQPayOrderType)type orderid:(NSString *)orderid money:(NSString *)money handleBlock:(handleBlock)block
{
    self.money = money;
    orderID = orderid;
    self.type = type;
    if (block) {
        self.handleOrderBlock = block;
    }
    if (mode == YQPayModeBalance) {
        //余额支付
        //判断余额够不够
        CGFloat balance = [[UserEntity getBalance] floatValue];
        if (balance<[self.money floatValue]) {
            if (self.handleOrderBlock) {
                self.handleOrderBlock(5000,YQPayModeBalance,@"余额不足",@"余额不足");
            }
        }else{
//            if ([[UserEntity hasPaypass] isEqualToString:@"0"]) {
//                if (self.handleOrderBlock) {
//                    self.handleOrderBlock(4002,@"未设置支付密码",@"未设置支付密码");
//                }
//            }else{
//                // 弹出输入密码框
//                [self passwordAlertView:[NSString stringWithFormat:@"需要支付%.2f元",self.money]];
//            }
        }
    }else if (mode == YQPayModeAli) {
        //支付宝支付
        [self selectPayMode:1 password:@""];
    }else if (mode == YQPayModeWX) {
        //微信支付
        [self selectPayMode:2 password:@""];
    }
}
/// 发送面试红包使用
- (void)handlePayMode:(YQPayMode)mode orderType:(YQPayOrderType)type orderid:(NSString *)orderid money:(NSString *)money ext:(NSDictionary *)ext handleBlock:(handleBlock)block
{
    self.money = money;
    orderID = orderid;
    self.type = type;
    if (block) {
        self.handleOrderBlock = block;
    }
    if (mode == YQPayModeBalance) {
        //余额支付
        //判断余额够不够
        CGFloat balance = [[UserEntity getBalance] floatValue];
        if (balance<[self.money floatValue]) {
            if (self.handleOrderBlock) {
                self.handleOrderBlock(5000,YQPayModeBalance,@"余额不足",@"余额不足");
            }
        }else{
            //            if ([[UserEntity hasPaypass] isEqualToString:@"0"]) {
            //                if (self.handleOrderBlock) {
            //                    self.handleOrderBlock(4002,@"未设置支付密码",@"未设置支付密码");
            //                }
            //            }else{
            //                // 弹出输入密码框
            //                [self passwordAlertView:[NSString stringWithFormat:@"需要支付%.2f元",self.money]];
            //            }
        }
    }else if (mode == YQPayModeAli) {
        //支付宝支付
        AlipayManger *alipay = [[AlipayManger alloc] init];
        // 1、顾问费；2、e豆
        NSString *type = [NSString stringWithFormat:@"%ld",self.type+1];
        if (type != nil) {
            [alipay reqAlipayParams:orderID money:self.money type:type ext:ext success:^(NSDictionary *resultDic) {
                [self alipayWithDic:resultDic];
            } failure:^(NSError *error) {
                if (self.handleOrderBlock) {
                    self.handleOrderBlock(4001,YQPayModeAli,@"网络问题-支付宝获取参数",error.domain);
                }
            }];
        }else{
            CLog(@"出错了");
        }
    }else if (mode == YQPayModeWX) {
        //微信支付
        [self selectPayMode:2 password:@""];
    }
}
#pragma mrak - 支付方式选择

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //余额支付
        //判断余额够不够
        CGFloat balance = [[UserEntity getBalance] floatValue];
        if (balance<[self.money floatValue]) {
            if (self.handleOrderBlock) {
                self.handleOrderBlock(5000,YQPayModeBalance,@"余额不足",@"余额不足");
            }
        }else{
//            if ([[UserEntity hasPaypass] isEqualToString:@"0"]) {
//                if (self.handleOrderBlock) {
//                    self.handleOrderBlock(4002,@"未设置支付密码",@"未设置支付密码");
//                }
//            }else{
//                // 弹出输入密码框
//                [self passwordAlertView:[NSString stringWithFormat:@"需要支付%.2f元",self.money]];
//            }
        }
    }else if (buttonIndex == 1) {
        //支付宝支付
        [self selectPayMode:1 password:@""];
    }else if (buttonIndex == 2) {
        //微信支付
        [self selectPayMode:2 password:@""];
    }
}

//6位密码输入弹出框
- (void)passwordAlertView:(NSString *)message
{
//    UIAlertView *zhifuAlert = [[UIAlertView alloc] initWithTitle:@"请输入支付密码" message:message delegate:self cancelButtonTitle:@"取消支付" otherButtonTitles:@"确定支付",nil];
//    [zhifuAlert show];
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 40)];
//    //v.backgroundColor = [UIColor redColor];
//    TPPasswordTextView *passViewold = [[TPPasswordTextView alloc] initWithFrame:CGRectMake(0, 0, 200, 200/6)];
//    passViewold.layer.cornerRadius = 8;
//    passViewold.layer.borderColor = RGB(180, 180, 180).CGColor;
//    passViewold.layer.borderWidth = 1;
//    passViewold.elementCount = 6;
//    passViewold.center = CGPointMake(v.center.x, v.center.y);
//    passViewold.passwordBlock = ^(NSString *password) {
//    };
//    passViewold.executeBlock = ^(NSString *password) {
//        [zhifuAlert dismissWithClickedButtonIndex:1 animated:YES];//触发dismiss
//        [self selectPayMode:0 password:password];
//    };
//    [v addSubview:passViewold];
//    [zhifuAlert setValue:v forKey:@"accessoryView"];
//    //延迟0.01秒弹出键盘
//    UITextField *textField = [passViewold viewWithTag:100];
//    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(aa:) userInfo:textField repeats:NO];
}
//弹出键盘
- (void)aa:(NSTimer *)timer
{
    UITextField *textField = (UITextField *)timer.userInfo;
    [textField becomeFirstResponder];
}

// 0余额支付 1支付宝支付 2微信支付  password:余额支付密码
- (void)selectPayMode:(int)myflag password:(NSString *)password
{
    if (myflag == 0) {
        //余额支付
        /*[[RequestManager sharedRequestManager] dealTradeOrderid:orderID pay_type:@"1" pay_pass:password success:^(id resultDic) {
            NSNumber *status = resultDic[STATUS];
            if (![status isEqualToNumber:@-1]) {
                if (self.handleOrderBlock) {
                    self.handleOrderBlock(1000,@"余额-支付成功",@"支付成功");
                }
                //减掉余额并保存到本地
                float jiage = [[UserEntity balance] floatValue] - self.money;
                NSString *str = [NSString stringWithFormat:@"%.2f",jiage];
                [UserEntity setBalance:str];
                
            }else{
                if ([resultDic[INFO] isEqualToString:@"请先设置支付密码"]) {
                    if (self.handleOrderBlock) {
                        self.handleOrderBlock(4002,@"未设置支付密码",@"未设置支付密码");
                    }
                }
                if (self.handleOrderBlock) {
                    self.handleOrderBlock(1001,@"余额-支付失败",resultDic[INFO]);
                }
            }
        } failure:^(NSError *error) {
            if (self.handleOrderBlock) {
                self.handleOrderBlock(4003,@"网络问题-余额",error.domain);
            }
        }];*/
    }else if (myflag == 1) {
        //支付宝支付
            //获取支付宝参数并处理支付结果
            
        AlipayManger *alipay = [[AlipayManger alloc] init];
        // 1、顾问费；2、e豆
        NSString *type = nil;
        if (self.type == 0) {
            type = @"1";
        }else if (self.type == 1){
            type = @"2";
        }else if (self.type == 2){
            type = @"3";
        }
        if (type != nil) {
            [alipay reqAlipayParams:orderID money:self.money type:type success:^(NSDictionary *resultDic) {
                [self alipayWithDic:resultDic];
            } failure:^(NSError *error) {
                if (self.handleOrderBlock) {
                    self.handleOrderBlock(4001,YQPayModeAli,@"网络问题-支付宝获取参数",error.domain);
                }
            }];
        }else{
            CLog(@"出错了");
        }
    }
    else if (myflag == 2) {
        //微信支付
        //获取微信支付参数
//        [[WXApiManager sharedManager] reqWXPayParams:orderID success:^(NSDictionary *resultDic) {
//            [self WXPayResult:resultDic];
//        } failure:^(NSError *error) {
//            if (self.handleOrderBlock) {
//                self.handleOrderBlock(4001,YQPayModeWX,@"网络问题-微信获取参数",error.domain);
//            }
//        }];
    }
}

/*!
 *  @brief 微信支付结果
 *
 *  @param notification 通知
 */
- (void)WXPayResult:(NSDictionary *)resultDic
{
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    NSString *resp = [resultDic objectForKey:@"resp"];
    if ([resp isEqualToString:@"1"]) {
        //支付成功跳转到成功页面
        if (self.handleOrderBlock) {
            self.handleOrderBlock(1000,YQPayModeWX,@"微信-支付成功",@"支付成功");
        }
    }
    else if ([resp isEqualToString:@"0"])
    {
        if (self.handleOrderBlock) {
            self.handleOrderBlock(3000,YQPayModeWX,@"微信-支付已取消",@"支付已取消");
        }
    }
}
/*!
 *  @brief 支付宝支付
 *
 *  @param dic 支付参数
 */
- (void)alipayWithDic:(NSDictionary *)resultDic
{
    //            9000 订单支付成功
    //            8000 正在处理中
    //            4000 订单支付失败
    //            6001 用户中途取消
    //            6002 网络连接出错
    NSString *code = resultDic[@"resultStatus"];
    if ([code isEqualToString:@"9000"]) {
        //支付成功跳转到成功页面
        if (self.handleOrderBlock) {
            self.handleOrderBlock(1000,YQPayModeAli,@"支付宝-支付成功",@"支付成功");
        }
    }
    else if ([code isEqualToString:@"8000"])
    {
        
    }
    else if ([code isEqualToString:@"4000"])
    {
        if (self.handleOrderBlock) {
            self.handleOrderBlock(2000,YQPayModeAli,@"支付宝-订单支付失败",@"支付失败");
        }
    }
    else if ([code isEqualToString:@"6001"])
    {
        if (self.handleOrderBlock) {
            self.handleOrderBlock(3000,YQPayModeAli,@"支付宝-支付已取消",@"支付已取消");
        }
    }
    else if ([code isEqualToString:@"6002"])
    {
        if (self.handleOrderBlock) {
            self.handleOrderBlock(4000,YQPayModeAli,@"支付宝-网络连接出错",@"网络连接出错");
        }
    }
}
@end
