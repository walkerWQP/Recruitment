//
//  DemoCallManager.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 22/11/2016.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Hyphenate/Hyphenate.h>
#import "EMCallOptions+NSCoding.h"

@class YQRootViewController;
@interface DemoCallManager : NSObject

#if DEMO_CALL == 1

@property (strong, nonatomic) YQRootViewController *mainController;

+ (instancetype)sharedManager;

- (void)saveCallOptions;

- (void)makeCallWithUsername:(NSString *)aUsername
                        type:(EMCallType)aType;

- (void)answerCall:(NSString *)aCallId;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

/// 添加一个状态, 拒绝还是挂断 YES 拒绝 NO 挂断
@property (assign, nonatomic) BOOL isCallReject;

@property (nonatomic) int timeLength;

#endif

@end
