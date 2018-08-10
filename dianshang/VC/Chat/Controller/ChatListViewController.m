//
//  ChatListViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/10/13.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ChatListViewController.h"
#import "CFollowPersonalController.h"
#import "CompanyPersonalDetailVC.h"
#import "ChatViewController.h"
#import "ChatDemoHelper.h"
#import "HomePositionDetailVC.h"

#import "UserInfo+CoreDataClass.h"

#import "YQGuideManage.h"
#import "YQSaveManage.h"

#import "FollowJobController.h"

#import "NSString+RegularExpression.h"
#import "NSString+Hash.h"

@interface ChatListViewController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,FollowJobDelegate,FollowPersonalDelegate>

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) FollowJobController *followJobVC;
@property (nonatomic, strong) CFollowPersonalController *followPersonVC;
//@property (nonatomic, strong) HomePositionDetailVC *detailVC;
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *hxname = [UserEntity getHXUserName];
    NSString *hxpass = @"123456".md5String;
    [[EMClient sharedClient] loginWithUsername:hxname password:hxpass completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            CLog(@"环信->登录成功");
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        } else {
            CLog(@"环信->登录失败");
        }
    }];
    
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self networkStateView];
    
    //[self setupSearchController];
    
    [self tableViewDidTriggerHeaderRefresh];
    [self removeEmptyConversationsFromDB];
    [self.tableView reloadData];
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"退出登录" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick)];
    
    [self setNav];
}
- (void)setNav
{
    //self.navigationItem.title = @"E聊";
    
    UISegmentedControl *segmentedC = [[UISegmentedControl alloc] initWithItems:@[@"E聊",@"关注"]];
    segmentedC.yq_width = 120;
    segmentedC.selectedSegmentIndex = 0;
    segmentedC.tintColor = [UIColor whiteColor];
    [segmentedC addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = THEMECOLOR;
    [segmentedC setTitleTextAttributes:dic forState:UIControlStateSelected];
    self.navigationItem.titleView = segmentedC;
}
- (void)segmentChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        if ([UserEntity getIsCompany]) {
            self.followPersonVC.view.hidden = YES;
        }else{
            self.followJobVC.view.hidden = YES;
        }
    }else if (sender.selectedSegmentIndex == 1){
        if ([UserEntity getIsCompany]) {
            self.followPersonVC.view.hidden = NO;
        }else{
            self.followJobVC.view.hidden = NO;
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}



#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
//            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
//                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
//                [self.navigationController pushViewController:chatController animated:YES];
//            } else {
                UIViewController *chatController = nil;
#ifdef REDPACKET_AVALABLE
                chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
#else
                chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
#endif
                chatController.title = conversationModel.title;
                chatController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatController animated:YES];
//            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        
        NSString *userid = conversation.conversationId;
        // 根据扩展字段里的userid去数据库中查询
        UserInfo *userinfo = [UserInfo selectDataWithUserHXId:userid];
        if (userinfo != nil) {
            // 头像和昵称都存在数据库
            model.title = userinfo.userName;
            model.avatarURLPath = userinfo.userHeadPath;
        }
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            // 根据扩展字段里的userid去数据库中查询
            UserInfo *userinfo = [UserInfo selectDataWithUserHXId:from];
            if (userinfo != nil) {
                // 头像和昵称都存在数据库
                from = userinfo.userName;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    
    return latestMessageTime;
}

#pragma mark - getter

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

static int a = 0;
-(void)refreshDataSource
{
    CLog(@"---------------------------%d",++a);
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

- (FollowJobController *)followJobVC
{
    if (_followJobVC == nil) {
        FollowJobController *vc = [[FollowJobController alloc] init];
        vc.delegate = self;
        [self.view addSubview:vc.view];
        _followJobVC = vc;
    }
    return _followJobVC;
}
- (CFollowPersonalController *)followPersonVC
{
    if (_followPersonVC == nil) {
        CFollowPersonalController *vc = [[CFollowPersonalController alloc] init];
        [self.view addSubview:vc.view];
        vc.delegate = self;
        _followPersonVC = vc;
    }
    return _followPersonVC;
}

- (void)didFollowJobDelegate:(HomeJobEntity *)entity
{
    HomePositionDetailVC *vc = [[HomePositionDetailVC alloc] init];
    vc.jobEntity = entity;
    vc.isHome = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didFollowPersonalDelegate:(CompanyHomeEntity *)entity
{
    CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
    vc.entity = entity;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightClick
{
    
    
//    self.followJobVC.view.hidden = !self.followJobVC.view.hidden;
    
//    [[EMClient sharedClient] registerWithUsername:@"205080" password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
//        if (!aError) {
//            NSLog(@"注册成功");
//        } else {
//            NSLog(@"注册失败");
//        }
//    }];
    
//    [[EMClient sharedClient] loginWithUsername:@"319342" password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
//        if (!aError) {
//            NSLog(@"登录成功");
//            [[EMClient sharedClient].options setIsAutoLogin:YES];
//        } else {
//            NSLog(@"登录失败");
//        }
//    }];
    
//    // 退出环信登录
//    [[EMClient sharedClient].options setIsAutoLogin:NO];
//    [[EMClient sharedClient] logout:YES];
//    // 设置登录状态
//    [YQSaveManage setObject:@"0" forKey:LOGINSTATUS];
//    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    UIViewController *rootVC = [YQGuideManage chooseRootController];
//    window.rootViewController = rootVC;

//    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:@"ez_59e99769e5eb4" conversationType:EMConversationTypeChat];
//    //    chatController.dataSource = self;
//    //    chatController.showRefreshHeader = YES;
//    chatController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatController animated:YES];
}

@end
