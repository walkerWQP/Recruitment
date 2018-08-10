//
//  DataRequest.h
//  mobilely
//
//  Created by Victoria on 15/1/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

typedef void(^successBlock)(id resultDic);
typedef void(^failureBlock)(NSError *error);
typedef void(^progressBlock)(CGFloat f);

#import <Foundation/Foundation.h>
#import "ModelConst.h"

@interface DataRequest : NSObject

/**
 *  创建一个访问网络的单例
 *
 *  @return 返回一个访问网络的单例
 */
+(DataRequest *)sharedDataRequest;

//检查网络
+(BOOL) checkNetwork;

// get方式访问网络(block)
- (void)getDataWithUrl:(NSString *)urlStr
                params:(NSDictionary *)params
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;

//post方式访问网络(block)
-(void)postDataWithUrl:(NSString *)urlStr
                params:(NSDictionary *)params
               success:(successBlock)successBlock
               failure:(failureBlock)failureBlock;

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
                          failure:(failureBlock)failureBlock;

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
                       failure:(failureBlock)failureBlock;

-(void) cancelRequest;

//- (void)printPropertyWithDict:(NSDictionary *)dict;

@end
