//
//  YQRootViewController.h
//  kuainiao
//
//  Created by yunjobs on 16/5/18.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "EaseUI.h"

#import "HomeViewController.h"
#import "PersonalViewController.h"
#import "DiscoverViewController.h"
#import "SquarePageViewController.h"

@class ChatListViewController;

@interface YQRootViewController : UITabBarController

@property (nonatomic, strong) ChatListViewController *chatListVC;

- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;

@end
