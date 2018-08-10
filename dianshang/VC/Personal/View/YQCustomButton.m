//
//  YQCustomButton.m
//  kuainiao
//
//  Created by yunjobs on 16/11/19.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

const CGFloat DefultScale = 0.7;

#import "YQCustomButton.h"

@interface YQCustomButton ()

@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation YQCustomButton

- (UILabel *)subLabel
{
    if (_subLabel == nil) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+4, self.frame.size.width, 13);
        _subLabel.text = _subTitle;
        _subLabel.textColor = self.titleLabel.textColor;
        _subLabel.font = [UIFont systemFontOfSize:10];
        _subLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float imageX = 0;
    float imageY = 0;
    float imageW = 0;
    float imageH = 0;
    
    if (self.type == CustomButtonTypeFixedSize) {
        
        if (self.imageSize.width <= 0 || self.imageSize.height <= 0) {
            float h = self.yq_width > self.yq_height ? self.yq_height : self.yq_width;
            self.imageSize = CGSizeMake(h*DefultScale, h*DefultScale);
        }
        imageW = self.imageSize.width;
        imageH = self.imageSize.height;
        imageX = (self.yq_width - imageW)*0.5;
        imageY = (self.yq_height - imageH - self.titleLabel.yq_height)*0.5;
        self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        self.titleLabel.frame = CGRectMake(0, self.imageView.yq_bottom+2, self.yq_width, self.titleLabel.yq_height);
        [self addSubTitle];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }else if (self.type == CustomButtonTypeScale) {
        if (self.scale <= 0 || self.scale > DefultScale) {
            self.scale = DefultScale;
        }
        float h = self.yq_width > self.yq_height ? self.yq_height : self.yq_width;
        imageW = h * self.scale;
        imageH = imageW;
        imageX = (self.yq_width - imageW)*0.5;
        imageY = (self.yq_height - imageH - self.titleLabel.yq_height)*0.5;
        self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        self.titleLabel.frame = CGRectMake(0, self.imageView.yq_bottom+2, self.yq_width, self.titleLabel.yq_height);
        [self addSubTitle];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    self.type = CustomButtonTypeFixedSize;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    self.type = CustomButtonTypeScale;
}

//- (void)setSubTitle:(NSString *)subTitle
//{
//    if (subTitle.length) {
//        _subTitle = subTitle;
//        [self addSubTitle];
//    }
//}

- (void)addSubTitle
{
    [self addSubview:self.subLabel];
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    
    _subLabel.text = subTitle;
}

@end


@implementation TemplateButton


@end
