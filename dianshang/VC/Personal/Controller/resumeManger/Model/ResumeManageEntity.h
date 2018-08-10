//
//  ResumeManageEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResumeManageEntity : NSObject

@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString *appraiseid;
@property (nonatomic, copy) NSString *genre;
@property (nonatomic, copy) NSString *last_login_ip;
@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, copy) NSString *check;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *partner;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *wb;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *explanation;
@property (nonatomic, copy) NSString *last_login_time;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *wx;
@property (nonatomic, copy) NSString *pt;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *informid;

@property (nonatomic, copy) NSString *companyname;//目前公司
@property (nonatomic, copy) NSString *pname;//目前工作
@property (nonatomic, copy) NSString *restatus;//简历状态
@property (nonatomic, copy) NSString *hx_username;
@property (nonatomic, copy) NSString *year;// 现在-工作年份=工作年限
@property (nonatomic, copy) NSString *workStr;// 现在-工作年份=工作年限
@property (nonatomic, copy) NSString *wechatid;// 微信号
@property (nonatomic, copy) NSString *birthday;//生日
@property (nonatomic, copy) NSString *age;//年龄
@property (nonatomic, copy) NSString *phone;//手机号
@property (nonatomic, copy) NSString *desc;//简介
@property (nonatomic, copy) NSString *uid;//用户id
@property (nonatomic, copy) NSString *sex;//性别
@property (nonatomic, copy) NSString *email;//邮箱
@property (nonatomic, copy) NSString *name;//姓名
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *edu;//学历
@property (nonatomic, copy) NSString *workyear;// 工作年份

@property (nonatomic, copy) NSString *is_asset;// 是否上传过简历附件1上传2未上传
// 简历附件信息
@property (nonatomic, copy) NSDictionary *asset;

// 教育经历
@property (nonatomic, copy) NSMutableArray *edus;
// 工作经历
@property (nonatomic, copy) NSMutableArray *work;
// 项目经验
@property (nonatomic, copy) NSMutableArray *project;
// 期望工作
@property (nonatomic, copy) NSMutableArray *working;

+ (instancetype)ResumeManageEntityWithDict:(NSDictionary *)dict;

@end

// 工作经历/项目经验/教育经历
@interface ResumeManageSubEntity : NSObject


@property (nonatomic, copy) NSString *itemId;//这条信息的唯一id
@property (nonatomic, copy) NSString *status;//
@property (nonatomic, copy) NSString *createtime;//
@property (nonatomic, copy) NSString *updatetime;//
//项目经验
@property (nonatomic, copy) NSString *pname;//项目名
@property (nonatomic, copy) NSString *duty;//职责
@property (nonatomic, copy) NSString *starttime;//开始时间
@property (nonatomic, copy) NSString *endtime;//结束时间
@property (nonatomic, copy) NSString *starttimeStr;//开始时间
@property (nonatomic, copy) NSString *endtimeStr;//结束时间
@property (nonatomic, copy) NSString *describetion;//项目描述
@property (nonatomic, copy) NSString *url;//项目url
//工作经历
@property (nonatomic, copy) NSString *companyname;//公司名
@property (nonatomic, copy) NSString *position;//职位
@property (nonatomic, copy) NSString *entrytime;//开始时间
@property (nonatomic, copy) NSString *leavetime;//结束时间
@property (nonatomic, copy) NSString *entrytimeStr;//开始时间
@property (nonatomic, copy) NSString *leavetimeStr;//结束时间
@property (nonatomic, copy) NSString *content;//工作内容
//教育经历
@property (nonatomic, copy) NSString *schoolname;//学习名
@property (nonatomic, copy) NSString *major;//专业
@property (nonatomic, copy) NSString *graduate;//毕业时间
@property (nonatomic, copy) NSString *entrancetime;//入校时间
@property (nonatomic, copy) NSString *graduateStr;//毕业时间
@property (nonatomic, copy) NSString *entrancetimeStr;//入校时间
@property (nonatomic, copy) NSString *edu;//学历
@property (nonatomic, copy) NSString *experience;//学校经历

+ (instancetype)ResumeManageSubEntityWithDict:(NSDictionary *)dict;

@end
