//
//  DemoCallManager.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 22/11/2016.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import "DemoCallManager.h"

#if DEMO_CALL == 1

#import "EaseSDKHelper.h"
//#import "EMVideoRecorderPlugin.h"

#import "YQRootViewController.h"
#import "ChatListViewController.h"

#import "EMCallViewController.h"

static DemoCallManager *callManager = nil;

@interface DemoCallManager()<EMChatManagerDelegate, EMCallManagerDelegate, EMCallBuilderDelegate>

@property (strong, nonatomic) NSObject *callLock;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) EMCallSession *currentSession;

@property (strong, nonatomic) EMCallViewController *currentController;

@end

#endif

@implementation DemoCallManager

#if DEMO_CALL == 1

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initManager];
    }
    
    return self;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        callManager = [[DemoCallManager alloc] init];
    });
    
    return callManager;
}

- (void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].callManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_CALL object:nil];
}

#pragma mark - private

- (void)_initManager
{
    _callLock = [[NSObject alloc] init];
    _currentSession = nil;
    _currentController = nil;
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].callManager setBuilderDelegate:self];
    
//    [EMVideoRecorderPlugin initGlobalConfig];
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"calloptions.data"];
    EMCallOptions *options = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        options = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    } else {
        options = [[EMClient sharedClient].callManager getCallOptions];
        options.isSendPushIfOffline = NO;
        options.videoResolution = EMCallVideoResolution640_480;
        options.isFixedVideoResolution = YES;
    }
    [[EMClient sharedClient].callManager setCallOptions:options];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];
}

- (void)_clearCurrentCallViewAndData
{
    @synchronized (_callLock) {
        self.currentSession = nil;
        
        self.currentController.isDismissing = YES;
        [self.currentController clearData];
        [self.currentController dismissViewControllerAnimated:NO completion:nil];
        self.currentController = nil;
    }
}

#pragma mark - private timer

- (void)_timeoutBeforeCallAnswered
{
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"call.autoHangup", @"No response and Hang up") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)_startCallTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_timeoutBeforeCallAnswered) userInfo:nil repeats:NO];
}

- (void)_stopCallTimer
{
    if (self.timer == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - EMChatManagerDelegate

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody *cmdBody = (EMCmdMessageBody *)message.body;
        NSString *action = cmdBody.action;
        if ([action isEqualToString:@"inviteToJoinConference"]) {
            //            NSString *callId = [message.ext objectForKey:@"callId"];
        } else if ([action isEqualToString:@"__Call_ReqP2P_ConferencePattern"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已转为会议模式" delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

#pragma mark - EMCallManagerDelegate
// 接电话回调
- (void)callDidReceive:(EMCallSession *)aSession
{
    if (!aSession || [aSession.callId length] == 0) {
        return ;
    }
    
    if ([EaseSDKHelper shareHelper].isShowingimagePicker) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideImagePicker" object:nil];
    }
    
    if(self.currentSession && self.currentSession.status != EMCallSessionStatusDisconnected){
        [[EMClient sharedClient].callManager endCall:aSession.callId reason:EMCallEndReasonBusy];
        return;
    }
    
    @synchronized (_callLock) {
        [self _startCallTimer];
        
        self.currentSession = aSession;
        self.currentController = [[EMCallViewController alloc] initWithCallSession:self.currentSession];
        self.currentController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.currentController) {
                [self.mainController presentViewController:self.currentController animated:NO completion:nil];
            }
        });
    }
}

/// 通话通道建立完成，用户A和用户B都会收到这个回调
- (void)callDidConnect:(EMCallSession *)aSession
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self.currentController stateToConnected];
    }
}
/// 用户B同意用户A拨打的通话后，用户A会收到这个回调
- (void)callDidAccept:(EMCallSession *)aSession
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self _stopCallTimer];
        [self.currentController stateToAnswered];
    }
}

