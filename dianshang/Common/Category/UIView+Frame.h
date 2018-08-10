//
//  UIView+Frame.h
//  caipiao
//  快速定位位置
//  Created by yunjobs on 16/8/4.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat yq_width;
@property (nonatomic, assign) CGFloat yq_height;

@property (nonatomic, assign) CGFloat yq_x;
@property (nonatomic, assign) CGFloat yq_y;

@property (nonatomic, assign) CGFloat yq_bottom;
@property (nonatomic, assign) CGFloat yq_right;

@property (nonatomic, assign) CGSize yq_size;
@property (nonatomic, assign) CGPoint yq_origin;

@property (nonatomic, assign) CGFloat yq_centerX;
@property (nonatomic, assign) CGFloat yq_centerY;

@end
