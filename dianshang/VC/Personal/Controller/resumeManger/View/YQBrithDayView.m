//
//  YQBrithDayView.m
//  dianshang
//
//  Created by yunjobs on 2017/9/21.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQBrithDayView.h"
#import "NSString+MyDate.h"

@interface YQBrithDayView ()
{
    
}
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIDatePicker *datePicker;

// 是否添加至今按钮
@property (nonatomic, assign) BOOL isSofar;

@end

@implementation YQBrithDayView

- (instancetype)initWithFrame:(CGRect)frame isSofor:(BOOL)isSofor
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        self.isSofar = isSofor;
        [self addView];
    }
    return self;
}
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
    if (self.isSofar) {
        arr = @[@"确定",@"至今"];
    }
    //根据模型创建button和DateView
    for (int i = 0; i < arr.count; i++) {
        
        CGFloat buttonX = bottomView.yq_width - buttonW*(i+1) - jianju*(i+1);
        CGFloat buttonY = 5;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [bottomView addSubview:button];
        
        if (i == 0) {
            [self setButton:button];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self setButton1:button];
            [button addTarget:self action:@selector(soforClick:) forControlEvents:UIControlEventTouchUpInside];
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
    // 创建日期选择控件
    UIDatePicker *dateP = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.view.yq_width, 200)];
    _datePicker = dateP;
    // 设置日期模式,年月日
    dateP.datePickerMode = UIDatePickerModeDate;
    // 设置地区 zh:中国标识
    dateP.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [dateP addTarget:self action:@selector(dateChamge:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dateP];
    
    [self setMaxDate:[NSDate date]];
    NSDate *minDate = [NSString stringToDate:@"1950-01-01" formatter:@"YYYY-MM-dd"];
    [self setMinDate:minDate];
    
    self.text = [NSString dateToString:[NSDate date] formatter:@"YYYY-MM-dd"];
}

- (void)setMaxDate:(NSDate *)date
{
    self.datePicker.maximumDate = date;
}

- (void)setMinDate:(NSDate *)date
{
    self.datePicker.minimumDate = date;
}

// 只要UIDatePicker选中的时候调用
- (void)dateChamge:(UIDatePicker *)picker
{
    // 2015-09-06 yyyy-MM-dd
    // 创建一个日期格式字符串对象
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    self.text = [fmt stringFromDate:picker.date];
    if (self.dateBlock) {
        self.dateBlock(self.text);
    }
}

#pragma mark - 事件

- (void)soforClick:(UIButton *)sender
{
    [self hideAnimate];
    if (self.dateBlock) {
        self.dateBlock(@"至今");
    }
}

- (void)buttonClick:(UIButton *)sender
{
    [self hideAnimate];
    if (self.submitBlock) {
        self.submitBlock(self.text);
    }
//    if (sender.tag == 1) {
//        [self hideAnimate];
//    }else if(sender.tag == 0){
//        if (self.buttonPress) {
//            [self hideAnimate];
//            self.buttonPress(self.text);
//        }
//    }
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
