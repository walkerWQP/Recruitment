//
//  YQDiscoverPhotosView.m
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define XFStatusPhotoMaxCol(count) ((count==4)?2:3)

#import "YQDiscoverPhotosView.h"
#import "YQDiscoverPhoto.h"
#import "YQDiscoverPhotoView.h"

@interface YQDiscoverPhotosView ()

@property (nonatomic, strong) NSMutableArray *photoBrowers;

@end

@implementation YQDiscoverPhotosView

//- (NSMutableArray *)photoBrowers
//{
//    if (_photoBrowers == nil) {
//        _photoBrowers = [NSMutableArray array];
//    }
//}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    
    return self;
}


- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    int photosCount = (int)photos.count;
    
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        YQDiscoverPhotoView *photoView = [[YQDiscoverPhotoView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [photoView addGestureRecognizer:tap];
        photoView.userInteractionEnabled = YES;
        [self addSubview:photoView];
    }
    
    self.photoBrowers = [NSMutableArray array];
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        YQDiscoverPhotoView *photoView = self.subviews[i];
        photoView.tag = i;
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
            
            NSDictionary *dict = @{@"url":[photoView.photo.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]};
            [self.photoBrowers addObject:dict];
            
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置图片的尺寸和位置
    int photosCount = (int)self.photos.count;
    int maxCol = XFStatusPhotoMaxCol(photosCount);
    
    // 根据photosCount计算出列数
    int col = (photosCount >= maxCol)? maxCol : photosCount;
    CGFloat width = self.yq_width;
    CGFloat photoW = (width - YQStatusCellSpacing*(col-1)) / col;
    CGFloat photoH = photoW;
    // 只有1张图片
    if (self.photos.count == 1) {
        photoW = width;
        photoH = photoW * 1.3;
    }
    
    
    for (int i = 0; i<photosCount; i++) {
        YQDiscoverPhotoView *photoView = self.subviews[i];
        int col = i % maxCol;
        photoView.yq_x = col * (photoW + YQStatusCellSpacing);
        
        int row = i / maxCol;
        photoView.yq_y = row * (photoH + YQStatusCellSpacing);
        photoView.yq_width = photoW;
        photoView.yq_height = photoH;
    }
    
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewSelected:photoView:photoViewArray:)]) {
        [self.delegate photoViewSelected:self photoView:(YQDiscoverPhotoView *)sender.view photoViewArray:self.photoBrowers];
    }
}

#pragma mark - public

+ (CGSize)sizeWithCount:(int)count superWidth:(CGFloat)width
{
    // 最大列数（一行最多有多少列）
    int maxCols = XFStatusPhotoMaxCol(count);
    
    CGFloat photoW = (width-YQStatusCellPadding*2-YQStatusCellSpacing*2)/3;
    CGFloat photoH = photoW;
    
    int cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * photoW + (cols - 1) * YQStatusCellSpacing;
    
    // 行数
    int rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * photoH + (rows - 1) * YQStatusCellSpacing;
    
    // 只有1张图片
    if (count == 1) {
        photosW = (width-YQStatusCellPadding*2-YQStatusCellSpacing*2)/2;
        photosH = photosW * 1.3;
    }
    
    return CGSizeMake(photosW, photosH);
}

@end
