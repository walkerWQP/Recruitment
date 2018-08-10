//
//  RequestManager.h
//  mobilely
//
//  Created by Victoria on 15/1/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRequest.h"

@interface RequestManager : NSObject


/**
 *  初始化RequestManager的一个单例
 *
 *  @return RequestManager的一个单例
 */
+(id) sharedRequestManager;

/// 获取Token
- (void)getToken_success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;

/// 登录
- (void)login_uPhone:(NSString *)phone
             smsCode:(NSString *)code
                type:(NSString *)type   
             success:(successBlock)successBlock
             failure:(failureBlock)failureBlock;

/// 发送手机验证码
- (void)sendCode_mobile:(NSString *)mobile
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock;


#pragma mark - start简历管理

// 获取行业列表
- (void)getExpectIndustry_uid:(NSString *)uid
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;
// 获取职位类型列表
- (void)getJobPosition_uid:(NSString *)uid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock;
// 期望职位  期望职位id(workId)有值保存无值添加
- (void)addHopwork_uid:(NSString *)uid
                workId:(NSString *)workId
       positionClassid:(NSString *)position_classid
                 genre:(NSString *)genre
                  city:(NSString *)city
                 trade:(NSString *)trade
                salary:(NSString *)salary
           explanation:(NSString *)explanation
                isfast:(NSString *)isfast
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;
// 删除期望职位
- (void)deletehopwork_uid:(NSString *)uid
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock;
// 保存求职状态
- (void)saveRestatus_uid:(NSString *)uid
                restatus:(NSString *)restatus
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;
// 获取期望职位
- (void)gethopwork_uid:(NSString *)uid
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;
// 获取简历详情
- (void)getResumeDetail_uid:(NSString *)uid
                       puid:(NSString *)puid
                       type:(NSString *)type
                hx_username:(NSString *)hx_username
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;

// 工作经历  工作经历id(workId)有值保存无值添加
- (void)addWork_uid:(NSString *)uid
             workId:(NSString *)workId
        companyname:(NSString *)companyname
           position:(NSString *)position
          entrytime:(NSString *)entrytime
          leavetime:(NSString *)leavetime
            content:(NSString *)content
            success:(successBlock)successBlock
            failure:(failureBlock)failureBlock;
// 删除工作经历
- (void)deleteWork_uid:(NSString *)uid
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;
// 教育经历  教育经历id(eduId)有值保存无值添加
- (void)addEdu_uid:(NSString *)uid
             eduId:(NSString *)eduId
        schoolname:(NSString *)schoolname
             major:(NSString *)major
      entrancetime:(NSString *)entrancetime
          graduate:(NSString *)graduate
               edu:(NSString *)edu
        experience:(NSString *)experience
           success:(successBlock)successBlock
           failure:(failureBlock)failureBlock;
// 删除教育经历
- (void)deleteEdu_uid:(NSString *)uid
              success:(successBlock)successBlock
              failure:(failureBlock)failureBlock;
// 项目经验  项目经验id(projectId)有值保存无值添加
- (void)addProject_uid:(NSString *)uid
             projectId:(NSString *)projectId
                 pname:(NSString *)pname
                  duty:(NSString *)duty
             starttime:(NSString *)starttime
               endtime:(NSString *)endtime
          describetion:(NSString *)describetion
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;
// 删除项目经验
- (void)deleteProject_uid:(NSString *)uid
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock;
// 保存自我描述
- (void)saveDescription_uid:(NSString *)uid
                description:(NSString *)description
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;
//APP活动内容
- (void)getAllactices:(NSString *)type
              success:(successBlock)successBlock
              failure:(failureBlock)failureBlock;

#pragma mark end简历管理

