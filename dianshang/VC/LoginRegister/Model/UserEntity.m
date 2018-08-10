//
//  UserEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/9/19.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "UserEntity.h"
#import "YQSaveManage.h"

@implementation UserEntity

#pragma mark - token

// token
+ (void)setToken:(NSString *)token
{
    [YQSaveManage setObject:token forKey:LTOKEN];
}
+ (NSString *)getToken
{
    return [YQSaveManage objectForKey:LTOKEN];
}

#pragma mark - 用户基本信息

+ (NSDictionary *)handerDic:(NSDictionary *)dic
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSNull *abcd = [[NSNull alloc] init];
    for (NSString *key in dic) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }else if (value == nil) {
            value = @"";
        }else if ([value isEqual:abcd]){
            value = @"";
        }else if ([value isKindOfClass:[NSDictionary class]]){
            value = [UserEntity handerDic:value];
        }
        NSString *keykey = key;
        if ([keykey isEqualToString:@"id"]) {
            keykey = @"uid";
        }
        [mDic setObject:value forKey:keykey];
    }
    return mDic;
}

+ (void)setUserInfo:(NSDictionary *)dic
{
    [YQSaveManage setObject:[UserEntity handerDic:dic] forKey:USERINFO];
}
+ (NSDictionary *)userInfo
{
    return [YQSaveManage objectForKey:USERINFO];
}


+ (void)setRealname:(NSString *)realname
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:realname forKey:@"realname"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getRealname
{
    return [[UserEntity userInfo] objectForKey:@"realname"];
}

// 获取认证资料
+ (NSDictionary *)getCertificate
{
    return [[UserEntity userInfo] objectForKey:@"certificate"];
}
// id
+ (NSString *)getUid
{
    return [[UserEntity userInfo] objectForKey:@"uid"];
}
// cid公司ID
+ (NSString *)getCompanyId
{
    return [[UserEntity userInfo] objectForKey:@"companyid"];
}
// 头像URL
+ (void)setHeadImgUrl:(NSString *)headImgUrl
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:headImgUrl forKey:@"avatar"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getHeadImgUrl
{
    NSString *str = [[UserEntity userInfo] objectForKey:@"avatar"];
    if ([str isEqualToString:@""] || str == nil) {
        return @"headImg";
    }
    return [NSString stringWithFormat:@"%@%@",ImageURL,str];
}
// 昵称
+ (void)setNickName:(NSString *)nickName
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:nickName forKey:@"name"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getNickName
{
    return [[UserEntity userInfo] objectForKey:@"name"];
}
// 华信姓名标识
+ (void)setHXUserName:(NSString *)userName
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:userName forKey:@"hx_username"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getHXUserName
{
    return [[UserEntity userInfo] objectForKey:@"hx_username"];
}
// 余额
+ (void)setBalance:(NSString *)balance
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:balance forKey:@"money"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getBalance
{
    return [[UserEntity userInfo] objectForKey:@"money"];
}
// 用户e豆
+ (void)setEdou:(NSString *)edou
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:edou forKey:@"coin"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getEdou
{
    return [[UserEntity userInfo] objectForKey:@"coin"];
}
// 冻结余额
+ (void)setFrozenBalance:(NSString *)balance
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:balance forKey:@"frozen"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getFrozenBalance
{
    return [[UserEntity userInfo] objectForKey:@"frozen"];
}

