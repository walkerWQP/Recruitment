    //
//  DataRequest.m
//  mobilely
//
//  Created by Victoria on 15/1/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//
static DataRequest *dataRequest;

#import "DataRequest.h"
#import "Reachability.h"
#import "NSString+Hash.h"
#import "AFAppDotNetAPIClient.h"
#import "AFHTTPSessionManager+Synchronous.h"

#import "YQSaveManage.h"

@interface DataRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *afManager;

@end

@implementation DataRequest

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (AFHTTPSessionManager *)afManager
{
    if (_afManager == nil) {
        AFHTTPSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
        // 请求管理者
        //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];
        manager.requestSerializer.timeoutInterval = 15;
        //manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _afManager = manager;
    }
    return _afManager;
}

+(DataRequest *)sharedDataRequest{
    if (!dataRequest) {
        dataRequest = [[self alloc] init];
        
    }
    return dataRequest;
}

+(BOOL) checkNetwork {
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NSString * tips = @"";
    BOOL fanhuizhi = NO;
    switch (reach.currentReachabilityStatus)
    {
        case NotReachable:
            tips = @"无网络连接";
            fanhuizhi = NO;
            break;
        case ReachableViaWiFi:
            tips = @"Wifi";
            fanhuizhi = YES;
            break;
        case ReachableViaWWAN:
            tips = @"流量";
            fanhuizhi = YES;
        default:
            break;
    }
    CLog(@"tips = %@",tips);
    return fanhuizhi;
}

// get方式访问网络(block)
- (void)getDataWithUrl:(NSString *)urlStr
                params:(NSDictionary *)params
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock
{
    if ([DataRequest checkNetwork]) {
        
        params = [self addCommonKeyValue:params urlStr:urlStr];
        
        [self.afManager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CLog(@"JSON: %@", responseObject);
            if ([self headerToken:responseObject]) {
                if (successBlock) {
                    successBlock(responseObject);
                }
            }else{
                //重新请求
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }else{
                [self failureHandle:error];
            }
        }];
        
    }
    else {
        NSError *error = [NSError errorWithDomain:@"网络无法连接!" code:-10086 userInfo:@{@"errorkey":@"网络无法连接!"}];
        if (failureBlock) {
            failureBlock(error);
        }else{
            [self failureHandle:error];
        }
    }
}

//post方式访问网络(block)
-(void)postDataWithUrl:(NSString *)urlStr
                params:(NSDictionary *)params
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock
{
    if ([DataRequest checkNetwork]) {
        
        params = [self addCommonKeyValue:params urlStr:urlStr];
        
        [self.afManager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CLog(@"JSON: %@", responseObject);
//            if ([self headerToken:responseObject]) {
                if (successBlock) {
//                    NSArray *list = responseObject[@"data"];
//                    [self printPropertyWithDict:list.firstObject];
                    successBlock(responseObject);
                }
//            }else{
//                
//                // 再次获取正确的token
//                [self rePostToken:urlStr params:params success:successBlock failure:failureBlock];
//                
//            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }else{
                [self failureHandle:error];
            }
        }];
        
    }
    else {
        NSError *error = [NSError errorWithDomain:@"网络无法连接!" code:-10086 userInfo:@{@"errorkey":@"网络无法连接!"}];
        if (failureBlock) {
            failureBlock(error);
        }else{
            [self failureHandle:error];
        }
    }
}

/*!
 *  @brief 上传多张图片(block)
 *
 */
- (void)uploadImageFileWithUrl:(NSString *)UrlStr
                    imageDatas:(NSArray *)imageDatas
                     imagekeys:(NSArray *)imagekeys
                        params:(NSDictionary *)params
                 progressBlock:(progressBlock)progressBlock
                       success:(successBlock)successBlock
                       failure:(failureBlock)failureBlock
{
    if (imagekeys.count != imageDatas.count) {
        NSLog(@"图片Data和图片KEY不对");
        return;
    }
    if ([DataRequest checkNetwork])
    {
        
        params = [self addCommonKeyValue:params urlStr:UrlStr];
        
        [self.afManager POST:UrlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
            
            for (int i = 0; i < imagekeys.count; i++) {
                NSData *imageData = imageDatas[i];
                [formData appendPartWithFileData:imageData
                                            name:imagekeys[i]          //服务器接收的key
                                        fileName:@"aaaa.png"           //文件名称
                                        mimeType:@"image/png"];     //文件类型(根据不同情况自行修改)
            }
        }progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progressBlock) {
                CGFloat a = uploadProgress.totalUnitCount;
                CGFloat aa = uploadProgress.completedUnitCount;
                progressBlock(aa / a);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CLog(@"JSON: %@", responseObject);
            
            if ([self headerToken:responseObject]) {
                if (successBlock) {
                    successBlock(responseObject);
                }
            }else{
                //重新请求
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }else{
                [self failureHandle:error];
            }
        }];
        
    }else {
        NSError *error = [NSError errorWithDomain:@"网络无法连接!" code:-10086 userInfo:@{@"errorkey":@"网络无法连接!"}];
        if (failureBlock) {
            failureBlock(error);
        }else{
            [self failureHandle:error];
        }
    }
}