#pragma mark - start用户管理
// 用户设置
- (void)userSetting_uid:(NSString *)uid
                  phone:(NSString *)phone
                 avatar:(NSString *)avatar
                   name:(NSString *)name
                    sex:(NSString *)sex
               birthday:(NSString *)birthday
               wechatid:(NSString *)wechatid
               restatus:(NSString *)restatus
                    edu:(NSString *)edu
                   year:(NSString *)year
               workyear:(NSString *)workyear
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock;
// 上传头像
- (void)uploadImage_uid:(NSString *)uid
                headimg:(NSData *)headimg
          progressBlock:(progressBlock)progressBlock
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock;
// 多图上传
- (void)uploadImage_uid:(NSString *)uid
               imageArr:(NSArray *)imageArr
          progressBlock:(progressBlock)progressBlock
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock;

#pragma mark end用户管理
#pragma mark - 发现
/// 发现职场列表
- (void)getDiscoverNewList_uid:(NSString *)uid
                          page:(NSString *)page
                      pagesize:(NSString *)pagesize
                          type:(NSString *)type
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock;
/// 职场/合伙人列表
- (void)getDiscoverTopicList_uid:(NSString *)uid
                            page:(NSString *)page
                        pagesize:(NSString *)pagesize
                       isdefault:(NSString *)isdefault
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock;
/// 话题发布
- (void)discoverTopicRelease_uid:(NSString *)uid
                           title:(NSString *)title
                        describe:(NSString *)describe
                       isdefault:(NSString *)isdefault
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock;
/// 点赞话题
- (void)discoverPraiseTopic_uid:(NSString *)uid
                            tid:(NSString *)tid
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;
/// 评论话题
- (void)discoverCommentTopic_uid:(NSString *)uid
                             tid:(NSString *)tid
                            desc:(NSString *)desc
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock;
/// 给评论点赞
- (void)discoverCommentPraise_uid:(NSString *)uid
                              tid:(NSString *)tid
                              cid:(NSString *)cid
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock;
/// 分享话题
- (void)discoverShareTopic_uid:(NSString *)uid
                           tid:(NSString *)tid
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock;
/// 删除话题
- (void)discoverDeleteTopic_uid:(NSString *)uid
                            tid:(NSString *)tid
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;
/// 删除评论
- (void)discoverDeleteComment_uid:(NSString *)uid
                              cid:(NSString *)cid
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock;
/// 话题详情
- (void)discoverTopicDetail_uid:(NSString *)uid
                            tid:(NSString *)tid
                           page:(NSString *)page
                       pagesize:(NSString *)pagesize
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;

#pragma mark end发现

#pragma mark - 职位

/// 获取职位列表
- (void)homeGetPositionList_uid:(NSString *)uid
                           page:(NSString *)page
                       pagesize:(NSString *)pagesize
                      recommend:(NSString *)recommend
                           city:(NSString *)city
                           area:(NSString *)area
                          scale:(NSString *)scale
                         cvedit:(NSString *)cvedit
                        tradeid:(NSString *)tradeid
                            edu:(NSString *)edu
                      exprience:(NSString *)exprience
                            pay:(NSString *)pay
                          pname:(NSString *)pname
                           name:(NSString *)name
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;
/// 每日E招推荐
- (void)getStickPositionList_uid:(NSString *)uid
                            city:(NSString *)city
                            page:(NSString *)page
                        pagesize:(NSString *)pagesize
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock;
/// 获取职位详情
- (void)homeGetPositionDetail_uid:(NSString *)uid
                              pid:(NSString *)pid
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock;

/// 关注职位  attention(1表示关注，2表示取消关注)
- (void)homeGetPositionFollow_uid:(NSString *)uid
                       positionid:(NSString *)positionid
                             puid:(NSString *)puid
                        attention:(NSString *)attention
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock;
/// 个人详情页
- (void)homeMemberDetail_uid:(NSString *)uid
                        puid:(NSString *)puid
                 hx_username:(NSString *)hx_username
                        type:(NSString *)type
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
/// 公司详情页
- (void)homeCompanyDetail_uid:(NSString *)uid
                         mid:(NSString *)mid
                   companyid:(NSString *)companyid
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
#pragma mark end职位

