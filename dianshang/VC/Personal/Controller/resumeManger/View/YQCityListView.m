//
//  YQCityListView.m
//  kuainiao
//
//  Created by yunjobs on 16/12/21.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#define kFilterViewBackAlpha 0.3

#import "YQCityListView.h"

@interface YQCityListView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSInteger totalColumn;// 总共的列数
    
    NSInteger provinceIndex;
    NSInteger cityIndex;
    NSInteger areaIndex;
}
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSMutableDictionary *listArr;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *provListArr;
@property (nonatomic, strong) NSMutableArray *cityListArr;
@property (nonatomic, strong) NSMutableArray *areaListArr;
@end

@implementation YQCityListView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame column:2];
}

- (instancetype)initWithFrame:(CGRect)frame column:(NSInteger)column
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:kFilterViewBackAlpha];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        
        totalColumn = column;
        
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
    label.text = @"工作城市";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = RGB(102, 102, 102);
    [bottomView addSubview:label];
    self.titleLabel = label;
    
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
    self.areaListArr = [NSMutableArray array];
    //获取地区列表
    self.listArr = [NSMutableDictionary dictionaryWithDictionary:[EZPublicList getCityDict]];
    
    //[self setDefultProv:@"河南省" city:@"郑州市" area:@"金水区"];
}

- (void)setDefultProv:(NSString *)prov city:(NSString *)city area:(NSString *)area
{
    _provListArr = [NSMutableArray arrayWithArray:self.listArr.allKeys];
    provinceIndex = [_provListArr indexOfObject:prov];
    provinceIndex = provinceIndex>_provListArr.count ? 0 : provinceIndex;
    
    NSDictionary *dict00 = [self.listArr objectForKey:[self.provListArr objectAtIndex:provinceIndex]];
    _cityListArr = [NSMutableArray arrayWithArray:dict00.allKeys];
    cityIndex = [_cityListArr indexOfObject:city];
    cityIndex = cityIndex>_cityListArr.count ? 0 : cityIndex;
    
    NSArray *a = [dict00 objectForKey:[self.cityListArr objectAtIndex:cityIndex]];
    _areaListArr = [NSMutableArray arrayWithArray:a];
    areaIndex = [_areaListArr indexOfObject:area];
    areaIndex = areaIndex>_areaListArr.count ? 0 : areaIndex;
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
    if (totalColumn == 3) {
        [pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [pickerView selectRow:areaIndex inComponent:2 animated:YES];
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
    }else if (component == 2){
        return self.areaListArr.count;
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
    }else if (component == 2){
        return [self.areaListArr objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        provinceIndex = row;
        cityIndex = 0;
        areaIndex = 0;
        [self updateListArr];
        
        if (totalColumn >= 2) {
            [pickerView selectRow:cityIndex inComponent:1 animated:YES];
            [self.pickerView reloadComponent:1];
        }
        
        if (totalColumn == 3) {
            [pickerView selectRow:areaIndex inComponent:2 animated:YES];
            [self.pickerView reloadComponent:2];
        }
        
    }else if (component == 1){
        cityIndex = row;
        areaIndex = 0;
        [self updateListArr];
        
        if (totalColumn == 3) {
            [pickerView selectRow:areaIndex inComponent:2 animated:YES];
            [self.pickerView reloadComponent:2];
        }
        
    }else if (component == 2){
        areaIndex = row;
    }
    
}

- (void)updateListArr
{
    _provListArr = [NSMutableArray arrayWithArray:self.listArr.allKeys];
    
    NSDictionary *dict00 = [self.listArr objectForKey:[self.provListArr objectAtIndex:provinceIndex]];
    _cityListArr = [NSMutableArray arrayWithArray:dict00.allKeys];
    
    NSArray *a = [dict00 objectForKey:[self.cityListArr objectAtIndex:cityIndex]];
    _areaListArr = [NSMutableArray arrayWithArray:a];
}
-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    
    self.titleLabel.text = titleStr;
}

- (void)setDefultCityStr:(NSString *)defultCityStr
{
    _defultCityStr = defultCityStr;
    
    NSString *province = @"";
    for (NSString *key in self.listArr) {
        NSDictionary *cityDict = [self.listArr objectForKey:key];
        int flag = 0;
        for (NSString *citykey in cityDict) {
            if ([citykey isEqual:defultCityStr]) {
                province = key;
                flag ++;
                break;
            }
        }
        if (flag!=0) {
            break;
        }
    }
    
    [self setDefultProv:province city:defultCityStr area:@"金水区"];
    
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(zhixing) userInfo:nil repeats:NO];
}

- (void)zhixing
{
    [self.pickerView selectRow:provinceIndex inComponent:0 animated:NO];
    //[self.pickerView reloadComponent:0];
    if (totalColumn >= 2) {
        [self.pickerView selectRow:cityIndex inComponent:1 animated:NO];
        //        [self.pickerView reloadComponent:1];
    }
    if (totalColumn == 3) {
        [self.pickerView selectRow:areaIndex inComponent:2 animated:NO];
        //        [self.pickerView reloadComponent:2];
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
            NSString *provStr = [_provListArr objectAtIndex:provinceIndex];
            NSString *cityStr = [_cityListArr objectAtIndex:cityIndex];
            NSString *areaStr = [_areaListArr objectAtIndex:areaIndex];
            self.buttonPress(provStr,cityStr,areaStr);
        }
    }
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    //[self hideAnimate];
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
