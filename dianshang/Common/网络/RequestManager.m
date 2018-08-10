//
//  RequestManager.m
//  mobilely
//
//  Created by Victoria on 15/1/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import "RequestManager.h"
#import "NSString+Hash.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

static RequestManager *requestManager;
@implementation RequestManager

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

+(id)sharedRequestManager{
    if (!requestManager) {
        requestManager = [[self alloc] init];
    }
    return requestManager;
}
/**
 *  获取ip
 *
 *  @return 本机ip
 */
+ (NSString *)rip
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

#pragma mark ========获取当前日期,格式 20160405========
+ (NSString *)currentDateStr
{
    //签名串有改动去掉了日期
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYYMMdd"];
//    NSString *str = [formatter stringFromDate:date];
    return @"";
}

-(void)cancelRequestWithObject:(id)sender{
    [[DataRequest sharedDataRequest] cancelRequest];
}

#pragma mark ========获取Token========
- (void)getToken_success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"appid":EZAppid,@"appsecret":EZSecret};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetToken];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========登录========
- (void)login_uPhone:(NSString *)phone
             smsCode:(NSString *)code
                type:(NSString *)type
             success:(successBlock)successBlock
             failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:  @{@"phone":phone,@"code":code,@"type":type}];
    [dict setObject:@"1" forKey:@"pt"];//注册类型：1-安卓，2-ios
    //[dict setObject:@"" forKey:@"device"];//设备型号
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZPhoneLogin];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========发送手机验证码========
- (void)sendCode_mobile:(NSString *)mobile
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"mobile":mobile};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetVCode];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark - start简历管理

#pragma mark ========获取行业列表========
- (void)getExpectIndustry_uid:(NSString *)uid
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetHoptrade];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========获取职位类型列表========
- (void)getJobPosition_uid:(NSString *)uid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetPositionclass];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========期望职位  期望职位id(workId)有值保存无值添加========
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
               failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"position_classid":position_classid,@"genre":genre,@"city":city,@"trade":trade,@"salary":salary,@"explanation":explanation,@"isfast":isfast}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAddhopwork];
    if (workId.length>0) {
        [dict setObject:workId forKey:@"id"];
        NSLog(@"%@",workId);
        url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSavehopwork];
    }
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========保存求职状态========
- (void)saveRestatus_uid:(NSString *)uid
                restatus:(NSString *)restatus
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"restatus":restatus};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSaveRestatus];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========删除期望职位========
- (void)deletehopwork_uid:(NSString *)uid
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"id":uid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeletehopwork];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========获取期望职位========
- (void)gethopwork_uid:(NSString *)uid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{};
    if (uid != nil) {
        dict = @{@"uid":uid};
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGethopwork];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========获取简历详情========
- (void)getResumeDetail_uid:(NSString *)uid
                       puid:(NSString *)puid
                       type:(NSString *)type
                hx_username:(NSString *)hx_username
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"type":type,@"puid":puid,@"hx_username":hx_username};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetResumeDetail];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========工作经历  工作经历id(workId)有值保存无值添加========
- (void)addWork_uid:(NSString *)uid
             workId:(NSString *)workId
        companyname:(NSString *)companyname
           position:(NSString *)position
          entrytime:(NSString *)entrytime
          leavetime:(NSString *)leavetime
            content:(NSString *)content
            success:(successBlock)successBlock
            failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"companyname":companyname,@"position":position,@"entrytime":entrytime,@"leavetime":leavetime,@"content":content}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAddWork];
    if (workId.length>0) {
        [dict setObject:workId forKey:@"id"];
        url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSaveEditWork];
    }
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========删除工作经历========
- (void)deleteWork_uid:(NSString *)uid
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"id":uid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeleteWork];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========教育经历  教育经历id(eduId)有值保存无值添加========
- (void)addEdu_uid:(NSString *)uid
             eduId:(NSString *)eduId
        schoolname:(NSString *)schoolname
             major:(NSString *)major
      entrancetime:(NSString *)entrancetime
          graduate:(NSString *)graduate
               edu:(NSString *)edu
        experience:(NSString *)experience
           success:(successBlock)successBlock
           failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"schoolname":schoolname,@"major":major,@"entrancetime":entrancetime,@"graduate":graduate,@"edu":edu,@"experience":experience}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAddEdu];
    if (eduId.length>0) {
        [dict setObject:eduId forKey:@"id"];
        url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSaveEdu];
    }
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========删除教育经历========
- (void)deleteEdu_uid:(NSString *)uid
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"id":uid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeleteEdu];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========项目经验  项目经验id(projectId)有值保存无值添加========
- (void)addProject_uid:(NSString *)uid
             projectId:(NSString *)projectId
        pname:(NSString *)pname
             duty:(NSString *)duty
      starttime:(NSString *)starttime
          endtime:(NSString *)endtime
               describetion:(NSString *)describetion
           success:(successBlock)successBlock
           failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"pname":pname,@"duty":duty,@"starttime":starttime,@"endtime":endtime,@"describetion":describetion}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAddProject];
    if (projectId.length>0) {
        [dict setObject:projectId forKey:@"id"];
        url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSaveProject];
    }
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========删除项目经验========
- (void)deleteProject_uid:(NSString *)uid
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"id":uid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeleteProject];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========保存自我描述========
- (void)saveDescription_uid:(NSString *)uid
                description:(NSString *)description
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"description":description};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSaveDesc];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========APP活动内容========
- (void)getAllactices:(NSString *)type
              success:(successBlock)successBlock
              failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"type":type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetAllactices];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark - 用户管理
