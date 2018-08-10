//
//  YQDiscoverDetailCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YQDiscoverComment;

@interface YQDiscoverDetailCell : UITableViewCell

@property (nonatomic, strong) YQDiscoverComment *entity;
@property (nonatomic, strong) void(^praiseBtnBlock)(NSIndexPath *path);

@end


@interface YQDiscoverCommentButton : UIButton

@end
