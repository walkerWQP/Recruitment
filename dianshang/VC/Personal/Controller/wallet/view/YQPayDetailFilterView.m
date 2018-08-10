//
//  YQPayDetailFilterView.m
//  kuainiao
//
//  Created by yunjobs on 16/12/15.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#define kFilterViewBackAlpha 0.3

#import "YQPayDetailFilterView.h"

@interface YQPayDetailFilterView ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *curBtn;

@end

@implementation YQPayDetailFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:kFilterViewBackAlpha];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        [self addView];
    }
    return self;
}

- (void)addView
{
    NSArray *array = @[@"全部",@"收入",@"提现"];
    
    CGFloat top = 10;
    CGFloat left = 5;
    CGFloat jianju = 10;
    CGFloat buttonh = 35;
    
    NSInteger column = 3.0;
    CGFloat row = ceilf(array.count / (CGFloat)column);
    
    CGFloat viewH = top*2 + (row+1)*jianju + row*buttonh;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.yq_width, viewH)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.view = view;
    
    CGFloat buttonw = (self.yq_width-(column+1)*jianju-left*2) / column;
    
    int x = 0;
    int y = 0;
    for (int i = 1; i<=array.count; i++) {
        
        CGFloat buttonx = (jianju*(x+1)) + x*buttonw + left;
        CGFloat buttony = (jianju*(y+1)) + y*buttonh + top;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonx, buttony, buttonw, buttonh)];
        [button setTitle:[array objectAtIndex:i-1] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:blueBtnNormal forState:UIControlStateSelected];
        [button setBackgroundColor:blueBtnNormal forState:UIControlStateHighlighted];
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = RGB(225, 225, 225).CGColor;
        button.layer.masksToBounds = YES;
        button.tag = i-1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        if (i == 1) {
            button.selected = YES;
            self.curBtn = button;
        }
        
        x++;
        if (i % column == 0) {
            x = 0;
            y++;
        }
    }
    
}

- (void)buttonClick:(UIButton *)sender
{
    [self hideAnimate];
    if ([sender isEqual:self.curBtn]) {
        if (self.buttonPress) {
            self.buttonPress(sender.tag,NO);
        }
    }else{
        if (self.buttonPress) {
            self.buttonPress(sender.tag,YES);
        }
    }
    self.curBtn.selected = NO;
    sender.selected = YES;
    self.curBtn = sender;
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    [self hideAnimate];
    if (self.buttonPress) {
        self.buttonPress(sender.view.tag,NO);
    }
}

- (void)buttonPress:(void(^)(NSInteger, BOOL ))block
{
    if (block) {
        self.buttonPress = block;
    }
}

- (void)showAnimate
{
    //加载到windows上
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.view.yq_y = -self.view.yq_height;
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.view.yq_y = 0;
    }];
}

- (void)hideAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
        self.view.yq_y = -self.view.yq_height;
    } completion:^(BOOL finished) {
        //[self removeFromSuperview];
    }];
}

@end
