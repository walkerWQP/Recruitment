//
//  WhiteListCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WhiteListEntity;

@interface WhiteListCell : UITableViewCell

@property (nonatomic, strong) WhiteListEntity *entity;

// 是否显示添加按钮
@property (nonatomic, assign) BOOL isAddBtn;

// 是否显示添加按钮
@property (nonatomic, strong) NSString *addTitle;

@property (nonatomic, strong) void(^addBtnBlock)(NSIndexPath *indexPath, WhiteListEntity *entity);


@end