#pragma mark - start共享HR
/// HR首页
/// HR推荐列表  //type 1、可推荐；2、待面试；3、已面试；4、已入职；5、已转正
- (void)getHRRecommendList_uid:(NSString *)uid
                          type:(NSString *)type
                          page:(NSString *)page
                      pagesize:(NSString *)pagesize
                         pname:(NSString *)pname
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock;

/// 获取推荐人才适合的职位列表  rid 被推荐人id
- (void)getHRRecommendPersonList_uid:(NSString *)uid
                                 rid:(NSString *)rid
                           posi_name:(NSString *)posi_name
                                city:(NSString *)city
                                page:(NSString *)page
                            pagesize:(NSString *)pagesize
                             success:(successBlock)successBlock
                             failure:(failureBlock)failureBlock;
/// 把XX推荐给XX
- (void)getHRRecommend_uid:(NSString *)uid
                       pid:(NSString *)pid
                      type:(NSString *)type
                      puid:(NSString *)puid
                   shareid:(NSString *)shareid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock;

#pragma mark end共享HR

#pragma mark - start我的

/// 获取关注职位列表
- (void)getFollowJobList_uid:(NSString *)uid
                        page:(NSString *)page
                    pagesize:(NSString *)pagesize
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;

/// 面试记录列表  //dealwith面试状态（1表示待面试，2表示已面试，3表示已入职，4表示已转正，5、已离职，6、未面试，7、拒绝企业邀请）
- (void)getInterviewJobList_uid:(NSString *)uid
                       dealwith:(NSString *)dealwith
                           page:(NSString *)page
                       pagesize:(NSString *)pagesize
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;

/**
 印象评价(人才评价企业)
 
 @param uid 用户id
 @param posid 职位id
 @param puid 发布职位者id
 @param type 人才打分时状态（1、第一印象打分；2、在职打分；3、离职打分）
 */
- (void)impressionEvaluate_uid:(NSString *)uid
                         posid:(NSString *)posid
                          puid:(NSString *)puid
                          type:(NSString *)type
                    firstgrade:(NSString *)firstgrade
                     firstinfo:(NSString *)firstinfo
                        office:(NSString *)office
                       culture:(NSString *)culture
                          care:(NSString *)care
                      benefits:(NSString *)benefits
                     prospects:(NSString *)prospects
                    leavegrade:(NSString *)leavegrade
                     leaveinfo:(NSString *)leaveinfo
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock;

/// 白名单查询
- (void)whiteListQuery_uid:(NSString *)uid
                     phone:(NSString *)phone
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock;
/// 白名单添加
- (void)whiteListAdd_uid:(NSString *)uid
                     wid:(NSString *)wid
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;
/// 白名单删除
- (void)whiteListDelete_uid:(NSString *)uid
                     itemid:(NSString *)itemid
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;
/// 白名单列表
- (void)getWhiteList_uid:(NSString *)uid
                    page:(NSString *)page
                pagesize:(NSString *)pagesize
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;
/// 人才投递记录列表  type 1、人才直投；2、hr推荐
- (void)getDeliveryRecordList_uid:(NSString *)uid
                             type:(NSString *)type
                             page:(NSString *)page
                         pagesize:(NSString *)pagesize
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock;
/// 修改简历状态 // 4、已面试不合适；5、已面试待入职（已面试合适）；6、已入职待转正；7、已转正；8、已离职
- (void)changeResumeState_uid:(NSString *)uid
                          mid:(NSString *)mid
                      orderid:(NSString *)orderid
                     dealwith:(NSString *)dealwith
                    redpacket:(NSString *)redpacket
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;
/// 同意/拒绝面试 1、通过；2、拒绝
- (void)interviewOperation_uid:(NSString *)uid
                       orderid:(NSString *)orderid
                          type:(NSString *)type
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock;
/// 发送面试邀请
- (void)sendInterview_uid:(NSString *)uid
                      rid:(NSString *)rid
                      pid:(NSString *)pid
                      mid:(NSString *)mid
                  orderid:(NSString *)orderid
                     date:(NSString *)date
                  address:(NSString *)address
                 describe:(NSString *)describe
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock;
/// 面试详情 type 1、企业端；2、人才端
- (void)interviewDetail_uid:(NSString *)uid
                    orderid:(NSString *)orderid
                       type:(NSString *)type
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;
///// 人才简历--投递
//- (void)deliverRemuse_uid:(NSString *)uid
//                      pid:(NSString *)pid
//                  success:(successBlock)successBlock
//                  failure:(failureBlock)failureBlock;
/// 订单列表
- (void)recommendOrderList_uid:(NSString *)uid
                         pname:(NSString *)pname
                          type:(NSString *)type
                          page:(NSString *)page
                      pagesize:(NSString *)pagesize
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock;
/// 订单分期列表
- (void)recommendOrderBystagesList_uid:(NSString *)uid
                              ordernum:(NSString *)ordernum
                               success:(successBlock)successBlock
                               failure:(failureBlock)failureBlock;
