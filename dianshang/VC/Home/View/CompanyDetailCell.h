//
//  CompanyDetailCell.h
//  dianshang
//
//  Created by yunjobs on 2017/12/8.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDescItem;

@interface CompanyDetailCell : UITableViewCell

@property (nonatomic, strong) CDescItem *entity;

@property (nonatomic, strong) void(^openBlock)(NSIndexPath *path);

@end