#pragma mark ========用户设置========
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
                failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"phone":phone,@"avatar":avatar,@"name":name,@"sex":sex,@"birthday":birthday,@"wechatid":wechatid,@"restatus":restatus,@"edu":edu,@"year":year,@"workyear":workyear}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZUserSetting];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========上传头像========
- (void)uploadImage_uid:(NSString *)uid
                headimg:(NSData *)headimg
          progressBlock:(progressBlock)progressBlock
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZUploadHeadImg];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:uid forKey:@"uid"];
    NSArray *imageDatas = @[headimg];
    NSArray *imagekeys = @[@"imgfile"];
    [[DataRequest sharedDataRequest] uploadImageFileWithUrl:url imageDatas:imageDatas imagekeys:imagekeys params:mDict progressBlock:progressBlock success:successBlock failure:failureBlock];
}

#pragma mark ========多图上传========
- (void)uploadImage_uid:(NSString *)uid
               imageArr:(NSArray *)imageArr
          progressBlock:(progressBlock)progressBlock
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZUploadMroeImg];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:uid forKey:@"uid"];
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSMutableArray *imagekeys = [NSMutableArray array];
    for (NSData *data in imageArr) {
        [imageDatas addObject:data];
        [imagekeys addObject:@"imgfile"];
    }
    [[DataRequest sharedDataRequest] uploadImageFileWithUrl:url imageDatas:imageDatas imagekeys:imagekeys params:mDict progressBlock:progressBlock success:successBlock failure:failureBlock];
}

#pragma mark - 发现

