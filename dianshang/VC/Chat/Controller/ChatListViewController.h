//
//  ChatListViewController.h
//  dianshang
//
//  Created by yunjobs on 2017/10/13.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EaseUI.h"

@interface ChatListViewController : EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
