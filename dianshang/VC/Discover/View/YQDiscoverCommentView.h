//
//  YQDiscoverCommentView.h
//  dianshang
//
//  Created by yunjobs on 2017/10/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YQDiscoverCommentView : UIView

@property(nonatomic,strong) NSArray *list;

+ (instancetype)commentView;

+ (CGFloat)commentViewHeightWithFixedWidth:(CGFloat)width commentList:(NSArray *)list;

@end
