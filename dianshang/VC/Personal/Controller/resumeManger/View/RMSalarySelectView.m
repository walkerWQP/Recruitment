//
//  RMSalarySelectView.m
//  dianshang
//
//  Created by yunjobs on 2017/11/10.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define kFilterViewBackAlpha 0.3

#import "RMSalarySelectView.h"

@interface RMSalarySelectView()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSInteger totalColumn;
    
    NSInteger provinceIndex;
    NSInteger cityIndex;
}
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSMutableDictionary *listArr;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *provListArr;
@property (nonatomic, strong) NSMutableArray *cityListArr;

@end

@implementation RMSalarySelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:kFilterViewBackAlpha];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        totalColumn = 2;
        
        [self addView];
    }
    return self;
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.yq_width, 40)];
    bottomView.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
    label.text = @"薪资要求(月薪,单位:千元)";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = RGB(102, 102, 102);
    [bottomView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.yq_width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.737 alpha:1.000];
    [bottomView addSubview:lineView];
    
    CGFloat buttonW = 60;
    CGFloat buttonH = bottomView.yq_height-10;
    CGFloat jianju = 10;
    NSArray *arr = @[@"确定",@"取消"];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.yq_height-(220+APP_BottomH), self.yq_width, (220+APP_BottomH))];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.view = view;
    
    [self setUpData];
    
    [self initBottomView];
    [self apickerView];
}

- (void)setUpData
{
    self.listArr = [NSMutableDictionary dictionary];
    self.provListArr = [NSMutableArray array];
    self.cityListArr = [NSMutableArray array];
    
    // 添加数据
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    int step = 1;
    for (int i = 1; i <= 250; i+=step) {
        int jmax = i*2 > 260 ? 260 : i*2;
        NSMutableArray *array = [NSMutableArray array];
        for (int j = i+step; j <= jmax; j+=step) {
            [array addObject:[NSString stringWithFormat:@"%d",j]];
        }
        [_provListArr addObject:[NSString stringWithFormat:@"%d",i]];
        [mDict setObject:array forKey:[NSString stringWithFormat:@"%d",i]];
        if (i == 50) {
            step = 10;
        }
    }
    [_provListArr insertObject:@"面议" atIndex:0];
    [mDict setObject:@[@"面议"] forKey:@"面议"];
    
    self.listArr = mDict;
    
    [self setDefultProv:@"10" city:@"11"];
}

- (void)setDefultProv:(NSString *)prov city:(NSString *)city
{
    provinceIndex = [_provListArr indexOfObject:prov];
    provinceIndex = provinceIndex>_provListArr.count ? 0 : provinceIndex;
    
    _cityListArr = [self.listArr objectForKey:[self.provListArr objectAtIndex:provinceIndex]];
    cityIndex = [_cityListArr indexOfObject:city];
    cityIndex = cityIndex>_cityListArr.count ? 0 : cityIndex;
}

- (void)apickerView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.view.yq_width, 180)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
    
    [pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    if (totalColumn == 2) {
        [pickerView selectRow:cityIndex inComponent:1 animated:YES];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return totalColumn;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provListArr.count;
    }else if (component == 1){
        return self.cityListArr.count;
    }
    return 0;
}

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.provListArr objectAtIndex:row];
    }else if (component == 1){
        return [self.cityListArr objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        provinceIndex = row;
        cityIndex = 0;
        [self updateListArr];
        
        if (totalColumn == 2) {
            [pickerView selectRow:cityIndex inComponent:1 animated:YES];
            [self.pickerView reloadComponent:1];
        }
        
    }else if (component == 1){
        cityIndex = row;
        [self updateListArr];
    }
    
}

- (void)updateListArr
{
    _cityListArr = [self.listArr objectForKey:[self.provListArr objectAtIndex:provinceIndex]];
}


- (void)setMinStr:(NSString *)minStr MaxStr:(NSString *)maxStr;
{
    [self setDefultProv:minStr city:maxStr];
    
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(zhixing) userInfo:nil repeats:NO];
}

- (void)zhixing
{
    [self.pickerView selectRow:provinceIndex inComponent:0 animated:NO];
    if (totalColumn == 2) {
        [self.pickerView selectRow:cityIndex inComponent:1 animated:NO];
    }
}

#pragma mark - 事件

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self hideAnimate];
    }else if(sender.tag == 0){
        if (self.selectSalaryBlock) {
            [self hideAnimate];
            NSString *provStr = [_provListArr objectAtIndex:provinceIndex];
            NSString *cityStr = [_cityListArr objectAtIndex:cityIndex];
            self.selectSalaryBlock(provStr,cityStr);
        }
    }
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    //[self hideAnimate];
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
