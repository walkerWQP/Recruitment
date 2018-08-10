//
//  CircularClipView.m
//  MasonryDemo
//
//  Created by 杨淑园 on 15/11/17.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import "YSHYClipViewController.h"
@interface YSHYClipViewController ()

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation YSHYClipViewController

-(instancetype)initWithImage:(UIImage *)image
{
    if(self = [super init])
    {
        _image = [self fixOrientation:image];
        self.clipType = CIRCULARCLIP;
        self.radius = 120;
        self.scaleRation = 2;
        self.rectSize = CGSizeMake(120, 120);
    }
    return  self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CreatUI];
    [self addAllGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [super viewWillDisappear:animated];
}


-(void)CreatUI
{
    //验证 裁剪半径是否有效
    self.radius= self.radius > self.view.frame.size.width/2?self.view.frame.size.width/2:self.radius;
    
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = (_image.size.height / _image.size.width) * self.view.frame.size.width;
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _imageView = [[UIImageView alloc]init];
    [_imageView setImage:_image];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView setFrame:CGRectMake(0, 0, width, height)];
    [_imageView setCenter:self.view.center];
    self.OriginalFrame = _imageView.frame;
    [self.view addSubview:_imageView];
    
    //覆盖层
    UIView *_overView1 = [[UIView alloc]init];
    [_overView1 setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.500]];
    [_overView1 setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:_overView1];
    _overView = [[UIView alloc]init];
    [_overView setBackgroundColor:[UIColor clearColor]];
    _overView.opaque = NO;
    [_overView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view addSubview:_overView];
    
    //白色方框
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (APP_HEIGHT-_rectSize.height)/2, 1, _rectSize.height)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, (APP_HEIGHT-_rectSize.height)/2, _rectSize.width, 1)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView1];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, lineView1.yq_y+_rectSize.height-1, _rectSize.width, 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(lineView.yq_x+_rectSize.width-1, lineView1.yq_y, 1, _rectSize.height)];
    lineView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView3];
    
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT-44, APP_WIDTH, 44)];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.300];
    [self.view addSubview:_bottomView];
    
    UIButton *remakeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [remakeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [remakeBtn addTarget:self action:@selector(remakeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [remakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomView addSubview:remakeBtn];
    UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(APP_WIDTH-80, 0, 80, 44)];
    [chooseBtn setTitle:@"选取" forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomView addSubview:chooseBtn];
    
    [self drawClipPath:self.clipType];
    [self MakeImageViewFrameAdaptClipFrame];
}

//绘制裁剪框
-(void)drawClipPath:(ClipType )clipType
{
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = self.view.center;
    
    CGFloat clipWidth = self.rectSize.width;
    CGFloat clipHeight = self.rectSize.height;
    
    self.circularFrame = CGRectMake(center.x - clipWidth/2, center.y - clipHeight/2, clipWidth, clipHeight);
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
     CAShapeLayer *layer = [CAShapeLayer layer];
    if(clipType == CIRCULARCLIP)
    {
        //绘制圆形裁剪区域
        [path  appendPath:[UIBezierPath bezierPathWithArcCenter:self.view.center radius:self.radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    }
    else
    {
        [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(center.x - clipWidth/2, center.y - clipHeight/2, clipWidth, clipHeight)]];
    }
    [path setUsesEvenOddFillRule:YES];
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [[UIColor blackColor] CGColor];
    layer.opacity = 0.5;
    [_overView.layer addSublayer:layer];
}


//让图片自己适应裁剪框的大小
-(void)MakeImageViewFrameAdaptClipFrame
{
    CGFloat width = _imageView.frame.size.width ;
    CGFloat height = _imageView.frame.size.height;
    if(height < self.circularFrame.size.height)
    {
        width = (width / height) * self.circularFrame.size.height;
        height = self.circularFrame.size.height;
        CGRect frame = CGRectMake(0, 0, width, height);
        [_imageView setFrame:frame];
        [_imageView setCenter:self.view.center];
    }
}
-(void)addAllGesture
{
    //捏合手势
    UIPinchGestureRecognizer * pinGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinGesture:)];
    [self.view addGestureRecognizer:pinGesture];
    //拖动手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

-(void)handlePinGesture:(UIPinchGestureRecognizer *)pinGesture
{
    UIView * view = _imageView;
    if(pinGesture.state == UIGestureRecognizerStateBegan || pinGesture.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinGesture.scale, pinGesture.scale);
        pinGesture.scale = 1;
    }
    else if(pinGesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat ration =  view.frame.size.width /self.OriginalFrame.size.width;
        
        if(ration>_scaleRation)
        {
            CGRect newFrame =CGRectMake(0, 0, self.OriginalFrame.size.width * _scaleRation, self.OriginalFrame.size.height * _scaleRation);
            view.frame = newFrame;
        }else if (view.frame.size.width < self.circularFrame.size.width && self.OriginalFrame.size.width <= self.OriginalFrame.size.height)
        {
            CGFloat rat = self.OriginalFrame.size.height / self.OriginalFrame.size.width;
            CGRect newFrame =CGRectMake(0, 0, self.circularFrame.size.width , self.circularFrame.size.width * rat );
            view.frame = newFrame;
        }
        else if(view.frame.size.height< self.circularFrame.size.height && self.OriginalFrame.size.height <= self.OriginalFrame.size.width)
        {
            CGFloat rat = self.OriginalFrame.size.width / self.OriginalFrame.size.height;
            CGRect newFrame =CGRectMake(0, 0, self.circularFrame.size.height * rat, self.circularFrame.size.height );
            view.frame = newFrame;
        }
        if (self.circularFrame.size.width > self.circularFrame.size.height) {
            if (view.frame.size.width < self.circularFrame.size.width) {
                CGFloat rat = self.OriginalFrame.size.height / self.OriginalFrame.size.width;
                CGRect newFrame =CGRectMake(0, 0, self.circularFrame.size.width , self.circularFrame.size.width * rat );
                view.frame = newFrame;
            }else if (view.frame.size.height < self.circularFrame.size.height) {
                CGFloat rat = self.OriginalFrame.size.width / self.OriginalFrame.size.height;
                CGRect newFrame =CGRectMake(0, 0, self.circularFrame.size.height * rat, self.circularFrame.size.height );
                view.frame = newFrame;
            }
        }else if(self.circularFrame.size.width < self.circularFrame.size.height){
            if (view.frame.size.height < self.circularFrame.size.height) {
                CGFloat rat = self.OriginalFrame.size.width / self.OriginalFrame.size.height;
                CGRect newFrame =CGRectMake(0, 0, self.circularFrame.size.height * rat, self.circularFrame.size.height );
                view.frame = newFrame;
            }else if (view.frame.size.width < self.circularFrame.size.width) {
                CGFloat rat = self.OriginalFrame.size.height / self.OriginalFrame.size.width;
                CGRect newFrame =CGRectMake(0, 0, self.circularFrame.size.width , self.circularFrame.size.width * rat );
                view.frame = newFrame;
            }
        }
        
        [view setCenter:self.view.center];
        self.currentFrame = view.frame;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    UIView * view = _imageView;
   
    if(panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged)
    {
       CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        
        [panGesture setTranslation:CGPointZero inView:view.superview];
    }
    else if ( panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGRect currentFrame = view.frame;
        //向右滑动 并且超出裁剪范围后
        if(currentFrame.origin.x >= self.circularFrame.origin.x)
        {
            currentFrame.origin.x =self.circularFrame.origin.x;
            
        }
        //向下滑动 并且超出裁剪范围后
        if(currentFrame.origin.y >= self.circularFrame.origin.y)
        {
            currentFrame.origin.y = self.circularFrame.origin.y;
        }
        //向左滑动 并且超出裁剪范围后
        if(currentFrame.size.width + currentFrame.origin.x < self.circularFrame.origin.x + self.circularFrame.size.width)
        {
            CGFloat movedLeftX =fabs(currentFrame.size.width + currentFrame.origin.x -(self.circularFrame.origin.x + self.circularFrame.size.width));
            currentFrame.origin.x += movedLeftX;
        }
        //向上滑动 并且超出裁剪范围后
        if(currentFrame.size.height+currentFrame.origin.y < self.circularFrame.origin.y + self.circularFrame.size.height)
        {
            CGFloat moveUpY =fabs(currentFrame.size.height + currentFrame.origin.y -(self.circularFrame.origin.y + self.circularFrame.size.height));
            currentFrame.origin.y += moveUpY;
        }
        [UIView animateWithDuration:0.05 animations:^{
            [view setFrame:currentFrame];
        }];
    }
}
-(void)chooseBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate ClipViewController:self FinishClipImage:[self getSmallImage]];
}
-(void)remakeBtnClick:(UIButton *)btn
{
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    NSMutableArray *con = [[NSMutableArray alloc] init];
    for (int i = 0;i < controllers.count; i++) {
        id controller = [controllers objectAtIndex:i];
        if ([NSStringFromClass([controller class]) isEqualToString:@"PLUICameraViewController"]) {
            [con addObject:controller];
        }
    }
    [controllers removeObjectsInArray:con];
    [self.navigationController setViewControllers:controllers];
    if (controllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(UIImage *)fixOrientation:(UIImage *)image
{
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


//方形裁剪
-(UIImage *)getSmallImage
{
    CGFloat width= _imageView.frame.size.width;
    CGFloat rationScale = (width /_image.size.width);

    CGFloat origX = (self.circularFrame.origin.x - _imageView.frame.origin.x) / rationScale;
    CGFloat origY = (self.circularFrame.origin.y - _imageView.frame.origin.y) / rationScale;
    CGFloat oriWidth = self.circularFrame.size.width / rationScale;
    CGFloat oriHeight = self.circularFrame.size.height / rationScale;
  
    CGRect myRect = CGRectMake(origX, origY, oriWidth, oriHeight);
    CGImageRef  imageRef = CGImageCreateWithImageInRect(_image.CGImage, myRect);
    UIGraphicsBeginImageContext(myRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    // 潜在泄露问题
    CGImageRelease(imageRef);
    
    if(self.clipType == CIRCULARCLIP)
    return  [self CircularClipImage:clipImage];
    
    return clipImage;
}

//圆形图片
-(UIImage *)CircularClipImage:(UIImage *)image
{
    CGFloat arcCenterX = image.size.width/ 2;
    CGFloat arcCenterY = image.size.height / 2;
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddArc(context, arcCenterX , arcCenterY, image.size.width/ 2 , 0.0, 2*M_PI, NO);
    CGContextClip(context);
    CGRect myRect = CGRectMake(0 , 0, image.size.width ,  image.size.height);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}



@end