/// 获取账户余额
- (void)getAccountBalance_uid:(NSString *)uid
                         type:(NSString *)type
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;
/// e豆列表
- (void)getEdoulist_uid:(NSString *)uid
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;
/// 充值
- (void)accountRecharge_uid:(NSString *)uid
                   ordernum:(NSString *)ordernum
                      money:(NSString *)money
                       type:(NSString *)type
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;
/// 红包充值
- (void)redpacketRecharge_uid:(NSString *)uid
                     ordernum:(NSString *)ordernum
                        money:(NSString *)money
                         type:(NSString *)type
                          ext:(NSDictionary *)ext
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;
/// 聊天是举报对方
- (void)chatReportUser_uid:(NSString *)uid
                      ruid:(NSString *)ruid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock;

/// 用户余额提现  mstatus提现人身份（1、个人 2、企业）
- (void)balanceWithdrawals_uid:(NSString *)uid
                       mstatus:(NSString *)mstatus
                        alipay:(NSString *)alipay
                         money:(NSString *)money
                          code:(NSString *)code
                    alipayname:(NSString *)alipayname
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock;
/// 提现记录
- (void)withdrawalsList_uid:(NSString *)uid
                       type:(NSString *)type
                       page:(NSString *)page
                   pagesize:(NSString *)pagesize
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;

/// 发送验证码
- (void)sendCode_phone:(NSString *)mobile
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;

/// 修改手机号码第一步，验证旧的手机号
- (void)vChangePhone_uid:(NSString *)uid
                  mobile:(NSString *)mobile
                    code:(NSString *)code
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;
/// 修改手机号码第二步，设置新的手机号码
- (void)changePhone_uid:(NSString *)uid
                 mobile:(NSString *)mobile
                   code:(NSString *)code
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock;
/// 意见反馈
- (void)feedback_uid:(NSString *)uid
              phones:(NSString *)phones
             message:(NSString *)message
             success:(successBlock)successBlock
             failure:(failureBlock)failureBlock;

/// 人才实名认证
- (void)personalAuth_uid:(NSString *)uid
                truename:(NSString *)truename
                  number:(NSString *)number
              number_top:(NSString *)number_top
           number_bottom:(NSString *)number_bottom
              trueavatar:(NSString *)trueavatar
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;

/// 获取新版本
- (void)getNewVersion:(NSString *)uid
              success:(successBlock)successBlock
              failure:(failureBlock)failureBlock;

- (void)getUserInfo_uid:(NSString *)uid
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock;
/// 获取站内信
- (void)getSitemsg_uid:(NSString *)aid
                  page:(NSString *)page
              pagesize:(NSString *)pagesize
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;

#pragma mark end我的
// 获取活动类型  type 1、企业端；2、人才端
- (void)getActivityType_uid:(NSString *)uid
                       type:(NSString *)type
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;

