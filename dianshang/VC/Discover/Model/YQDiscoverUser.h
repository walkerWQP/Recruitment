//
//  YQDiscoverUser.h
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    YQUserVerifiedTypeNone = -1, // 没有任何认证
    
    YQUserVerifiedPersonal = 0,  // 个人认证
    
    YQUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    YQUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    YQUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    
    YQUserVerifiedDaren = 220 // 微博达人
} YQUserVerifiedType;

@interface YQDiscoverUser : NSObject
/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;
/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter = isVip) BOOL vip;

/** 认证类型 */
@property (nonatomic, assign) YQUserVerifiedType verified_type;

+ (instancetype)userWithDict:(NSDictionary *)dict;

@end
