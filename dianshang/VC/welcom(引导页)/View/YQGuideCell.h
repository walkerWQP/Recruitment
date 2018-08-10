//
//  YQGuideCell.h
//  caipiao
//
//  Created by yunjobs on 16/8/5.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQGuideCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count pressStartBtn:(void(^)())block;

@property (nonatomic, strong) void(^pressStartBtn)();

@end
