//
//  ModelConst.h
//  mylweibo
//
//  Created by myl on 15-4-25.
//  Copyright (c) 2015年 myl. All rights reserved.
//  网络访问相关的宏

#ifndef Meeting_ModelConst_h

///网络访问的标示符
#define STATUS          @"status"
#define INFO            @"info"
#define CODE            @"code"
#define SUCCESS         @"100001"
#define MSG             @"msg"
#define DATA            @"data"
#define KPageSize       @"10"


#define kInterfaceVersion @"3.0"

////测试
////图片拼接url
//#define ImageURL @"http://39.106.152.66/data/upload/"
////外网
//#define BaseURL @"http://39.106.152.66/app"
//// h5 链接
//#define H5BaseURL @"http://39.106.152.66"


//正式d
//图片拼接url
#define ImageURL @"https://hr-ez.com/data/upload/"
//外网
#define BaseURL @"https://hr-ez.com/app"
// h5 链接
#define H5BaseURL @"https://hr-ez.com"

////上传图片
//#define UploadImageURL @"http://upload.kbird.top/index.php"

//加密key
//#define KEYSTR @"Ign3~rM41xRZs?`AO-[#Fmuck+9Ej>fN<Q;Vh$T"





/// 手机号登录
#define EZPhoneLogin @"/login/phone_login"
/// 获取token
#define EZGetToken @"/token/getToken"
/// 获取验证码
#define EZGetVCode @"/sms/send_code"
#pragma mark - start简历管理

/// 获取所有行业
#define EZGetHoptrade @"/resume/hoptrade"
/// 获取职位类型
#define EZGetPositionclass @"/position/getpositionclass"
/// 添加期望职位
#define EZAddhopwork @"/resume/addhopwork"
/// 保存修改期望职位
#define EZSavehopwork @"/resume/savework"
/// 删除期望职位
#define EZDeletehopwork @"/resume/deletehopwork"
/// 获取已添加的期望职位
#define EZGethopwork @"/resume/hoprwork"
/// 保存求职状态
#define EZSaveRestatus @"/resume/saverestatus"
/// 获取简历详情
#define EZGetResumeDetail @"/resume/resumedetail"
/// 添加工作经历
#define EZAddWork @"/resume/addwork"
/// 保存编辑工作经历
#define EZSaveEditWork @"/resume/saveeditwork"
/// 保存编辑工作经历
#define EZDeleteWork @"/resume/deletework"
/// 添加教育经历
#define EZAddEdu @"/resume/addedu"
/// 保存教育经历
#define EZSaveEdu @"/resume/saveedu"
/// 删除教育经历
#define EZDeleteEdu @"/resume/deleteedu"
/// 添加项目经验
#define EZAddProject @"/resume/addproject"
/// 保存项目经验
#define EZSaveProject @"/resume/saveproject"
/// 删除项目经验
#define EZDeleteProject @"/resume/deleteproject"
/// 保存自我描述
#define EZSaveDesc @"/resume/savedesc"

#pragma mark end简历管理

#pragma mark - start我的
/// 关注职位列表
#define EZFollowJobList @"/member/payposition"
/// 面试记录列表
#define EZInterviewJobList @"/delivery/mydelivery"
/// 印象评价(人才评价企业)
#define EZImpressionEvaluate @"/delivery/firstimpression"
/// 白名单查询
#define EZQueryWhiteList @"/member/queryuser"
/// 白名单添加
#define EZAddWhiteList @"/member/addwhile"
/// 白名单删除
#define EZDeleteWhiteList @"/member/dewlwhile"
/// 白名单列表
#define EZWhiteList @"/member/whilelist"
/// 人才投递记录列表 //1、人才直投；2、hr推荐
//#define EZDeliverRemuse @"/resume/deliver"
#define EZDeliveryRecordList @"/delivery/personneldelivery"
/// 修改简历状态
#define EZChangeResumeState @"/delivery/changedealwith"
/// 同意/拒绝面试
#define EZInterviewOperation @"/delivery/refusetoinvite"
/// 发送面试邀请
#define EZSendInterview @"/company/interviewrecard"
/// 面试详情
#define EZInterviewDetail @"/delivery/seedelivery"
/// 订单列表
#define EZOrderLists @"/company/orderlists"
/// 订单分期列表
#define EZOrderBystagesList @"/company/getorderlist"
/// 账户余额
#define EZAccountBalance @"/ordermanage/balance"
/// 充值
#define EZAccountRecharge @"/company/rechargeconsultant"
/// 获取e豆列表
#define EZEdouList @"/company/getcoins"
/// 举报用户
#define EZReportUser @"/usersetting/inform"
/// 用户余额提现
#define EZBalanceWithdrawals @"/ordermanage/withdrawals"
/// 提现记录
//#define EZWithDrawalsList @"/share/withdrawals"
#define EZWithDrawalsList @"/share/paydetal"
/// 发送验证码
#define EZSendCode @"/sms/send_codes"
/// 修改手机号码第一步，验证旧的手机号
#define EZVChangePhone @"/usersetting/chekoldphone"
/// 修改手机号码第二步，设置新的手机号码
#define EZChangePhone @"/usersetting/setnewphone"
/// 意见反馈
#define EZFeedback @"/feedback/feedback_add"
/// 人才实名认证
#define EZPersonalAuth @"/member/setapprove"
/// 版本更新
#define EZCheckVersion @"/member/getversion"
/// 获取用户信息
#define EZGetUserInfo @"/member/userinfo"
/// 获取站内信
#define EZSitemsg @"/message/pushmessage"
/// 每日E招推荐
#define EZStickposition @"/position/stickposition"
#pragma mark end我的

