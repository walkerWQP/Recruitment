//
//  Constants.h
//  MobileLuoYang
//  自定义的的常量
//  Created by csip on 15-1-15.
//  Copyright (c) 2015年 com.hn3l.mobilely. All rights reserved.
//

#ifndef MobileLuoYang_Constants_h
#define MobileLuoYang_Constants_h

// 跟android一致,勿改
/** @brief 用户id */
#define kProfileUserID @"EZProfileUserID"
/** @brief 环信id */
#define kHXUserID @"EZHXUserID"
/** @brief 用户昵称 */
#define kProfileUserName @"EZProfileUserName"
/** @brief 用户头像地址 */
#define kProfileUserHeadPath @"EZProfileUserHeadPath"
/** @brief 单元格类型标识key(对应三个值 kResumeFlag/kWXFlag/kTelFlag) */
#define kKeyFlag @"EZKeyFlag"
/** @brief 单元格类型(简历标识) */
#define kResumeFlag @"EZResumeFlag"
/** @brief 单元格类型(交换微信) */
#define kWXFlag @"EZWXFlag"
/** @brief 单元格类型(交换电话) */
#define kTelFlag @"EZTelFlag"
/** @brief 发送方显示的内容标识 */
#define kSendTextFlag @"EZSendTextFlag"
/** @brief 接收方显示的内容标识 */
#define kRecvTextFlag @"EZRecvTextFlag"
/** @brief 回复标识key(-1->没有用到;0->同意;1->拒绝) */
#define kReplyFlag @"EZReplyFlag"
/** @brief 发送交换请求是携带的自己帐号key */
#define kNumberFlag @"EZNumberFlag"
#define kResumeTitleFlag @"EZResumeTitle"//标题
#define kResumeDesFlag @"EZResumeDes"//描述
#define kResumeImgFlag @"EZResumeImg"//头像
#define kResumeLinkFlag @"EZResumeLink"//简历链接

// cell的边框宽度
#define YQStatusTextMaxH 120
#define YQStatusCellPadding 20
#define YQStatusCellSpacing 5
//#define XFStatusCellBorderH 5
//#define XFStatusMargin 10


#define kNetworkNotification @"YQNetworkNotification"

#define SecondsCountDown 60

// 弱引用
#define YQWeakSelf __weak typeof(self) weakSelf = self;

/**
 * 随机色
 */
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

//过期提醒
#define YQ_Deprecated(instead) NS_DEPRECATED(2_0_5, 2_0, 2_0, 2_0, instead)

//主题颜色
#define THEMECOLOR RGB(55, 123, 207)

#define BTNBACKGROUND [UIColor colorWithRed:0.128 green:0.354 blue:0.567 alpha:1.000]
// 红色按钮(警告)
#define redBtnNormal RGB(241, 83, 83)
#define redBtnHighlighted RGB(213, 63, 63)
// 橘色
#define orangeNormal RGB(255, 197, 85)
// 主题色按钮
#define blueBtnNormal RGB(55, 123, 207)
#define blueBtnHighlighted [UIColor colorWithRed:0.128 green:0.354 blue:0.567 alpha:1.000]


//系统版本
#define IOS_VERSION_11_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)? (YES):(NO))
#define IOS_VERSION_10_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)? (YES):(NO))
#define IOS_VERSION_9_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))
#define IOS_VERSION_8_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))
#define IOS_VERSION_7_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue]<8.0)? (YES):(NO))
#define IOS_VERSION_6_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue]<8.0)? (YES):(NO))
//判断iphone版本
#define IS_IPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

//十六进制颜色
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGB(r, g, b) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//屏幕宽高
#define APP_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define APP_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define APP_NAVH ([UIScreen mainScreen].bounds.size.height==812 ? 88 : 64)
#define APP_TABH ([UIScreen mainScreen].bounds.size.height==812 ? 83 : 49)
#define APP_BottomH ([UIScreen mainScreen].bounds.size.height==812 ? 34 : 0)

#pragma mark ---- UIImage  UIImageView  functions
#define IMG(name) [UIImage imageNamed:name]

#pragma mark ---- File  functions
#define STRING(str)         (str==[NSNull null])?@"":str


#endif

//调试输出
#ifdef DEBUG
//#define CLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define CLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define CLog(format, ...)
#endif
