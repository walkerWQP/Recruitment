//
//  YQDataPickerView.m
//  dianshang
//
//  Created by yunjobs on 2017/9/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
//static CGFloat bottomViewHeight = 240.0;

#import "YQDataPickerView.h"

@interface YQDataPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSInteger monthIndex;
    NSInteger yearIndex;
    
    BOOL isLastYear;
    NSInteger curMonth;
}
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *yearListArr;
@property (nonatomic, strong) NSMutableArray *monthListArr;
@property (nonatomic, strong) NSMutableArray *lastyearMonthListArr;
@end

@implementation YQDataPickerView

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
- (void)addView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.yq_height-(240+APP_BottomH), self.yq_width, (240+APP_BottomH))];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.view = view;
    
    [self setUpData];
    
    [self initBottomView];
    [self apickerView];
}

- (void)setUpData
{
    self.yearListArr = [[NSMutableArray alloc] init];
    self.monthListArr = [[NSMutableArray alloc] init];
    self.lastyearMonthListArr = [[NSMutableArray alloc] init];
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    
    curMonth = comp.month;
    for (int i = 1990; i <= comp.year; i++) {
        [self.yearListArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    for (int i = 1; i <= 12; i++) {
        [self.monthListArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 1; i <= curMonth; i++) {
        [self.lastyearMonthListArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

- (void)apickerView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.view.yq_width, 200)];
    //pickerView.backgroundColor = RandomColor;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
    
    [self.pickerView selectRow:self.yearListArr.count-2 inComponent:0 animated:YES];
    yearIndex = self.yearListArr.count-2;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.isMonth ? 2 : 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearListArr.count;
    }else if (component == 1){
        if (isLastYear) {
            //isLastYear = NO;
            return self.lastyearMonthListArr.count;
        }
        return self.monthListArr.count;
    }
    return 0;
}

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearListArr[row];
    }else if (component == 1){
        return self.monthListArr[row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0 ) {
        yearIndex = row;
        if (!_isMonth) {
//            if (self.buttonPress) {
//                NSString *yearStr = [self.yearListArr objectAtIndex:yearIndex];
//                self.buttonPress([yearStr stringByAppendingString:@"年"], @"");
//            }
        }else{
            if (row == self.yearListArr.count-1) {
                isLastYear = YES;
                [self.pickerView reloadComponent:1];
            }else{
                isLastYear = NO;
                [self.pickerView reloadComponent:1];
            }
        }
    }else if (component == 1){
        monthIndex = row;
    }
}

#pragma mark - 事件

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self hideAnimate];
    }else if(sender.tag == 0){
        if (self.buttonPress) {
            [self hideAnimate];
            NSString *yearStr = [self.yearListArr objectAtIndex:yearIndex];
            NSString *monthStr = [self.monthListArr objectAtIndex:monthIndex];
            self.buttonPress([yearStr stringByAppendingString:@"年"], [monthStr stringByAppendingString:@"月"]);
        }
    }
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    [self hideAnimate];
}

- (void)buttonPress:(buttonBlock)block
{
    if (block) {
        self.buttonPress = block;
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
