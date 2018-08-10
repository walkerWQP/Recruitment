//
//  AFAppDotNetAPIClient.h
//  dianshang
//
//  Created by yunjobs on 2017/9/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
