//
//  CSelectPositionCell.h
//  dianshang
//
//  Created by yunjobs on 2017/12/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPositionMangerEntity;

@interface CSelectPositionCell : UITableViewCell

@property (nonatomic, assign) NSInteger indexx;

@property (nonatomic, strong) CPositionMangerEntity *entity;

@end
