//
//  JPushManager.h
//  kuainiao
//
//  Created by yunjobs on 16/4/28.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"

static NSString *appKey = @"2d3d89ff481439e41aa78ed8";
static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;

@interface JPushManager : NSObject

@property (nonatomic,copy) void(^ResBlock)(int iResCode, NSSet *iTags, NSString *iAlias);
//单例
+ (JPushManager *)shareJPushManager;
//注册推送
-(void)registerJPush:(NSDictionary *)launchOptions;
//设置别名
- (void)setAlias:(NSString *)alias resBlock:(void(^)(NSInteger iResCode, NSString *iAlias, NSInteger seq))block;
//播放声音
- (void)playSound;
//播放振动
- (void)playVibrate;

@end
