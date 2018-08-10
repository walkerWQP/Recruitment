//
//  ShareHRCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareHREntity;

@interface ShareHRCell : UITableViewCell

@property (nonatomic, strong) ShareHREntity *entity;

// 是否显示推荐按钮
@property (nonatomic, assign) BOOL isRecommendBtn;
//显示离职状态
@property (nonatomic, assign) BOOL isTypeLabel;

@property (nonatomic, strong) void(^recommendBlock)(NSIndexPath *indexPath, ShareHREntity *entity);

@end
