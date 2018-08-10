//
//  EZCPersonCenterEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/12/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZCompanyInfoEntity;

@interface EZCPersonCenterEntity : NSObject

@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString *appraiseid;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *pcompanyid;
@property (nonatomic, copy) NSString *genre;
@property (nonatomic, copy) NSString *last_login_ip;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *identification;
@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, copy) NSString *check;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *partner;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *wb;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *restatus;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *explanation;
@property (nonatomic, copy) NSString *last_login_time;
@property (nonatomic, copy) NSString *wechatid;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *wx;
@property (nonatomic, copy) NSString *pt;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *hx_username;
@property (nonatomic, copy) NSString *informid;
@property (nonatomic, copy) NSString *isfast;

@property (nonatomic, copy) NSDictionary *company;
@property (nonatomic, copy) EZCompanyInfoEntity *companyEn;

+ (instancetype)entityWithDict:(NSDictionary *)dict;

@end

@interface EZCompanyInfoEntity : NSObject

@property (nonatomic, copy) NSString *team;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *ctag;
@property (nonatomic, copy) NSString *approve;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *cvedit;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *id_card_bottom;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *hot;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *identify;
@property (nonatomic, copy) NSString *companyinfo;
@property (nonatomic, copy) NSString *id_card_top;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *productinfo;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *teaminfo;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *id_card_num;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *license;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *license_num;


+ (instancetype)entityWithDict:(NSDictionary *)dict;

@end