#pragma mark ========发现列表========
- (void)getDiscoverNewList_uid:(NSString *)uid
                          page:(NSString *)page
                      pagesize:(NSString *)pagesize
                          type:(NSString *)type
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"page":page,@"pagesize":pagesize,@"type":type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverGetNewList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========职场/合伙人列表========
- (void)getDiscoverTopicList_uid:(NSString *)uid
                            page:(NSString *)page
                        pagesize:(NSString *)pagesize
                       isdefault:(NSString *)isdefault
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"page":page,@"pagesize":pagesize,@"isdefault":isdefault};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverGetTopicList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========话题发布========
- (void)discoverTopicRelease_uid:(NSString *)uid
                           title:(NSString *)title
                        describe:(NSString *)describe
                       isdefault:(NSString *)isdefault
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"title":title,@"describe":describe,@"isdefault":isdefault};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverTopicRelease];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========点赞话题========
- (void)discoverPraiseTopic_uid:(NSString *)uid
                            tid:(NSString *)tid
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"tid":tid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverPraise];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========评论话题========
- (void)discoverCommentTopic_uid:(NSString *)uid
                             tid:(NSString *)tid
                            desc:(NSString *)desc
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"tid":tid,@"desc":desc};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverComment];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========给评论点赞========
- (void)discoverCommentPraise_uid:(NSString *)uid
                              tid:(NSString *)tid
                              cid:(NSString *)cid
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"tid":tid,@"id":cid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverCommentPraise];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========分享话题========
- (void)discoverShareTopic_uid:(NSString *)uid
                           tid:(NSString *)tid
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"tid":tid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverShare];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========删除话题========
- (void)discoverDeleteTopic_uid:(NSString *)uid
                            tid:(NSString *)tid
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"id":tid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverDelete];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========删除评论========
- (void)discoverDeleteComment_uid:(NSString *)uid
                              cid:(NSString *)cid
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"id":cid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverDeleteComment];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========话题详情========
- (void)discoverTopicDetail_uid:(NSString *)uid
                            tid:(NSString *)tid
                           page:(NSString *)page
                       pagesize:(NSString *)pagesize
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"tid":tid,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverTopicDetail];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}
#pragma mark - end发现

#pragma mark - 职位

#pragma mark ========获取职位列表========
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
                        failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"page":page,@"pagesize":pagesize,@"recommend":recommend,@"city":city,@"area":area,@"scale":scale,@"cvedit":cvedit,@"tradeid":tradeid,@"edu":edu,@"exprience":exprience,@"pay":pay,@"pname":pname,@"name":name};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHomeGetPositionList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========获取职位详情========
- (void)homeGetPositionDetail_uid:(NSString *)uid
                              pid:(NSString *)pid
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"id":pid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHomeGetPositionDetail];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========关注职位  attention(1表示关注，2表示取消关注)========
- (void)homeGetPositionFollow_uid:(NSString *)uid
                       positionid:(NSString *)positionid
                             puid:(NSString *)puid
                        attention:(NSString *)attention
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"positionid":positionid,@"puid":puid,@"attention":attention};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHomeGetPositionFollow];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========个人详情页========
- (void)homeMemberDetail_uid:(NSString *)uid
                        puid:(NSString *)puid
                 hx_username:(NSString *)hx_username
                        type:(NSString *)type
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"puid":puid,hx_username:hx_username,@"type":type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHomeMemberDetail];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========公司详情页========
- (void)homeCompanyDetail_uid:(NSString *)uid
                         mid:(NSString *)mid
                   companyid:(NSString *)companyid
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"mid":mid,@"companyid":companyid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHomeCompanyDetail];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark end职位

#pragma mark - start共享HR
#pragma mark ========HR首页========
#pragma mark ========HR推荐列表  //type 1、可推荐；2、待面试；3、已面试；4、已入职；5、已转正========
- (void)getHRRecommendList_uid:(NSString *)uid
                          type:(NSString *)type
                          page:(NSString *)page
                      pagesize:(NSString *)pagesize
                         pname:(NSString *)pname
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"type":type,@"page":page,@"pagesize":pagesize,@"pname":pname};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHRRecommendList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}
/*
 /// HR推荐列表  //dealwith 1表示待面试，2表示已面试，3表示已入职，4表示已转正，5、已离职
 - (void)getHRRecommendList_uid:(NSString *)uid
 type:(NSString *)type
 pclassid:(NSString *)pclassid
 dealwith:(NSString *)dealwith
 page:(NSString *)page
 pagesize:(NSString *)pagesize
 success:(successBlock)successBlock
 failure:(failureBlock)failureBlock
 {
 NSDictionary *dict = @{@"uid":uid,@"type":type,@"page":page,@"pagesize":pagesize,@"dealwith":dealwith,@"pclassid":pclassid};
 NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHRRecommendList];
 [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
 }
 */