/// 结束通话回调
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        
        [self _stopCallTimer];
        
        @synchronized (_callLock) {
            self.currentSession = nil;
            [self _clearCurrentCallViewAndData];
        }
        
        if (aReason != EMCallEndReasonHangup) {
            NSString *reasonStr = @"end";
            switch (aReason) {
                case EMCallEndReasonNoResponse:
                {
                    reasonStr = NSLocalizedString(@"call.noResponse", @"NO response");
                }
                    break;
                case EMCallEndReasonDecline:
                {
                    //reasonStr = NSLocalizedString(@"call.rejected", @"Reject the call");
                    reasonStr = @"";
                    // 插入一条数据
                    [self yq_insertTextMessage:@"对方拒绝接听" aSession:aSession withExt:nil];
                }
                    break;
                case EMCallEndReasonBusy:
                {
                    reasonStr = NSLocalizedString(@"call.in", @"In the call...");
                }
                    break;
                case EMCallEndReasonFailed:
                {
                    reasonStr = NSLocalizedString(@"call.connectFailed", @"Connect failed");
                }
                    break;
                case EMCallEndReasonUnsupported:
                {
                    reasonStr = NSLocalizedString(@"call.connectUnsupported", @"Unsupported");
                }
                    break;
                case EMCallEndReasonRemoteOffline:
                {
                    reasonStr = NSLocalizedString(@"call.offline", @"Remote offline");
                }
                    break;
                default:
                    break;
            }
            
            if (aError) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:aError.errorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                if (reasonStr.length > 0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reasonStr delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }else{
            
            // 对方取消,显示未接听/对方挂断,显示时间
            if (self.timeLength > 0) {
                // 正常挂断
                NSString *timeStr = [self yq_formatTimeLength:self.timeLength];
                // 清零通话时间
                self.timeLength = 0;
                [self yq_insertTextMessage:[NSString stringWithFormat:@"通话时间 %@ ",timeStr] aSession:aSession withExt:nil];
            }else{
                // 取消
                [self yq_insertTextMessage:@"未接听" aSession:aSession withExt:nil];
            }
        }
    }else{
        // 拒绝还是挂断 YES 拒绝 NO 挂断
        if (self.isCallReject) {
            // 拒绝
            [self yq_insertTextMessage:@"已拒绝" aSession:aSession withExt:nil];
        }else{
            
            if (self.timeLength > 0) {
                // 正常挂断
                NSString *timeStr = [self yq_formatTimeLength:self.timeLength];
                // 清零通话时间
                self.timeLength = 0;
                
                [self yq_insertTextMessage:[NSString stringWithFormat:@"通话时间 %@ ",timeStr] aSession:aSession withExt:nil];
            }else{
                // 取消
                [self yq_insertTextMessage:@"已取消" aSession:aSession withExt:nil];
            }
        }
    }
}

- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self.currentController setStreamType:aType];
    }
}

- (void)callNetworkDidChange:(EMCallSession *)aSession
                      status:(EMCallNetworkStatus)aStatus
{
    if ([aSession.callId isEqualToString:self.currentSession.callId]) {
        [self.currentController setNetwork:aStatus];
    }
}

#pragma mark - EMCallBuilderDelegate

- (void)callRemoteOffline:(NSString *)aRemoteName
{
    NSString *text = [[EMClient sharedClient].callManager getCallOptions].offlineMessageText;
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSLog(@"%@",text);
    NSString *fromStr = [EMClient sharedClient].currentUsername;
    EMMessage *message = [[EMMessage alloc] initWithConversationID:aRemoteName from:fromStr to:aRemoteName body:body ext:@{@"em_apns_ext":@{@"em_push_title":text}}];
    message.chatType = EMChatTypeChat;
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:nil];
}

#pragma mark - NSNotification

- (void)makeCall:(NSNotification*)notify
{
    if (notify.object) {
        
        EMCallType type = (EMCallType)[[notify.object objectForKey:@"type"] integerValue];
        [self makeCallWithUsername:[notify.object valueForKey:@"chatter"] type:type];
    }
}

#pragma mark - public

- (void)saveCallOptions
{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"calloptions.data"];
    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
    [NSKeyedArchiver archiveRootObject:options toFile:file];
}

- (void)makeCallWithUsername:(NSString *)aUsername
                        type:(EMCallType)aType
{
    if ([aUsername length] == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    void (^completionBlock)(EMCallSession *, EMError *) = ^(EMCallSession *aCallSession, EMError *aError){
        DemoCallManager *strongSelf = weakSelf;
        if (strongSelf) {
            if (aError || aCallSession == nil) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"call.initFailed", @"Establish call failure") message:aError.errorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            
            @synchronized (self.callLock) {
                strongSelf.currentSession = aCallSession;
                strongSelf.currentController = [[EMCallViewController alloc] initWithCallSession:strongSelf.currentSession];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (strongSelf.currentController) {
                        [strongSelf.mainController presentViewController:self.currentController animated:NO completion:nil];
                    }
                });
            }
            
            [self _startCallTimer];
        }
        else {
            [[EMClient sharedClient].callManager endCall:aCallSession.callId reason:EMCallEndReasonNoResponse];
        }
    };
    // 打电话
    [[EMClient sharedClient].callManager startCall:aType remoteName:aUsername ext:@"123" completion:^(EMCallSession *aCallSession, EMError *aError) {
        completionBlock(aCallSession, aError);
    }];
}

