//
//  AFAppDotNetAPIClient.m
//  dianshang
//
//  Created by yunjobs on 2017/9/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

static NSString * const AFAppDotNetAPIBaseURLString = @"https://api.app.net/";

#import "AFAppDotNetAPIClient.h"

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient
{
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
