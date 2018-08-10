//
//  YQLabel.h
//  kuainiao
//
//  Created by yunjobs on 16/12/15.
//  Copyright © 2016年 yunjobs. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


@interface YQLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