// 简介
+ (void)setSynopsis:(NSString *)synopsis
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:synopsis forKey:@"introduction"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getSynopsis
{
    return [[UserEntity userInfo] objectForKey:@"introduction"];
}
// 手机号
+ (void)setPhone:(NSString *)phone
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:phone forKey:@"phone"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getPhone
{
    return [[UserEntity userInfo] objectForKey:@"phone"];
}
// 工作年份
+ (void)setWorkyear:(NSString *)year
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:year forKey:@"workyear"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getWorkyear
{
    return [[UserEntity userInfo] objectForKey:@"workyear"];
}
// 性别
+ (void)setSex:(NSString *)sex
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:sex forKey:@"sex"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getSex
{
    return [[UserEntity userInfo] objectForKey:@"sex"];
}
// 生日
+ (void)setBrithDay:(NSString *)brithDay
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:brithDay forKey:@"birthday"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getBrithDay
{
    return [[UserEntity userInfo] objectForKey:@"birthday"];
}
// 学历
+ (void)setEdu:(NSString *)edu
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:edu forKey:@"edu"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getEdu
{
    return [[UserEntity userInfo] objectForKey:@"edu"];
}
// 微信号
+ (void)setWechatid:(NSString *)wxid
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:wxid forKey:@"wechatid"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getWechatid
{
    return [[UserEntity userInfo] objectForKey:@"wechatid"];
}
// 邮箱
+ (void)setEmail:(NSString *)email
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:email forKey:@"email"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getEmail
{
    return [[UserEntity userInfo] objectForKey:@"email"];
}
// 求职状态
+ (void)setJobStatus:(NSString *)jobstatus
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:jobstatus forKey:@"restatus"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getJobStatus
{
    return [[UserEntity userInfo] objectForKey:@"restatus"];
}
+ (void)setPostName:(NSString *)postName
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:postName forKey:@"post"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getPostName
{
    return [[UserEntity userInfo] objectForKey:@"post"];
}
// 是否需要上传工作认证资料(第一个人上传,以后的都不需要) pcompanyid 1->第一个人;2->成员
+ (void)setCompanyPerson:(NSString *)companyPerson
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:companyPerson forKey:@"pcompanyid"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getCompanyPerson
{
    return [[UserEntity userInfo] objectForKey:@"pcompanyid"];
}
// 年龄
+ (void)setAge:(NSString *)age
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:age forKey:@"age"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getAge
{
    return [[UserEntity userInfo] objectForKey:@"age"];
}
// 工作年份
+ (void)setWorking:(NSString *)working
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:working forKey:@"working"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getWorking
{
    return [[UserEntity userInfo] objectForKey:@"working"];
}
// 执照类别
+ (void)setLicense:(NSString *)license
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:license forKey:@"license"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getLicense
{
    return [[UserEntity userInfo] objectForKey:@"license"];
}
// 统一社会信用代码
// 面试时间
// 增值税20%
#pragma mark - 状态
// 是否是企业  yes:企业 no:个人
+ (void)setIsCompany:(BOOL)authCompany
{
    NSString *state = authCompany ? @"2" : @"1";
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:state forKey:@"check"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (BOOL)getIsCompany
{
    NSString *state = [[UserEntity userInfo] objectForKey:@"check"];
    NSLog(@"1     %@",state);
    return [state isEqualToString:@"2"];
}

////是否开通急速联系 yes：开通 no：未开通
+ (void)setRapidAuth:(NSString *)rapidAuth {
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:rapidAuth forKey:@"isfast"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}

+ (NSString *)getRapidAuth {
    NSString *str = [[UserEntity userInfo] objectForKey:@"isfast"];
    if ([str isEqualToString:@"0"] || [str isEqualToString:@""] || str == nil) {
        return @"1";
    }
    return [[UserEntity userInfo] objectForKey:@"isfast"];
}

//+ (void)setIsRapid:(BOOL)rapid {
//    NSString *state = rapid ? @"2" : @"1";
//    NSDictionary *dic = [UserEntity userInfo];
//    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
//    [mdic setObject:state forKey:@"isfast"];
//    [YQSaveManage setObject:mdic forKey:USERINFO];
//}
//
//+ (BOOL)getRapid {
//    NSString *rapid = [[UserEntity userInfo] objectForKey:@"isfast"];
//    NSLog(@"2      %@",rapid);
//    return [rapid isEqualToString:@"2"];
//}

// 认证状态approve 1、认证；2、未认证；3、审核中
+ (void)setRealAuth:(NSString *)realAuth
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:realAuth forKey:@"approve"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getRealAuth
{
    NSString *str = [[UserEntity userInfo] objectForKey:@"approve"];
    if ([str isEqualToString:@"0"] || [str isEqualToString:@""] || str == nil) {
        return @"2";
    }
    return [[UserEntity userInfo] objectForKey:@"approve"];
}

// 人才认证状态person_approve 1、认证；2、未认证；3、审核中
+ (void)setPersonAuth:(NSString *)personAuth
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:personAuth forKey:@"person_approve"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getPersonAuth
{
    return [[UserEntity userInfo] objectForKey:@"person_approve"];
}
// 接单状态work_status
+ (void)setWorkStatus:(NSString *)workStatus
{
    NSDictionary *dic = [UserEntity userInfo];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:workStatus forKey:@"work_status"];
    [YQSaveManage setObject:mdic forKey:USERINFO];
}
+ (NSString *)getWorkStatus
{
    return [[UserEntity userInfo] objectForKey:@"work_status"];
}

/********  保存用户本地设置数据  *******/
#pragma mark - 设置声音状态
+ (NSString *)soundStatus
{
    NSDictionary *dic = [YQSaveManage objectForKey:PROMPT];
    if (dic == nil) {
        return nil;
    }
    return [dic objectForKey:@"sound"];
}
+ (void)setSoundStatus:(NSString *)status
{
    NSDictionary *dic = [YQSaveManage objectForKey:PROMPT];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:status forKey:@"sound"];
    [YQSaveManage setObject:mdic forKey:PROMPT];
}
#pragma mark - 设置振动状态
+ (NSString *)vibrationStatus
{
    NSDictionary *dic = [YQSaveManage objectForKey:PROMPT];
    if (dic == nil) {
        return nil;
    }
    return [dic objectForKey:@"vibration"];
}

+ (void)setVibrationStatus:(NSString *)status
{
    NSDictionary *dic = [YQSaveManage objectForKey:PROMPT];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setObject:status forKey:@"vibration"];
    [YQSaveManage setObject:mdic forKey:PROMPT];
}

@end