#pragma mark ========获取推荐人才适合的职位列表========
- (void)getHRRecommendPersonList_uid:(NSString *)uid
                                 rid:(NSString *)rid
                           posi_name:(NSString *)posi_name
                                city:(NSString *)city
                                page:(NSString *)page
                            pagesize:(NSString *)pagesize
                             success:(successBlock)successBlock
                             failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"rid":rid,@"posi_name":posi_name,@"city":city,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHRRecommendPersonList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========每日E招推荐========
- (void)getStickPositionList_uid:(NSString *)uid
                            city:(NSString *)city
                            page:(NSString *)page
                        pagesize:(NSString *)pagesize
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"city":city};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZStickposition];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========把XX推荐给XX========
- (void)getHRRecommend_uid:(NSString *)uid
                       pid:(NSString *)pid
                      type:(NSString *)type
                      puid:(NSString *)puid
                   shareid:(NSString *)shareid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"puid":puid,@"pid":pid,@"shareid":shareid,@"type":type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZHRRecommend];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}
#pragma mark end共享HR

#pragma mark - start我的

#pragma mark ========获取关注职位列表========
- (void)getFollowJobList_uid:(NSString *)uid
                           page:(NSString *)page
                       pagesize:(NSString *)pagesize
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZFollowJobList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========面试记录列表  //dealwith面试状态（1表示待面试，2表示已面试，3表示已入职，4表示已转正，5、已离职，6、未面试，7、拒绝企业邀请）========
- (void)getInterviewJobList_uid:(NSString *)uid
                      dealwith:(NSString *)dealwith
                          page:(NSString *)page
                      pagesize:(NSString *)pagesize
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"dealwith":dealwith,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZInterviewJobList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}
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
                       failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"posid":posid,@"puid":puid,@"type":type}];
    if ([type isEqualToString:@"1"]) {
        [dict setObject:firstgrade forKey:@"firstgrade"];
        [dict setObject:firstinfo forKey:@"firstinfo"];
    }else if ([type isEqualToString:@"2"]) {
        [dict setObject:office forKey:@"office"];
        [dict setObject:culture forKey:@"culture"];
        [dict setObject:care forKey:@"care"];
        [dict setObject:benefits forKey:@"benefits"];
        [dict setObject:prospects forKey:@"prospects"];
    }else if ([type isEqualToString:@"3"]) {
        [dict setObject:leavegrade forKey:@"leavegrade"];
        [dict setObject:leaveinfo forKey:@"leaveinfo"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZImpressionEvaluate];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========白名单查询========
- (void)whiteListQuery_uid:(NSString *)uid
                     phone:(NSString *)phone
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"phone":phone};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZQueryWhiteList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========白名单添加========
- (void)whiteListAdd_uid:(NSString *)uid
                     wid:(NSString *)wid
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"wid":wid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAddWhiteList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========白名单删除========
- (void)whiteListDelete_uid:(NSString *)uid
                     itemid:(NSString *)itemid
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"id":itemid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeleteWhiteList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========白名单列表========
- (void)getWhiteList_uid:(NSString *)uid
                    page:(NSString *)page
                pagesize:(NSString *)pagesize
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZWhiteList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========人才投递记录列表  type 1、人才直投；2、hr推荐========
- (void)getDeliveryRecordList_uid:(NSString *)uid
                             type:(NSString *)type
                             page:(NSString *)page
                         pagesize:(NSString *)pagesize
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"type":type,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeliveryRecordList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========修改简历状态 // 4、已面试不合适；5、已面试待入职（已面试合适）；6、已入职待转正；7、已转正；8、已离职 10未面试========
- (void)changeResumeState_uid:(NSString *)uid
                          mid:(NSString *)mid
                      orderid:(NSString *)orderid
                     dealwith:(NSString *)dealwith
                    redpacket:(NSString *)redpacket
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"mid":mid,@"orderid":orderid,@"dealwith":dealwith};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZChangeResumeState];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========同意/拒绝面试 1、通过；2、拒绝========
- (void)interviewOperation_uid:(NSString *)uid
                       orderid:(NSString *)orderid
                          type:(NSString *)type
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"orderid":orderid,@"type":type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZInterviewOperation];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========发送面试邀请========
- (void)sendInterview_uid:(NSString *)uid
                      rid:(NSString *)rid
                      pid:(NSString *)pid
                      mid:(NSString *)mid
                  orderid:(NSString *)orderid
                     date:(NSString *)date
                  address:(NSString *)address
                 describe:(NSString *)describe
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"orderid":orderid,@"uid":uid,@"rid":rid,@"pid":pid,@"mid":mid,@"date":date,@"address":address,@"describe":describe};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSendInterview];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========面试详情 type 1、企业端；2、人才端========
- (void)interviewDetail_uid:(NSString *)uid
                    orderid:(NSString *)orderid
                       type:(NSString *)type
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"orderid":orderid,@"type":type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZInterviewDetail];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========订单列表========
- (void)recommendOrderList_uid:(NSString *)uid
                         pname:(NSString *)pname
                          type:(NSString *)type
                          page:(NSString *)page
                      pagesize:(NSString *)pagesize
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"pagesize":pagesize,@"type":type,@"pname":pname,@"page":page};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZOrderLists];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========订单分期列表========
- (void)recommendOrderBystagesList_uid:(NSString *)uid
                              ordernum:(NSString *)ordernum
                               success:(successBlock)successBlock
                               failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{};
    if (ordernum != nil) {
        dict = @{@"ordernum":ordernum};
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZOrderBystagesList];
        [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
    }
}

