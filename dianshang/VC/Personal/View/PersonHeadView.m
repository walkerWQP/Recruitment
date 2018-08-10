//
//  PersonHeadView.m
//  dianshang
//
//  Created by yunjobs on 2017/9/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "PersonHeadView.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Accelerate/Accelerate.h>
#import "YQCustomButton.h"
#import "PersonItem.h"

#import "NSMutableAttributedString+YQStringConvertImage.h"

@interface PersonHeadView ()

@property (strong, nonatomic) UIView *buttonView;

@property (strong, nonatomic) UIImageView *headImg;
@property (strong, nonatomic) UIImageView *bgImage;

@property (nonatomic, strong) UILabel *nickNameLbl;
@property (nonatomic, strong) UILabel *balanceLbl;
@property (nonatomic, strong) UILabel *synopsisLbl;

@property (nonatomic, strong) NSArray *items;

@end

@implementation PersonHeadView

- (void)setBalance:(NSString *)balance
{
    _balance = balance;
    
    self.balanceLbl.text = balance;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    NSString *role = [UserEntity getIsCompany] ? @"2" : @"1";
    NSArray *array = [EZPublicList getPersonalHeadListRole:role];
    CGFloat column = 3.0;
    NSInteger row = ceil(array.count / column);
    CGFloat height = [PersonHeadView personHeadHeight];
    
    //self.backgroundColor = THEMECOLOR;
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, self.yq_width, height-(row*90)+30+200)];
    bgImage.backgroundColor = THEMECOLOR;
    bgImage.contentMode = UIViewContentModeScaleToFill;
//    bgImage.layer.masksToBounds = YES;
//    bgImage.userInteractionEnabled = YES;
    bgImage.image = [UIImage imageNamed:@"person_head_bg"];
    [self addSubview:bgImage];
    self.bgImage = bgImage;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.yq_width-60, 20, 50, 40)];
    [button setImage:[UIImage imageNamed:@"person_xiaoxi"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(mesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
//    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
//    bg.image = [UIImage imageNamed:@"headbg"];
//    bg.contentMode = UIViewContentModeScaleAspectFill;
//    bg.layer.masksToBounds = YES;
//    bg.userInteractionEnabled = YES;
//    [self addSubview:bg];
    
    //获取登录时保存的头像信息
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.yq_width-kHeadImgWH)*0.5, 40, kHeadImgWH, kHeadImgWH)];
    headImg.layer.cornerRadius = headImg.yq_height/2;
    headImg.layer.masksToBounds = YES;
    headImg.layer.borderColor = [UIColor colorWithWhite:0.831 alpha:1.000].CGColor;
    headImg.layer.borderWidth = 2;
    headImg.userInteractionEnabled = YES;
    headImg.image = [UIImage imageNamed:@"headImg"];//默认
    [self addSubview:headImg];
    self.headImg = headImg;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [headImg addGestureRecognizer:tap];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, headImg.yq_bottom+10, self.yq_width-30, 35)];
    nameLbl.text = @"昵称";
    nameLbl.font = [UIFont systemFontOfSize:17];
    nameLbl.textColor = [UIColor whiteColor];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLbl];
    self.nickNameLbl = nameLbl;
    
//    UILabel *desLbl = [[UILabel alloc] initWithFrame:CGRectMake(headImg.yq_right+15, nameLbl.yq_bottom+0, self.yq_width-headImg.yq_right-15-10, 35)];
//    //desLbl.text = @"这里是简介这里是简介这里是简介这里是简介这里是简介这里是简介";
//    desLbl.numberOfLines = 0;
//    desLbl.font = [UIFont systemFontOfSize:14];
//    desLbl.textColor = [UIColor whiteColor];
//    [self addSubview:desLbl];
//    self.synopsisLbl = desLbl;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(15, nameLbl.yq_bottom+15, self.yq_width-30, height-nameLbl.yq_bottom-30)];
    buttonView.backgroundColor = [UIColor whiteColor];
    buttonView.layer.cornerRadius = 10;
    [self addSubview:buttonView];
    self.buttonView = buttonView;
    
    self.items = array;
    CGFloat jianju = 5;
    
    CGFloat w = (buttonView.yq_width - jianju*(column+1)) / column;
    CGFloat h = (buttonView.yq_height - jianju*(row+1)) / row;
    
    CGFloat indexX = 0;
    CGFloat indexY = 0;
    for (int i = 1; i <= array.count; i++) {
        CGFloat x = indexX * w + (jianju*(indexX+1));
        CGFloat y = indexY * h + (jianju*(indexY+1));
        
        PersonItem *item = array[i-1];
        
        YQCustomButton *button = [[YQCustomButton alloc] init];
        button.frame = CGRectMake(x, y, w, h);
        [button setImage:[UIImage imageNamed:item.image] forState:UIControlStateNormal];
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setSubTitle:item.subTitle];
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.type = CustomButtonTypeFixedSize;
        button.imageSize = CGSizeMake(42, 42);
        button.tag = i-1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
        //button.backgroundColor = RandomColor;
        
        indexX++;
        if (i % 3 == 0) {
            indexX = 0;
            indexY ++;
        }
    }
    
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    
    NSString *a = @"";
    if ([[UserEntity getRealAuth] isEqualToString:@"1"]) {
        a = @"[认证]";
    }else{
        a = @"[未认证]";
    }
    nickName = [nickName stringByAppendingString:a];
    self.nickNameLbl.attributedText = [NSMutableAttributedString handleString:nickName];
}

- (void)setSynopsis:(NSString *)synopsis
{
    _synopsis = synopsis;
    
    self.synopsisLbl.text = synopsis;
}

- (void)setHeadImageUrl:(NSString *)headImageUrl
{
    _headImageUrl = headImageUrl;
    
    if ([headImageUrl hasPrefix:@"http"]) {
        NSURL *url = [NSURL URLWithString:headImageUrl];
        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
        // 尝试 从缓存里 拿出 图片
        [[mgr imageCache] queryCacheOperationForKey:[url absoluteString] done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
            if (image) {
                //self.bgImage.image = [self boxblurImage:image withBlurNumber:1];
                self.headImg.image = image;
            }else{
                [self.headImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headImg"] options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    //self.bgImage.image = [self boxblurImage:image withBlurNumber:1];
                    self.headImg.image = image;
                }];
                
            }
        }];
    }else{
        UIImage *image = [UIImage imageNamed:headImageUrl];
        //self.bgImage.image = [self boxblurImage:image withBlurNumber:1];
        self.headImg.image = image;
    }
}

- (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (image == nil) {
        return image;
    }
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    //CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headImageTap:)]) {
        [self.delegate headImageTap:(UIImageView *)sender.view];
    }
}

- (void)mesBtnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageBtnClick:)]) {
        [self.delegate messageBtnClick:sender];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonViewClick:item:)]) {
        PersonItem *item = self.items[sender.tag];
        [self.delegate buttonViewClick:sender item:item];
    }
}

// 穿透事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self || view == self.buttonView) {
        UIView *v = self.superview;
        for (UIView *a in v.subviews) {
            if ([a isKindOfClass:[UITableView class]]) {
                return a;
            }
        }
        return v;
    }
    return view;
}


+ (CGFloat)personHeadHeight
{
    NSString *role = [UserEntity getIsCompany] ? @"2" : @"1";
    NSArray *array = [EZPublicList getPersonalHeadListRole:role];
    NSInteger a = ceil(array.count / 3.0);
    return 200 + (a*90);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