#pragma mark - start用户管理
/// 用户设置
#define EZUserSetting @"/usersetting/user_setting"
/// 用户头像上传
#define EZUploadHeadImg @"/uploadimg/upload_file"
/// 多图上传
#define EZUploadMroeImg @"/uploadimg/upload_case_img"

#pragma mark end用户管理

#pragma mark - start发现

/// 发现列表
#define EZDiscoverGetNewList @"/protal/getnewlist"
/// 职场/合伙人列表
#define EZDiscoverGetTopicList @"/topic/topicList"
/// 发布话题
#define EZDiscoverTopicRelease @"/topic/addtitle"
/// 点赞话题
#define EZDiscoverPraise @"/topic/praisetopic"
/// 评论话题
#define EZDiscoverComment @"/topic/addtopic"
/// 给评论点赞
#define EZDiscoverCommentPraise @"/topic/praisecomment"
/// 分享话题
#define EZDiscoverShare @"/topic/sharetopic"
/// 删除话题
#define EZDiscoverDelete @"/topic/deltopic"
/// 删除评论
#define EZDiscoverDeleteComment @"/topic/deltopiccomment"
/// 话题详情
#define EZDiscoverTopicDetail @"/topic/topicdetail"
/// 话题阅读次数
//#define EZDiscoverTopicRead @""
/// 发现页-轮播
#define EZDiscoverSlidelist @"/message/slidelist"
/// 发现页-活动类型
#define EZDiscoverActivitytype @"/message/activitytype"
/// 发现页-活动列表
#define EZDiscoverActivitylist @"/message/activitylist"
///APP活动内容
#define EZGetAllactices @"/message/getAllactices"

#pragma mark end发现

#pragma mark - 职位

/// 获取职位列表
#define EZHomeGetPositionList @"/position/positionList"
/// 获取职位详情
#define EZHomeGetPositionDetail @"/position/positiondelate"
/// 关注职位
#define EZHomeGetPositionFollow @"/position/payposition"
/// 个人详情页
#define EZHomeMemberDetail @"/position/memberdetail"
/// 公司详情页
#define EZHomeCompanyDetail @"/position/companydetail"

#pragma mark end职位

#pragma mark - start共享HR
/// HR首页
#define EZHRRecommendList @"/share/yrecommend"
/// 获取推荐人才适合的职位列表
#define EZHRRecommendPersonList @"/share/listrecommend"
/// 把XX推荐给XX
#define EZHRRecommend @"/share/successrecom"

#pragma mark end共享HR


/****  企业接口 ****/
#pragma mark - 企业
#pragma mark - 企业中心

/// 企业信息
#define EZCompanyCenter @"/company/selfinfo"
/// 修改企业信息
#define EZChangePersonInfo @"/company/updateinfo"
/// 企业认证
#define EZCompanyAuth @"/company/authentication"
/// 修改认证状态
#define EZCheckAuth @"/company/checkauthentication"
/// 企业发布的职位列表
#define EZGetCPositionList @"/company/position"
/// 发布职位
#define EZReleasePosition @"/company/positioninfo"
/// 保存编辑职位
#define EZSaveEditPosition @"/company/editposidtion"
/// 删除职位
#define EZDeletePosition @"/company/deleteposition"
/// 改变职位状态
#define EZChangePositionStatus @"/company/positionstatus"
/// 首页人才列表
//#define EZCPersonnelList @"/company/personnel"
//首页接口更换，其他都不换
#define EZCPersonnelList @"/company/personnelnew"
/// 企业关注人才列表
#define EZCFollowPersonList @"/member/paymember"
/// 企业关注人才
#define EZCFollowPerson @"/company/attentiontalent"
/// 人才直投列表
#define EZCResumeDeliverList @"/company/allresumes"
/// HR推荐列表
#define EZCResumeRecommendList @"/ordermanage/orderlist"
/// 企业首页--搜索
#define EZCompanySearch @"/company/secondsearch"
/// 付费查看电话号
#define EZPayEdou @"/company/ecoin"
/// 企业对HR评分
#define EZCompanyScore @"/company/hrscore"

/// 公司成员列表
#define EZCompanyMemberList @"/company/conpanymember"
/// 添加公司成员
#define EZAddCompanyMember @"/company/binding"
/// 删除公司成员
#define EZDeleteCompanyMember @"/company/deletecompanymem"
/// 搜索成员
#define EZSearchCompanyMember @"/company/getmember"
/// 与公司解绑
#define EZCompanyUnbundling @"/company/unbundling"
//企业是否获取人才联系方式
#define EZGetpersonalphone @"/member/getpersonalphone"
//消耗30e豆
#define EZSetdecedou @"/member/setdecedou"
//保存编辑的认证信息
#define EZSeteditorapprove @"/company/seteditorapprove"
//分享接口
#define EZNewRecrui @"/index/newrecrui.html?uid="

#pragma mark end企业中心
// 接口统一
#define EZAppid @"10001"
#define EZSecret @"A2lXdKQJEOnq"

#pragma mark - 推送通知
#define myMessage @"messageNotity" /**< 推送通知 */

#pragma mark - 登录过期通知
#define kLoginOverdue @"loginOverdue" /**< 登录过期通知 */

#endif