#pragma mark ========获取账户余额========
- (void)getAccountBalance_uid:(NSString *)uid
                         type:(NSString *)type
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAccountBalance];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========e豆列表========
- (void)getEdoulist_uid:(NSString *)uid
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZEdouList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========充值========
- (void)accountRecharge_uid:(NSString *)uid
                ordernum:(NSString *)ordernum
                   money:(NSString *)money
                    type:(NSString *)type
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"type":type,@"ordernum":ordernum,@"money":money};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAccountRecharge];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========红包充值========
- (void)redpacketRecharge_uid:(NSString *)uid
                     ordernum:(NSString *)ordernum
                        money:(NSString *)money
                         type:(NSString *)type
                          ext:(NSDictionary *)ext
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"type":type,@"ordernum":ordernum,@"money":money};
    if ([type isEqualToString:@"4"]) {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:ext];
        [mdict setObject:type forKey:@"type"];
        [mdict setObject:ordernum forKey:@"ordernum"];
        [mdict setObject:money forKey:@"money"];
        [mdict setObject:uid forKey:@"uid"];
        dict = mdict;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAccountRecharge];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========聊天是举报对方========
- (void)chatReportUser_uid:(NSString *)uid
                      ruid:(NSString *)ruid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"ruid":ruid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZReportUser];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========用户余额提现  mstatus提现人身份（1、个人 2、企业========
- (void)balanceWithdrawals_uid:(NSString *)uid
                       mstatus:(NSString *)mstatus
                        alipay:(NSString *)alipay
                         money:(NSString *)money
                          code:(NSString *)code
                    alipayname:(NSString *)alipayname
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"mstatus":mstatus,@"alipayname":alipayname,@"alipay":alipay,@"money":money,@"code":code};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZBalanceWithdrawals];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========提现记录 type 1、顾问费；2、e豆========
- (void)withdrawalsList_uid:(NSString *)uid
                       type:(NSString *)type
                       page:(NSString *)page
                   pagesize:(NSString *)pagesize
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid,@"type":type,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZWithDrawalsList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}


#pragma mark ========发送验证码========
- (void)sendCode_phone:(NSString *)mobile
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"mobile":mobile};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSendCode];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========修改手机号码第一步，验证旧的手机号========
- (void)vChangePhone_uid:(NSString *)uid
                  mobile:(NSString *)mobile
                    code:(NSString *)code
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"mobile":mobile,@"uid":uid,@"code":code};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZVChangePhone];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========修改手机号码第二步，设置新的手机号码========
- (void)changePhone_uid:(NSString *)uid
                 mobile:(NSString *)mobile
                   code:(NSString *)code
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"mobile":mobile,@"uid":uid,@"code":code};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZChangePhone];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========意见反馈========
- (void)feedback_uid:(NSString *)uid
              phones:(NSString *)phones
             message:(NSString *)message
             success:(successBlock)successBlock
             failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"phone":phones,@"uid":uid,@"message":message};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZFeedback];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========人才实名认证========
