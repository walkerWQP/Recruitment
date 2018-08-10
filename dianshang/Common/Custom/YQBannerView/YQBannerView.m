//
//  YQBannerView.m
//  kuainiao
//
//  Created by yunjobs on 16/11/25.
//  Copyright © 2016年 yunjobs. All rights reserved.
//
#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#import "YQBannerView.h"
#import "YQPageControl.h"
#import <SDWebImage/UIImageView+WebCache.h>

// 滚动间隔时间
static CGFloat const chageImageTime = 5.0;

@interface YQBannerView ()<UIScrollViewDelegate>
{
    NSInteger currentImageIndex;
    
    BOOL isTimeUp;
    NSTimer *myTimer;
}
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) YQPageControl *pageControl;

@end

@implementation YQBannerView

- (YQPageControl *)pageControl
{
    if (_pageControl == nil) {
        float pageControlWidth = YQPageControlMarginLeft*2 + self.items.count*4 + YQPageControlItemSpacing*(self.items.count-1);
        float pagecontrolHeight = 15.0f;
        _pageControl = [[YQPageControl alloc] init];
        _pageControl.pageControlDotWH = 4;
        _pageControl.frame = CGRectMake(self.frame.size.width-pageControlWidth, CGRectGetMaxY(self.frame)-pagecontrolHeight, pageControlWidth, pagecontrolHeight);
        _pageControl.layer.cornerRadius = pagecontrolHeight*0.5;
        _pageControl.layer.masksToBounds = YES;
        _pageControl.backgroundColor = RGBA(100, 100, 100, 0.4);
        //_pageControl.hidden = YES; //默认不隐藏
        _pageControl.enabled = NO;
        [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
    }
    return _pageControl;
}
//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}

// 设置pageControl的显示位置
- (void)setPageControlShowStyle:(YQPageControlShowStyle)pageControlShowStyle
{
    _pageControlShowStyle = pageControlShowStyle;
    
    self.pageControl.hidden = NO;
    if (pageControlShowStyle == YQPageControlShowStyleNone) {
        self.pageControl.hidden = YES;
    }else if (pageControlShowStyle == YQPageControlShowStyleLeft) {
        CGRect frame = self.pageControl.frame;
        frame.origin.x = 0;
        self.pageControl.frame = frame;
    }else if (pageControlShowStyle == YQPageControlShowStyleCenter) {
        CGRect frame = self.pageControl.frame;
        frame.origin.x = (self.frame.size.width-frame.size.width)*0.5;
        self.pageControl.frame = frame;
    }else if (pageControlShowStyle == YQPageControlShowStyleRight) {
        CGRect frame = self.pageControl.frame;
        frame.origin.x = self.frame.size.width-frame.size.width;
        self.pageControl.frame = frame;
    }
}

// 设置有几张图片
- (void)setItems:(NSMutableArray *)items
{
    _items = items;
    [self setUp];
}

- (void)setUp
{
    if (myTimer) {
        [self stopTimer];
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
//    for (UIView *v in self.subviews) {
//        [v removeFromSuperview];
//    }
    
    CGFloat imageH = self.frame.size.height;
    CGFloat imageW = self.frame.size.width;
    
    // 设置scrollView
    self.contentSize = CGSizeMake(imageW*3, imageH);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.delegate = self;
    // 默认显示第二个imageView
    [self setContentOffset:CGPointMake(imageW, 0) animated:NO];
    
    // 创建左中右三个imageView
    for (int i = 0; i < 3; i++)
    {
        CGFloat imageX = i * imageW;
        CGFloat imageY = 0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        //imageView.backgroundColor = RandomColor;
        [self addSubview:imageView];
        YQBannerItem *item = nil;
        if (i == 0) {
            item = [self.items objectAtIndex:self.items.count-1];
            self.leftImageView = imageView;
        }else if (i == 1){
            item = [self.items objectAtIndex:0];
            self.centerImageView = imageView;
        }else{
            item = [self.items objectAtIndex:1];
            self.rightImageView = imageView;
        }
        // 设置默认图片
        [self imageView:imageView withImageStr:item.image];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
    // 添加一个计时器
    myTimer = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(updateImageView) userInfo:nil repeats:YES];
    isTimeUp = NO;
    
    // 创建UIPageControl
    self.pageControl.numberOfPages = self.items.count;
}

// X秒刷新一次图片视图
- (void)updateImageView
{
    [self setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:YES];
    // 延迟0.4f 执行重置图片
    isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 重置图片
    [self reloadImage];
    // 设置_pageControl
    self.pageControl.currentPage = currentImageIndex;
    
    // 回到第二个imageView
    [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    
    // 手动控制图片滚动后,应该三秒之后再次执行滚动 (重置计时器)
    // 只有通过 [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO]; 执行的 scrollViewDidEndDecelerating 才不需要重置计时器
    if (!isTimeUp) {
        [myTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    isTimeUp = NO;
}
// 重置图片
- (void)reloadImage
{
    NSInteger imageCount = self.items.count;
    CGPoint offset = self.contentOffset;
    // 根据滑动计算中间的是第几个
    if (offset.x > self.frame.size.width) { //向右滑动
        currentImageIndex = (currentImageIndex+1) % imageCount;
    }else if(offset.x < self.frame.size.width){ //向左滑动
        currentImageIndex = (currentImageIndex+imageCount-1) % imageCount;
    }
    // 重新设置中间的图片
    YQBannerItem *item = [self.items objectAtIndex:currentImageIndex];
    //_centerImageView.image = [UIImage imageNamed:item.image];
    [self imageView:_centerImageView withImageStr:item.image];
    
    // 重新设置左边的图片
    NSInteger leftIndex = (currentImageIndex + imageCount-1) % imageCount;
    YQBannerItem *leftItem = [self.items objectAtIndex:leftIndex];
    //_leftImageView.image = [UIImage imageNamed:leftItem.image];
    [self imageView:_leftImageView withImageStr:leftItem.image];
    
    // 重新设置右边的图片
    NSInteger rightIndex = (currentImageIndex+1) % imageCount;
    YQBannerItem *rightItem = [self.items objectAtIndex:rightIndex];
    //_rightImageView.image = [UIImage imageNamed:rightItem.image];
    [self imageView:_rightImageView withImageStr:rightItem.image];
}

// 根据字符串设置图片
- (void)imageView:(UIImageView *)imageView withImageStr:(NSString *)imageStr
{
    if ([imageStr hasPrefix:@"http"]) {
        //网络图片 请使用ego异步图片库
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }else{
        imageView.image = [UIImage imageNamed:imageStr];
    }
}

// 点击图片是调用
- (void)tapClick:(UIGestureRecognizer *)sender
{
    if (self.itemPress) {
        //YQBannerItem *item = [self.items objectAtIndex:currentImageIndex];
        self.itemPress(currentImageIndex,[self.items objectAtIndex:currentImageIndex]);
    }
}
- (void)itemPress:(void (^)(NSInteger, YQBannerItem *))block
{
    if (block) {
        self.itemPress = block;
    }
}

- (void)stopTimer
{
    [myTimer invalidate];
    myTimer = nil;
}





@end


@implementation YQBannerItem

+ (instancetype)itemWithDictionary:(NSDictionary *)dict
{
    YQBannerItem *item = [[YQBannerItem alloc] init];
    item.image = [dict objectForKey:@"image"];
    item.title = [dict objectForKey:@"title"];
    item.url = [dict objectForKey:@"url"];
    item.Id = [dict objectForKey:@"Id"];
    
    return item;
}

@end