// 获取活动列表  type 活动类型id
- (void)getActivityList_uid:(NSString *)uid
                       type:(NSString *)type
                       page:(NSString *)page
                   pagesize:(NSString *)pagesize
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;
/// 获取发现轮播  type 1、企业端；2、人才端
- (void)getDiscoverBanner_uid:(NSString *)aid
                         type:(NSString *)type
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;


/****  企业接口 ****/
#pragma mark - 企业
#pragma mark 企业中心

/// 企业信息
- (void)getCPersonCenter_uid:(NSString *)uid
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
// 企业信息修改保存
- (void)changeCPersonInfo_uid:(NSString *)uid
                         name:(NSString *)name
                         post:(NSString *)post
                     wechatid:(NSString *)wechatid
                         team:(NSString *)team
                        email:(NSString *)email
                       avatar:(NSString *)avatar
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;
#pragma mark 认证
// 公司基本信息
- (void)companyAuthBaseInfo_uid:(NSString *)uid
                        cname:(NSString *)cname
                            lat:(NSString *)lat
                            lng:(NSString *)lng
                     province:(NSString *)province
                         city:(NSString *)city
                         area:(NSString *)area
                         logo:(NSString *)logo
                        scale:(NSString *)scale
                       cvedit:(NSString *)cvedit
                         ctag:(NSString *)ctag
                      address:(NSString *)address
                      tradeid:(NSString *)tradeid
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;
/// 修改认证状态
- (void)checkAuthStatus_uid:(NSString *)uid
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;
// 公司介绍
- (void)companyAuthBaseInfo_uid:(NSString *)uid
                            img:(NSString *)img
                           link:(NSString *)link
                    companyinfo:(NSString *)companyinfo
                           team:(NSString *)team
                    productinfo:(NSString *)productinfo
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;
// 公司营业执照
- (void)companyAuthBaseInfo_uid:(NSString *)uid
                        license:(NSString *)license
                    license_num:(NSString *)license_num
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;
// 公司法人身份证件
- (void)companyAuthBaseInfo_uid:(NSString *)uid
                    id_card_num:(NSString *)id_card_num
                    id_card_top:(NSString *)id_card_top
                 id_card_bottom:(NSString *)id_card_bottom
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;

#pragma mark 职位管理

/// 企业发布的职位列表
- (void)getCPositionList_uid:(NSString *)uid
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
/// 发布职位
- (void)releasePosition_uid:(NSString *)uid
                        cid:(NSString *)cid
          position_class_id:(NSString *)position_class_id
                      pname:(NSString *)pname
                        pay:(NSString *)pay
                      skill:(NSString *)skill
                 experience:(NSString *)experience
                        edu:(NSString *)edu
                   pdetails:(NSString *)pdetails
                 consultant:(NSString *)consultant
                  probation:(NSString *)probation
                       city:(NSString *)city
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock;
/// 保存编辑职位
- (void)saveEditPosition_uid:(NSString *)uid
                         pid:(NSString *)pid
               detailAddress:(NSString *)detailAddress
           position_class_id:(NSString *)position_class_id
                       pname:(NSString *)pname
                         pay:(NSString *)pay
                       skill:(NSString *)skill
                  experience:(NSString *)experience
                         edu:(NSString *)edu
                    pdetails:(NSString *)pdetails
                  consultant:(NSString *)consultant
                   probation:(NSString *)probation
                        city:(NSString *)city
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
/// 删除职位
- (void)deletePosition_uid:(NSString *)uid
                       pid:(NSString *)pid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock;
/// 改变职位状态
- (void)changePosition_uid:(NSString *)uid
                       pid:(NSString *)pid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock;
