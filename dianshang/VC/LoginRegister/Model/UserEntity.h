//
//  UserEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/9/19.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject

#pragma mark - token

// token
+ (void)setToken:(NSString *)token;
+ (NSString *)getToken;

#pragma mark - 用户基本信息
+ (NSDictionary *)handerDic:(NSDictionary *)dic;
// 用户资料
+ (void)setUserInfo:(NSDictionary *)dict;
+ (NSDictionary *)userInfo;

// id
+ (NSString *)getUid;
// cid公司ID
+ (NSString *)getCompanyId;
// 获取认证资料
//+ (NSDictionary *)getCertificate;
// 头像URL
+ (void)setHeadImgUrl:(NSString *)headImgUrl;
+ (NSString *)getHeadImgUrl;
// 昵称
+ (void)setNickName:(NSString *)nickName;
+ (NSString *)getNickName;
// 华信姓名标识
//+ (void)setHXUserName:(NSString *)userName;
+ (NSString *)getHXUserName;
// 余额
+ (void)setBalance:(NSString *)balance;
+ (NSString *)getBalance;
// 用户e豆
+ (void)setEdou:(NSString *)edou;
+ (NSString *)getEdou;
// 冻结余额
+ (void)setFrozenBalance:(NSString *)balance;
+ (NSString *)getFrozenBalance;
// 简介
//+ (void)setSynopsis:(NSString *)synopsis;
//+ (NSString *)getSynopsis;
// 姓名
//+ (void)setRealname:(NSString *)realname;
//+ (NSString *)getRealname;
// 手机号
+ (void)setPhone:(NSString *)phone;
+ (NSString *)getPhone;
// 工作年份
+ (void)setWorkyear:(NSString *)year;
+ (NSString *)getWorkyear;
// 性别
+ (void)setSex:(NSString *)sex;
+ (NSString *)getSex;
// 生日
+ (void)setBrithDay:(NSString *)brithDay;
+ (NSString *)getBrithDay;
// 学历
+ (void)setEdu:(NSString *)edu;
+ (NSString *)getEdu;
// 微信号
+ (void)setWechatid:(NSString *)wxid;
+ (NSString *)getWechatid;
// 邮箱
+ (void)setEmail:(NSString *)email;
+ (NSString *)getEmail;
// 求职状态
+ (void)setJobStatus:(NSString *)jobstatus;
+ (NSString *)getJobStatus;
// 我的职务
+ (void)setPostName:(NSString *)postName;
+ (NSString *)getPostName;
// 是否需要上传工作认证资料(第一个人上传,以后的都不需要) pcompanyid 1->第一个人;2->成员
+ (void)setCompanyPerson:(NSString *)companyPerson;
+ (NSString *)getCompanyPerson;
// 年龄
//+ (void)setAge:(NSString *)age;
//+ (NSString *)getAge;
// 工作年份
//+ (void)setWorking:(NSString *)working;
//+ (NSString *)getWorking;
// 执照类别
//+ (void)setLicense:(NSString *)license;
//+ (NSString *)getLicense;

#pragma mark - 状态
// 是否是企业  yes:企业 no:个人
+ (void)setIsCompany:(BOOL)authCompany;
+ (BOOL)getIsCompany;

// 认证状态approve 1、认证；2、未认证；3、审核中
+ (void)setRealAuth:(NSString *)realAuth;
+ (NSString *)getRealAuth;

////急速求职状态 1、未开通; 2、开通
+ (void)setRapidAuth:(NSString *)rapidAuth;
+ (NSString *)getRapidAuth;
//+(void)setIsRapid:(BOOL)rapid;
//+(BOOL)getRapid;

// 人才认证状态person_approve 1、认证；2、未认证；3、审核中
//+ (void)setPersonAuth:(NSString *)personAuth;
//+ (NSString *)getPersonAuth;

// 接单状态work_status  0暂停接单，1接单中
//+ (void)setWorkStatus:(NSString *)workStatus;
//+ (NSString *)getWorkStatus;

/********  保存用户本地设置数据  *******/
#pragma mark - 设置声音状态
+ (NSString *)soundStatus;
+ (void)setSoundStatus:(NSString *)status;
#pragma mark - 设置振动状态
+ (NSString *)vibrationStatus;
+ (void)setVibrationStatus:(NSString *)status;
@end