- (void)answerCall:(NSString *)aCallId
{
    if (!self.currentSession || ![self.currentSession.callId isEqualToString:aCallId]) {
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:weakSelf.currentSession.callId];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == EMErrorNetworkUnavailable) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network.disconnection", @"Network disconnection") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                }
                else{
                    [weakSelf hangupCallWithReason:EMCallEndReasonFailed];
                }
            });
        }
    });
}

- (void)hangupCallWithReason:(EMCallEndReason)aReason
{
    [self _stopCallTimer];
    
    if (self.currentSession) {
        [[EMClient sharedClient].callManager endCall:self.currentSession.callId reason:aReason];
    }
    [self _clearCurrentCallViewAndData];
}


/// 结束通话后发送消息
- (void)yq_insertTextMessage:(NSString *)text aSession:(EMCallSession *)aSession withExt:(NSDictionary*)ext
{
    // 创建一个消息体对象
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    
    NSString *remoteName = aSession.remoteName;//对方的
    NSString *localName = aSession.localName;//自己的
    //NSString *a = aSession.callId;
    // 创建一个消息对象
    EMMessage *messagea = nil;
    
    if (aSession.isCaller) {
        EMMessage *message = [[EMMessage alloc] initWithConversationID:remoteName from:localName to:remoteName body:body ext:@{kHXUserID:localName}];
        message.chatType = EMChatTypeChat;
        message.status = EMMessageStatusSucceed;
        message.direction = EMMessageDirectionSend;
        messagea = message;
    }else{
        EMMessage *message = [[EMMessage alloc] initWithConversationID:remoteName from:remoteName to:localName body:body ext:@{kHXUserID:remoteName}];
        message.chatType = EMChatTypeChat;
        message.status = EMMessageStatusSucceed;
        message.direction = EMMessageDirectionReceive;
        messagea = message;
    }
    
    if (messagea != nil) {
        // 根据 toName 创建conversation对象
        EMError *error = nil;
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:remoteName type:EMConversationTypeChat createIfNotExist:YES];
        [conversation insertMessage:messagea error:&error];
        if (error == nil) {
            // 获取最后一条信息
            EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:remoteName type:EMConversationTypeChat createIfNotExist:YES];
            // 成功后发送刷新UI通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CHAT_RELOADMESSAGE object:conversation.latestMessage];
            // 刷新消息列表
            [self.mainController.chatListVC refreshDataSource];
        }
        
    }
}

- (NSString *)yq_formatTimeLength:(int)timeLength
{
    int hour = timeLength / 3600;
    int m = (timeLength - hour * 3600) / 60;
    int s = timeLength - hour * 3600 - m * 60;
    NSString *timeStr = nil;
    if (hour > 0) {
        NSString *sstr = [NSString stringWithFormat:@"%i", s];
        if (s < 10) sstr = [@"0" stringByAppendingString:sstr];
        NSString *mstr = [NSString stringWithFormat:@"%i", m];
        if (m < 10) mstr = [@"0" stringByAppendingString:mstr];
        NSString *hstr = [NSString stringWithFormat:@"%i", hour];
        if (hour < 10) hstr = [@"0" stringByAppendingString:hstr];
        timeStr = [NSString stringWithFormat:@"%@:%@:%@", hstr, mstr, sstr];
    }
    else if(m > 0){
        NSString *sstr = [NSString stringWithFormat:@"%i", s];
        if (s < 10) sstr = [@"0" stringByAppendingString:sstr];
        NSString *mstr = [NSString stringWithFormat:@"%i", m];
        if (m < 10) mstr = [@"0" stringByAppendingString:mstr];
        timeStr = [NSString stringWithFormat:@"%@:%@", mstr, sstr];
    }
    else{
        NSString *sstr = [NSString stringWithFormat:@"%i", s];
        if (s < 10) sstr = [@"0" stringByAppendingString:sstr];
        timeStr = [NSString stringWithFormat:@"00:%@", sstr];
    }
    return timeStr;
}


#endif

@end
