//
//  YQRootViewController.m
//  kuainiao
//
//  Created by yunjobs on 16/5/18.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";


#import "YQRootViewController.h"

#import "CompanyHomeController.h"

#import "YQNavigationController.h"
#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "ChatDemoHelper.h"

#import "ShareHRController.h"

#import "YQTabBar.h"

@interface YQRootViewController ()<YQTabBarDelegate>
{
    EMConnectionState _connectionState;
}


@property (nonatomic, strong) NSMutableArray *tabbarItems;

// 最后响铃时间
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation YQRootViewController

- (NSMutableArray *)tabbarItems
{
    if (_tabbarItems == nil) {
        _tabbarItems = [NSMutableArray array];
    }
    return _tabbarItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setTintColor:THEMECOLOR];
    
    [[ChatDemoHelper shareHelper] setMainVC:self];
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self setUpAllChildController];
    self.selectedIndex = 0;
    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    
    [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;
    
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    YQTabBar *tabbar = [[YQTabBar alloc] init];
    tabbar.YQDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
}
- (void)tabBarPlusBtnClick:(YQTabBar *)tabBar
{
//    ShareHRController *vc = [[ShareHRController alloc] init];
//    YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
    self.selectedIndex = 2;
}
- (void)setUpAllChildController
{
    if ([UserEntity getIsCompany]) {
        CompanyHomeController *homeVC = [[CompanyHomeController alloc] init];
        [self setUpOneChildController:homeVC image:@"tabbar_person" selImage:@"tabbar_person" title:@"人才"];
        
        SquarePageViewController *voiceVC = [[SquarePageViewController alloc] init];
        [self setUpOneChildController:voiceVC image:@"tabbar_discover" selImage:@"tabbar_discover" title:@"广场"];
        
//        ShareHRController *shareVC = [[ShareHRController alloc] init];
//        [self setUpOneChildController:shareVC image:@"" selImage:@"" title:@""];
        
        ChatListViewController *mapVC = [[ChatListViewController alloc] init];
        [self setUpOneChildController:mapVC image:@"tabbar_chat" selImage:@"tabbar_chat" title:@"E聊"];
        _chatListVC = mapVC;
        // 设置聊天列表页面
        [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;
        
        
        PersonalViewController *personalVC = [[PersonalViewController alloc] init];
        [self setUpOneChildController:personalVC image:@"tabbar_user" selImage:@"tabbar_user" title:@"我的"];
        
    }else{
        
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        [self setUpOneChildController:homeVC image:@"tabbar_home" selImage:@"tabbar_home" title:@"职位"];
        
        SquarePageViewController *voiceVC = [[SquarePageViewController alloc] init];
        [self setUpOneChildController:voiceVC image:@"tabbar_discover" selImage:@"tabbar_discover" title:@"广场"];
        
        ShareHRController *shareVC = [[ShareHRController alloc] init];
        [self setUpOneChildController:shareVC image:@"" selImage:@"" title:@""];
        
        ChatListViewController *mapVC = [[ChatListViewController alloc] init];
        [self setUpOneChildController:mapVC image:@"tabbar_chat" selImage:@"tabbar_chat" title:@"E聊"];
        _chatListVC = mapVC;
        // 设置聊天列表页面
        [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;
        
        
        PersonalViewController *personalVC = [[PersonalViewController alloc] init];
        [self setUpOneChildController:personalVC image:@"tabbar_user" selImage:@"tabbar_user" title:@"我的"];
    }
    
    
}

- (void)setUpOneChildController:(UIViewController *)vc image:(NSString *)image selImage:(NSString *)selImage title:(NSString *)title
{
    
    UINavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:vc];
    
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selImage];
    nav.tabBarItem.title = title;
    
    [self.tabbarItems addObject:nav.tabBarItem];
    
    [self addChildViewController:nav];
}

#pragma mark - 聊天回调方法
#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)setupUntreatedApplyCount
{
    
}

- (void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            //self.navigationController.tabBarItem.badgeValue = @"1";
            _chatListVC.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.navigationController.tabBarItem.badgeValue = 0;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

// 改变网络状态
- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#else
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
#endif
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        //        do {
        //            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        //            if (message.chatType == EMChatTypeGroupChat) {
        //                NSDictionary *ext = message.ext;
        //                if (ext && ext[kGroupMessageAtList]) {
        //                    id target = ext[kGroupMessageAtList];
        //                    if ([target isKindOfClass:[NSString class]]) {
        //                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        //                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
        //                            break;
        //                        }
        //                    }
        //                    else if ([target isKindOfClass:[NSArray class]]) {
        //                        NSArray *atTargets = (NSArray*)target;
        //                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
        //                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
        //                            break;
        //                        }
        //                    }
        //                }
        //                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
        //                for (EMGroup *group in groupArray) {
        //                    if ([group.groupId isEqualToString:message.conversationId]) {
        //                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
        //                        break;
        //                    }
        //                }
        //            }
        //            else if (message.chatType == EMChatTypeChatRoom)
        //            {
        //                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        //                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
        //                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
        //                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
        //                if (chatroomName)
        //                {
        //                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
        //                }
        //            }
        //
        //            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        //        } while (0);
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setupUnreadMessageCount" object:nil];
}

@end
