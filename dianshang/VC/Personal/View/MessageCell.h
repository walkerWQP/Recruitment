//
//  MessageCell.h
//  kuainiao
//
//  Created by yunjobs on 16/4/2.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageEntity;

@interface MessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) MessageEntity *item;

//- (void)setMesgCell:(MessageEntity *)entity;

@end
