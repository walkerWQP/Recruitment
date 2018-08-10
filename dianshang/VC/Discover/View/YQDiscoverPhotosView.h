//
//  YQDiscoverPhotosView.h
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YQDiscoverPhotosViewDelegate;
@class YQDiscoverPhotoView;

@interface YQDiscoverPhotosView : UIView

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, strong) id<YQDiscoverPhotosViewDelegate> delegate;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count superWidth:(CGFloat)width;

@end

// 图片点击代理
@protocol YQDiscoverPhotosViewDelegate <NSObject>

@optional

/// 图片点击回调
- (void)photoViewSelected:(YQDiscoverPhotosView *)photosView photoView:(YQDiscoverPhotoView *)photoView photoViewArray:(NSMutableArray<NSDictionary *> *)array;



@end
