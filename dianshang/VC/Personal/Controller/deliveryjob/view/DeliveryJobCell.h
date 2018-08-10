//
//  DeliveryJobCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeJobEntity;
@interface DeliveryJobCell : UITableViewCell

@property (nonatomic, strong) HomeJobEntity *entity;

@property (nonatomic, assign) NSInteger curTable;

// 是否显示评价按钮
//@property (nonatomic, assign) BOOL isCommentBtn;
// 评价按钮标题
//@property (nonatomic, strong) NSString *commentTitle;


@property (nonatomic, strong) void(^commentBlock)(NSIndexPath *indexPath, HomeJobEntity *entity);

@end