- (void)personalAuth_uid:(NSString *)uid
                truename:(NSString *)truename
                  number:(NSString *)number
              number_top:(NSString *)number_top
           number_bottom:(NSString *)number_bottom
              trueavatar:(NSString *)trueavatar
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"trueavatar":trueavatar,@"uid":uid,@"truename":truename,@"number":number,@"number_top":number_top,@"number_bottom":number_bottom};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZPersonalAuth];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========获取新版本========
- (void)getNewVersion:(NSString *)uid
              success:(successBlock)successBlock
              failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCheckVersion];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========获取用户信息========
- (void)getUserInfo_uid:(NSString *)uid
                success:(successBlock)successBlock
                failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{};
    if (uid != nil) {
        dict = @{@"uid":uid};
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetUserInfo];
        [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
    }
}

#pragma mark ========获取站内信========
- (void)getSitemsg_uid:(NSString *)aid
                  page:(NSString *)page
              pagesize:(NSString *)pagesize
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":aid,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSitemsg];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

///// 人才简历--投递
//- (void)deliverRemuse_uid:(NSString *)uid
//                      pid:(NSString *)pid
//                 success:(successBlock)successBlock
//                 failure:(failureBlock)failureBlock
//{
//    NSDictionary *dict = @{@"uid":uid,@"pid":pid};
//    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeliverRemuse];
//    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
//}

#pragma mark end我的


#pragma mark - 发现

#pragma mark ========获取活动类型========
- (void)getActivityType_uid:(NSString *)uid
                       type:(NSString *)type
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"type":type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverActivitytype];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========获取活动列表========
- (void)getActivityList_uid:(NSString *)uid
                       type:(NSString *)type
                       page:(NSString *)page
                   pagesize:(NSString *)pagesize
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"type":type,@"page":page,@"pagesize":pagesize};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverActivitylist];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========获取发现轮播 type 1、人才端；2、企业端 ；3、e豆活动========
- (void)getDiscoverBanner_uid:(NSString *)aid
                         type:(NSString *)type
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"type":type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDiscoverSlidelist];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

/****  企业接口 ****/
#pragma mark - 企业
#pragma mark 企业中心

#pragma mark ========企业信息========
- (void)getCPersonCenter_uid:(NSString *)uid
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"uid":uid};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanyCenter];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========企业信息修改保存========
- (void)changeCPersonInfo_uid:(NSString *)uid
                         name:(NSString *)name
                         post:(NSString *)post
                     wechatid:(NSString *)wechatid
                         team:(NSString *)team
                        email:(NSString *)email
                       avatar:(NSString *)avatar
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"post":post,@"avatar":avatar,@"name":name,@"wechatid":wechatid,@"team":team,@"email":email}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZChangePersonInfo];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark 认证
#pragma mark ========公司基本信息========
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
                        failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"cname":cname,@"lat":lat,@"lng":lng,@"province":province,@"city":city,@"area":area,@"logo":logo,@"scale":scale,@"cvedit":cvedit,@"ctag":ctag,@"address":address,@"tradeid":tradeid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanyAuth];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========修改认证状态========
- (void)checkAuthStatus_uid:(NSString *)uid
                    success:(successBlock)successBlock
                    failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCheckAuth];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========公司介绍========
