//
//  YQDDCollectionView.h
//  CustomTable
//
//  Created by yunjobs on 2017/10/25.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQDowndropItem;

@interface YQDDCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame downdropItem:(YQDowndropItem *)subItem;

@property (nonatomic, strong) void(^ResetClickBlock)(YQDDCollectionView *collectionView);

@property (nonatomic, strong) void(^DetermineClickBlock)(YQDDCollectionView *collectionView);

- (void)refresh;

@end

@class YQSingleTableViewItem;
@interface YQDDCollectionCell : UICollectionViewCell

@property (nonatomic, strong) YQSingleTableViewItem *buttonItem;

@property (nonatomic, strong) UIButton *textButton;

@property (nonatomic, strong) void(^refreshSection)(NSIndexPath *path);

@end

@interface YQDDCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;

@end


// 左对齐样式
@interface YQDDCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
