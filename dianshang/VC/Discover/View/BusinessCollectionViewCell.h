//
//  BusinessCollectionViewCell.h
//  dianshang
//
//  Created by yunjobs on 2018/4/16.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BusinessCollectionViewCell_CollectionViewCell @"BusinessCollectionViewCell"

@class BusinessModel;

@interface BusinessCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BusinessModel *model;


@end