- (void)companyAuthBaseInfo_uid:(NSString *)uid
                            img:(NSString *)img
                           link:(NSString *)link
                    companyinfo:(NSString *)companyinfo
                           team:(NSString *)team
                    productinfo:(NSString *)productinfo
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"img":img,@"link":link,@"companyinfo":companyinfo,@"team":team,@"productinfo":productinfo}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanyAuth];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========公司营业执照========
- (void)companyAuthBaseInfo_uid:(NSString *)uid
                        license:(NSString *)license
                    license_num:(NSString *)license_num
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"license":license,@"license_num":license_num}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanyAuth];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========公司法人身份证件========
- (void)companyAuthBaseInfo_uid:(NSString *)uid
                    id_card_num:(NSString *)id_card_num
                    id_card_top:(NSString *)id_card_top
                 id_card_bottom:(NSString *)id_card_bottom
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"id_card_num":id_card_num,@"id_card_bottom":id_card_bottom,@"id_card_top":id_card_top}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanyAuth];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark 职位管理

#pragma mark ========企业发布的职位列表========
- (void)getCPositionList_uid:(NSString *)uid
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetCPositionList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========发布职位========
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
                     failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"cid":cid,@"position_class_id":position_class_id,@"pname":pname,@"pay":pay,@"skill":skill,@"exprien":experience,@"edu":edu,@"pdetails":pdetails,@"consultant":consultant,@"probation":probation,@"city":city}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZReleasePosition];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========保存编辑职位========
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
                    failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"pid":pid,@"position_class_id":position_class_id,@"pname":pname,@"pay":pay,@"skill":skill,@"exprien":experience,@"edu":edu,@"pdetails":pdetails,@"consultant":consultant,@"probation":probation,@"city":city}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSaveEditPosition];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========删除职位========
- (void)deletePosition_uid:(NSString *)uid
                       pid:(NSString *)pid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"pid":pid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeletePosition];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========改变职位状态========
- (void)changePosition_uid:(NSString *)uid
                       pid:(NSString *)pid
                   success:(successBlock)successBlock
                   failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"pid":pid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZChangePositionStatus];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========首页人才列表========
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
                      failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"city":city,@"uid":uid,@"restatus":restatus,@"pname":pname,@"pay":pay,@"recommend":recommend,@"exprience":experience,@"edu":edu,@"pagesize":pagesize,@"page":page}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCPersonnelList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========企业关注人才列表========
- (void)followPersonList_uid:(NSString *)uid
                        page:(NSString *)page
                    pagesize:(NSString *)pagesize
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"page":page,@"pagesize":pagesize}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCFollowPersonList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========企业关注人才========
- (void)followPersonList_uid:(NSString *)uid
                         mid:(NSString *)mid
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mid":mid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCFollowPerson];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========人才直投列表 (1表示待面试，2表示已面试，3表示已入职，4表示已转正，5、已离职，6、发送面试邀请，7、未面试，8、人才拒绝邀请，0人才简历)========
- (void)getResumeDeliverList_uid:(NSString *)uid
                            type:(NSString *)type
                        pclassid:(NSString *)pclassid
                        dealwith:(NSString *)dealwith
                            page:(NSString *)page
                        pagesize:(NSString *)pagesize
                         success:(successBlock)successBlock
                         failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"pname":pclassid,@"page":page,@"pagesize":pagesize,@"dealwith":dealwith}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCResumeDeliverList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========HR推荐列表========
- (void)getResumeRecommendList_uid:(NSString *)uid
                              type:(NSString *)type
                          pclassid:(NSString *)pclassid
                          dealwith:(NSString *)dealwith
                              page:(NSString *)page
                          pagesize:(NSString *)pagesize
                           success:(successBlock)successBlock
                           failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"pname":pclassid,@"type":@"1",@"page":page,@"pagesize":pagesize,@"dealwith":dealwith}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCResumeRecommendList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========企业首页--搜索========
- (void)companySearch_uid:(NSString *)uid
                  keyword:(NSString *)keyword
                     work:(NSString *)work
                      edu:(NSString *)edu
                   salary:(NSString *)salary
                 restatus:(NSString *)restatus
                     page:(NSString *)page
                 pagesize:(NSString *)pagesize
                  success:(successBlock)successBlock
                  failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"keyword":keyword,@"work":work,@"edu":edu,@"salary":salary,@"restatus":restatus,@"page":page,@"pagesize":pagesize}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanySearch];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========付费查看电话号  sid 人才ID(企业用户对谁消费e豆)========
