//
//  HQPickerView.m
//  HQPickerView
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 judian. All rights reserved.
//

#import "HQPickerView.h"

@interface HQPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIView *view;

@end

@implementation HQPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        [self addView];
    }
    return self;
}


- (void)addView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.yq_height-(240+APP_BottomH), self.yq_width, (240+APP_BottomH))];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.view = view;
    
    //[self setUpData];
    
    [self initBottomView];
    [self apickerView];
}
- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.yq_width, 40)];
    bottomView.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:bottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.yq_width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.737 alpha:1.000];
    [bottomView addSubview:lineView];
    
    CGFloat buttonW = 60;
    CGFloat buttonH = bottomView.yq_height-10;
    CGFloat jianju = 10;
    //NSArray *arr = @[@"确定",@"取消"];
    NSArray *arr = @[@"确定"];
    //根据模型创建button和DateView
    for (int i = 0; i < arr.count; i++) {
        
        CGFloat buttonX = bottomView.yq_width - buttonW*(i+1) - jianju*(i+1);
        CGFloat buttonY = 5;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
        if (i == 0) {
            [self setButton:button];
        }else{
            [self setButton1:button];
        }
    }
}
- (void)setButton1:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    sender.layer.cornerRadius = 3;
    sender.layer.borderColor = RGB(120, 120, 120).CGColor;
    sender.layer.borderWidth = 1;
    sender.layer.masksToBounds = YES;
    [sender setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
    [sender setBackgroundColor:RGB(243, 243, 243) forState:UIControlStateHighlighted];
}

- (void)setButton:(UIButton *)sender
{
    sender.backgroundColor = THEMECOLOR;
    sender.layer.cornerRadius = 3;
    sender.layer.masksToBounds = YES;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:BTNBACKGROUND forState:UIControlStateHighlighted];
}

// 初始化
- (void)apickerView
{
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_WIDTH, 180)];
    [self.view addSubview:self.pickerView];
}

#pragma mark-----UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.customArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.customArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.text = self.customArr[row];
}

- (void)setCustomArr:(NSArray *)customArr {
    _customArr = customArr;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

#pragma mark - 事件

- (void)buttonClick:(UIButton *)sender
{
    [self hideAnimate];
    NSString *str = [self.customArr objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:didSelectText:)]) {
        [self.delegate pickerView:self didSelectText:str];
    }
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    [self hideAnimate];
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
