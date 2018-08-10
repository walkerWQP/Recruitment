//
//  CResumeDeliverCell.h
//  dianshang
//
//  Created by yunjobs on 2017/12/5.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyHomeEntity;
@interface CResumeDeliverCell : UITableViewCell


@property (nonatomic, assign) NSInteger curTable;

@property (nonatomic, strong) CompanyHomeEntity *entity;

// 是否显示评价按钮
//@property (nonatomic, assign) BOOL isCommentBtn;
// 评价按钮标题
//@property (nonatomic, strong) NSString *commentTitle;
// 评价
@property (nonatomic, strong) void(^commentBlock)(NSIndexPath *indexPath, CompanyHomeEntity *entity);
// 未面试
@property (nonatomic, strong) void(^payBlock)(NSIndexPath *indexPath, CompanyHomeEntity *entity);
// 不合适
@property (nonatomic, strong) void(^closeBlock)(NSIndexPath *indexPath, CompanyHomeEntity *entity);
// 邀请
@property (nonatomic, strong) void(^invitationBlock)(NSIndexPath *indexPath, CompanyHomeEntity *entity);

@end
