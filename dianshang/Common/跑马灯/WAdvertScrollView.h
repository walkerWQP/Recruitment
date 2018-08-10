//
//  WAdvertScrollView.h
//  DrunkenBeauty
//
//  Created by apple on 2017/6/3.
//  Copyright © 2017年 魏秋鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WAdvertScrollView;

typedef enum : NSUInteger {
    /// 一行文字滚动样式
    WAdvertScrollViewStyleNormal,
    /// 二行文字滚动样式
    WAdvertScrollViewStyleMore,
} WAdvertScrollViewStyle;

@protocol WAdvertScrollViewDelegate <NSObject>

/// delegate 方法
- (void)advertScrollView:(WAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface WAdvertScrollView : UIView

#pragma mark - - - 公共 API
/** delegate */
@property (nonatomic, weak) id<WAdvertScrollViewDelegate> delegate;
/** 默认 SGAdvertScrollViewStyleNormal 样式 */
@property (nonatomic, assign) WAdvertScrollViewStyle advertScrollViewStyle;
/** 滚动时间间隔，默认为3s */
@property (nonatomic, assign) CFTimeInterval scrollTimeInterval;
/** 标题字体字号，默认为13号字体 */
@property (nonatomic, strong) UIFont *titleFont;

#pragma mark - - - WAdvertScrollViewStyleNormal 样式下的 API
/** 左边标志图片数组 */
@property (nonatomic, strong) NSArray *signImages;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 标题字体颜色，默认为黑色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 标题文字位置，默认为 NSTextAlignmentLeft，仅仅针对标题起作用 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

#pragma mark - - - WAdvertScrollViewStyleMore 样式下的 API
/** 顶部左边标志图片数组 */
@property (nonatomic, strong) NSArray *topSignImages;
/** 顶部标题数组 */
@property (nonatomic, strong) NSArray *topTitles;
/** 底部左边标志图片数组 */
@property (nonatomic, strong) NSArray *bottomSignImages;
/** 底部标题数组 */
@property (nonatomic, strong) NSArray *bottomTitles;
/** 顶部标题字体颜色，默认为黑色 */
@property (nonatomic, strong) UIColor *topTitleColor;
/** 底部标题字体颜色，默认为黑色 */
@property (nonatomic, strong) UIColor *bottomTitleColor;

@end
