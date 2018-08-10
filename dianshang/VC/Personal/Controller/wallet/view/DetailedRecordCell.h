//
//  DetailedRecordCell.h
//  dianshang
//
//  Created by yunjobs on 2017/9/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailRecordEntity;

@interface DetailedRecordCell : UITableViewCell

@property (nonatomic, strong) DetailRecordEntity *entity;

@property (nonatomic, assign) NSInteger tableIndex;

@end