/*!
 *  @brief 上传图片(block)
 *
 *  @param paramDic 参数列表
 *  @param UrlStr   url
 *  @param iamgeData  图片数据
 *  @param progressBlock  进度
 */
- (void)uploadImageFileWithPrarms:(NSDictionary *)paramDic
                        uploadUrl:(NSString *)UrlStr
                        imageData:(NSData *)iamgeData
                    progressBlock:(progressBlock)progressBlock
                          success:(successBlock)successBlock
                          failure:(failureBlock)failureBlock
{
    if ([DataRequest checkNetwork])
    {
        
        [self.afManager POST:UrlStr parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
            
            [formData appendPartWithFileData:iamgeData
                                        name:@"uploadimg"          //服务器接收的key
                                    fileName:@"aaaa.png"           //文件名称
                                    mimeType:@"multipart/form-data"];     //文件类型(根据不同情况自行修改)
        }progress:^(NSProgress * _Nonnull uploadProgress) {
            CGFloat a = uploadProgress.totalUnitCount;
            CGFloat aa = uploadProgress.completedUnitCount;
            progressBlock(aa / a);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CLog(@"JSON: %@", responseObject);
            
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }else{
                [self failureHandle:error];
            }
        }];
        
    }else {
        NSError *error = [NSError errorWithDomain:@"网络无法连接!" code:-10086 userInfo:@{@"errorkey":@"网络无法连接!"}];
        if (failureBlock) {
            failureBlock(error);
        }else{
            [self failureHandle:error];
        }
    }
}

-(void)cancelRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
   // NSArray *operations = [manager.operationQueue operations];
}

/// 处理token 返回NO需要把token参数替换后重新请求
- (BOOL)headerToken:(NSDictionary *)responseObject
{
    NSString *code = [responseObject objectForKey:@"code"];
    if (code != nil) {
        if ([code isEqualToString:@"100001"]) {
            return YES;
        }else if ([code isEqualToString:@"100004"]||[code isEqualToString:@"100005"]){
            // 过期
            return NO;
        }else if ([code isEqualToString:@"1000011111"]){
            // 异地登录
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOverdue object:nil];
            return YES;
        }
        else{
            return YES;
        }
    }else{
        return YES;
    }
    return YES;
}

#pragma mark - tool

/// 添加通用字段
- (NSMutableDictionary *)addCommonKeyValue:(NSDictionary *)params urlStr:(NSString *)urlStr
{
    /// 3.0以后增加接口版本字段
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    if (!([urlStr rangeOfString:EZGetToken].length>0)) {
        NSString *aa = [params objectForKey:@"sign"];
        if (aa != nil) {
            [dict removeObjectForKey:@"sign"];
        }
        // 上传图片时"imgfile"字段不参与加密
        NSString *imageFile = [params objectForKey:@"imgfile"];
        if (imageFile != nil) {
            [dict removeObjectForKey:@"imgfile"];
        }
        NSString *sgin = [self setSign:dict];
        if (sgin.length != 0) {
            [dict setObject:sgin forKey:@"sign"];
        }else{
            return nil;
        }
    }
    return dict;
}

- (NSString *)setSign:(NSDictionary *)params
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    //NSString *token = [UserEntity getToken];
    NSString *token = @"LaRaBMyWrVpvup2ZkwQXk3ggTI36irdq";
    [dict setObject:token forKey:@"token"];
    
    NSArray *keys = dict.allKeys;
    keys = [keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *mStr = [NSMutableString string];
    for (NSString *str in keys) {
        NSString *value = [dict objectForKey:str];
        [mStr appendString:value];
    }
    return mStr.sha1String;
}

- (void)rePostToken:(NSString *)urlStr
             params:(NSDictionary *)params
            success:(successBlock)successBlock
            failure:(failureBlock)failureBlock
{
    NSDictionary *dict = @{@"appid":EZAppid,@"appsecret":EZSecret};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,EZGetToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    NSError *error = nil;
    // 同步请求
    NSDictionary *resultDic = [manager syncPOST:url  parameters:dict task:NULL error:&error];
    if ([resultDic[CODE] isEqualToString:SUCCESS]) {
        // 保存token
        NSDictionary *dict = resultDic[DATA];
        [UserEntity setToken:dict[@"token_ez"]];
        // 重新请求
        [self postDataWithUrl:urlStr params:params success:successBlock failure:failureBlock];
    }
}

//// 获取本地token
//- (NSString *)localToken
//{
//    return [YQSaveManage objectForKey:LTOKEN];
//}
//// 保存token到本地
//- (void)setLocalToken:(NSString *)token
//{
//    [YQSaveManage setObject:token forKey:LTOKEN];
//}

- (void)failureHandle:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkNotification object:error userInfo:nil];
}

@end
