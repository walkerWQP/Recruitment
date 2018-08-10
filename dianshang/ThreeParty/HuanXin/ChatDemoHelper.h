/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

#import <Foundation/Foundation.h>

#import "ChatListViewController.h"
//#import "ContactListViewController.h"
//#import "YQRootViewController.h"
#import "ChatViewController.h"



@class YQRootViewController;

// EMGroupManagerDelegate // 移除群组管理回调
// EMContactManagerDelegate // 移除好友相关的回调
// EMChatroomManagerDelegate // 移除聊天室相关的回调
@interface ChatDemoHelper : NSObject <EMClientDelegate, EMMultiDevicesDelegate,EMChatManagerDelegate>

//@property (nonatomic, weak) ContactListViewController *contactViewVC;

@property (nonatomic, weak) ChatListViewController *conversationListVC;

@property (nonatomic, weak) YQRootViewController *mainVC;

@property (nonatomic, weak) ChatViewController *chatVC;

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

- (BOOL)isFetchHistoryChange;

@end