/// 首页人才列表
- (void)getCPersonnelList_uid:(NSString *)uid
                     restatus:(NSString *)restatus
                    recommend:(NSString *)recommend
                        pname:(NSString *)pname
                          pay:(NSString *)pay
                   experience:(NSString *)experience
                          edu:(NSString *)edu
                         city:(NSString *)city
                     pagesize:(NSString *)pagesize
                         page:(NSString *)page
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;
/// 企业关注人才列表
- (void)followPersonList_uid:(NSString *)uid
                        page:(NSString *)page
                    pagesize:(NSString *)pagesize
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
/// 企业关注人才
- (void)followPersonList_uid:(NSString *)uid
                         mid:(NSString *)mid
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
/// 人才直投列表
- (void)getResumeDeliverList_uid:(NSString *)uid
                            type:(NSString *)type
                        pclassid:(NSString *)pclassid
                        dealwith:(NSString *)dealwith
                            page:(NSString *)page
                        pagesize:(NSString *)pagesize
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock;
/// HR推荐列表
- (void)getResumeRecommendList_uid:(NSString *)uid
                              type:(NSString *)type
                          pclassid:(NSString *)pclassid
                          dealwith:(NSString *)dealwith
                              page:(NSString *)page
                          pagesize:(NSString *)pagesize
                           success:(successBlock)successBlock
                           failure:(failureBlock)failureBlock;
/// 企业首页--搜索
- (void)companySearch_uid:(NSString *)uid
                  keyword:(NSString *)keyword
                     work:(NSString *)work
                      edu:(NSString *)edu
                   salary:(NSString *)salary
                 restatus:(NSString *)restatus
                     page:(NSString *)page
                 pagesize:(NSString *)pagesize
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock;

/// 付费查看电话号
- (void)payEdou_uid:(NSString *)uid
         positionid:(NSString *)positionid
               type:(NSString *)type
                sid:(NSString *)sid
            success:(successBlock)successBlock
            failure:(failureBlock)failureBlock;

/// 企业对HR评分
- (void)companyScore_uid:(NSString *)uid
                     rid:(NSString *)rid
                 shareid:(NSString *)shareid
                   grade:(NSString *)grade
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;
/// 公司成员列表
- (void)companyMemberList_uid:(NSString *)uid
                          cid:(NSString *)cid
                         page:(NSString *)page
                     pagesize:(NSString *)pagesize
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;

/// 添加公司成员
- (void)addCompanyMember_uid:(NSString *)uid
                       phone:(NSString *)phone
                        code:(NSString *)code
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
/// 删除公司成员 mid 公司成员id
- (void)deleteCompanyMember_uid:(NSString *)uid
                            mid:(NSString *)mid
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;
/// 搜索成员
- (void)searchCompanyMember_uid:(NSString *)uid
                          phone:(NSString *)phone
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock;
/// 与公司解绑
- (void)companyUnbundling_uid:(NSString *)uid
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock;
//企业获取联系人电话
- (void)getPersonalPhone_uid:(NSString *)uid
                 hx_username:(NSString *)hx_username
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;
//急速联系：消耗30e豆
- (void)setDecEDou_uid:(NSString *)uid
           hx_username:(NSString *)hx_username
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;
//保存编辑的认证信息
- (void)seteditorapprove_uid:(NSString *)uid
                       cname:(NSString *)cname
                     tradeid:(NSString *)tradeid
                     license:(NSString *)license
                 id_card_num:(NSString *)id_card_num
                 id_card_top:(NSString *)id_card_top
              id_card_bottom:(NSString *)id_card_bottom
                 license_num:(NSString *)license_num
                    province:(NSString *)province
                        city:(NSString *)city
                        area:(NSString *)area
                     address:(NSString *)address
                         lng:(NSString *)lng
                         lat:(NSString *)lat
                        logo:(NSString *)logo
                        ctag:(NSString *)ctag
                       scale:(NSString *)scale
                 companyinfo:(NSString *)companyinfo
                 productinfo:(NSString *)productinfo
                        link:(NSString *)link
                      cvedit:(NSString *)cvedit
                         img:(NSString *)img
                        team:(NSString *)team
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock;


#pragma mark end企业中心


#pragma mark - 支付管理

- (void)getAlipayOrderid:(NSString *)orderid
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock;

#pragma mark end支付管理

@end