- (void)payEdou_uid:(NSString *)uid
         positionid:(NSString *)positionid
               type:(NSString *)type
                sid:(NSString *)sid
            success:(successBlock)successBlock
            failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"sid":sid,@"positionid":positionid,@"type":type}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZPayEdou];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========企业对HR评分========
- (void)companyScore_uid:(NSString *)uid
                     rid:(NSString *)rid
                 shareid:(NSString *)shareid
                   grade:(NSString *)grade
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"rid":rid,@"shareid":shareid,@"grade":grade}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanyScore];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========公司成员列表========
- (void)companyMemberList_uid:(NSString *)uid
                          cid:(NSString *)cid
                         page:(NSString *)page
                     pagesize:(NSString *)pagesize
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock
{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"pagesize":pagesize,@"cid":cid,@"page":page}];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"cid":cid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanyMemberList];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========添加公司成员========
- (void)addCompanyMember_uid:(NSString *)uid
                       phone:(NSString *)phone
                        code:(NSString *)code
                     success:(successBlock)successBlock
                     failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"code":code,@"phone":phone,@"uid":uid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZAddCompanyMember];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========删除公司成员 mid 公司成员id========
- (void)deleteCompanyMember_uid:(NSString *)uid
                            mid:(NSString *)mid
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"mid":mid,@"uid":uid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZDeleteCompanyMember];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========搜索成员========
- (void)searchCompanyMember_uid:(NSString *)uid
                          phone:(NSString *)phone
                        success:(successBlock)successBlock
                        failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSearchCompanyMember];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========与公司解绑========
- (void)companyUnbundling_uid:(NSString *)uid
                      success:(successBlock)successBlock
                      failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZCompanyUnbundling];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========企业获取人才联系方式========
- (void)getPersonalPhone_uid:(NSString *)uid hx_username:(NSString *)hx_username success:(successBlock)successBlock failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"hx_username":hx_username}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetpersonalphone];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========消耗30e豆========
- (void)setDecEDou_uid:(NSString *)uid hx_username:(NSString *)hx_username success:(successBlock)successBlock failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"hx_username":hx_username,@"uid":uid}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSetdecedou];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark ========保存编辑的认证信息========
- (void)seteditorapprove_uid:(NSString *)uid cname:(NSString *)cname tradeid:(NSString *)tradeid license:(NSString *)license id_card_num:(NSString *)id_card_num id_card_top:(NSString *)id_card_top id_card_bottom:(NSString *)id_card_bottom license_num:(NSString *)license_num province:(NSString *)province city:(NSString *)city area:(NSString *)area address:(NSString *)address lng:(NSString *)lng lat:(NSString *)lat logo:(NSString *)logo ctag:(NSString *)ctag scale:(NSString *)scale companyinfo:(NSString *)companyinfo productinfo:(NSString *)productinfo link:(NSString *)link cvedit:(NSString *)cvedit img:(NSString *)img team:(NSString *)team success:(successBlock)successBlock failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"cname":cname,@"tradeid":tradeid,@"license":license,@"id_card_num":id_card_num,@"id_card_top":id_card_top,@"id_card_bottom":id_card_bottom,@"license_num":license_num,@"province":province,@"city":city,@"area":area,@"address":address,@"lng":lng,@"lat":lat,@"logo":logo,@"ctag":ctag,@"scale":scale,@"companyinfo":companyinfo,@"productinfo":productinfo,@"link":link,@"cvedit":cvedit,@"img":img,@"team":team}];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZSeteditorapprove];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark end企业中心


#pragma mark - 支付管理

- (void)getAlipayOrderid:(NSString *)orderid
                 success:(successBlock)successBlock
                 failure:(failureBlock)failureBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    NSString *url = [NSString stringWithFormat:@"http://47.94.232.16/app/callback/createorderinfo"];
    [[DataRequest sharedDataRequest] postDataWithUrl:url params:dict success:successBlock failure:failureBlock];
}

#pragma mark end支付管理


@end
