//
//  YQToolBarButton.m
//  dianshang
//
//  Created by yunjobs on 2017/11/15.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQToolBarButton.h"

@implementation YQToolBarButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float imageX = 0;
    float imageY = 0;
    float imageW = 0;
    float imageH = 0;
    
    float h = self.yq_width > self.yq_height ? self.yq_height : self.yq_width;
    imageW = h * 0.6;
    imageH = imageW;
    imageX = (self.yq_width - imageW)*0.5;
    imageY = (self.yq_height - imageH)*0.5;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    self.titleLabel.yq_width += 5;
    self.titleLabel.center = CGPointMake(imageX+imageW, imageY);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor whiteColor];
}

@end
