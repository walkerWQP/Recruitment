//
//  CompanyHomeCell.h
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyHomeEntity;
@interface CompanyHomeCell : UITableViewCell

@property (nonatomic, strong) CompanyHomeEntity *entity;

@property (weak, nonatomic) IBOutlet UIImageView *rapidImageView;

@property (weak, nonatomic) IBOutlet UILabel *rapidLabel;

@end
