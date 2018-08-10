//
//  ShareIconView.m
//  dianshang
//
//  Created by yunjobs on 2017/9/18.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ShareIconView.h"
#import "YQCustomButton.h"
#import "ShareIconItem.h"

@interface ShareIconView ()

@property (nonatomic, strong) UIView *view;

@end

@implementation ShareIconView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        [self addView];
    }
    return self;
}


- (void)addView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.yq_height-240, self.yq_width, 240)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.view = view;
}

- (void)setItems:(NSMutableArray<ShareIconItem *> *)items
{
    _items = items;
    [self setUp];
}

- (void)setUp
{
    int x = 0;
    int y = 0;
    
    if (self.column == 0) {
        self.column = self.items.count;
    }
    float row = ceil((float)self.items.count / self.column); // 行数(向上取整)
    
    float buttonW = APP_WIDTH / self.column;
    float buttonH = buttonW*1.2;
    
    self.view.yq_height = buttonH * row + APP_BottomH;
    self.view.yq_y = self.yq_height - self.view.yq_height;
    
    for (int i = 0; i < self.items.count; i++)
    {
        ShareIconItem *item = [self.items objectAtIndex:i];
        
        float buttonX = x * buttonW;
        float buttonY = y * buttonH;
        
        YQCustomButton *button = [[YQCustomButton alloc] init];
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button setImage:[UIImage imageNamed:item.icon] forState:UIControlStateNormal];
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setSubTitle:item.subTitle];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.type = CustomButtonTypeScale;
        //button.imageSize = CGSizeMake(42, 42);
        button.scale = 0.6;
        button.tag = i+1;
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        if (i==1) {
            //self.smsButton = button;
        }
        
        x++;
        if (x % self.column == 0) {
            y++;
            x=0;
        }
    }
}

#pragma mark - 事件

- (void)tapClick:(UIGestureRecognizer *)sender
{
    [self hideAnimate];
}

- (void)buttonClick:(UIButton *)sender
{
    [self hideAnimate];
    if (self.buttonPress) {
        self.buttonPress(sender.tag);
    }
}

- (void)showAnimate
{
    self.hidden = NO;
    //加载到windows上
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.view.transform = CGAffineTransformMakeTranslation(0, self.view.yq_height);
    
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
        self.view.transform = CGAffineTransformMakeTranslation(0, self.view.yq_height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
