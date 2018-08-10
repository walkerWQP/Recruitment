//
//  YQDiscoverPhotoView.m
//  dianshang
//
//  Created by yunjobs on 2017/10/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQDiscoverPhotoView.h"
#import "YQDiscoverPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YQDiscoverPhotoView()
@property (nonatomic, weak) UIImageView *gifView;

@end

@implementation YQDiscoverPhotoView

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(YQDiscoverPhoto *)photo
{
    _photo = photo;
    
    // 设置图片
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.yq_x = self.yq_width - self.gifView.yq_width;
    self.gifView.yq_y = self.yq_height - self.gifView.yq_height;
}

@end
