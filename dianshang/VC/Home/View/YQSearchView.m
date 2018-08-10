//
//  YQSearchView.m
//  kuainiao
//
//  Created by yunjobs on 16/12/12.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#define kQueryBtnW 50
#define kTextFieldH 30

#import "YQSearchView.h"

@interface YQSearchView ()<UITextFieldDelegate>
{
    NSArray *array;
}
@property (nonatomic, strong) UIButton *tempButton;

@property (nonatomic, strong) UIButton *buttonView;
@property (nonatomic, strong) UIView *buttonListView;

@end

@implementation YQSearchView

- (UIView *)buttonListView
{
    if (_buttonListView == nil) {
        _buttonListView = [[UIView alloc] initWithFrame:CGRectMake(8, 36, _buttonView.yq_width, 30*array.count)];
        _buttonListView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < array.count; i++) {
            NSString *str = [array objectAtIndex:i];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 30*i, _buttonListView.yq_width, 30)];
            [button setTitle:str forState:UIControlStateNormal];
            [button addTarget:self action:@selector(listClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:THEMECOLOR forState:UIControlStateSelected];
            [button setTitleColor:THEMECOLOR forState:UIControlStateHighlighted];
            [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
            if (i == 0) {
                button.selected = YES;
                self.tempButton = button;
            }
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            [_buttonListView addSubview:button];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, button.yq_bottom, button.yq_width, 0.5)];
            lineView.backgroundColor = RGB(153, 153, 153);
            [_buttonListView addSubview:lineView];
        }
        _buttonListView.layer.cornerRadius = 5;
        _buttonListView.layer.masksToBounds = YES;
        _buttonListView.layer.borderColor = RGB(153, 153, 153).CGColor;
        _buttonListView.layer.borderWidth = 0.5;
        _buttonListView.hidden = YES;
        [self addSubview:_buttonListView];
    }
    return _buttonListView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initSearchView:(NSArray *)myarray placeholder:(NSString *)placeholder searchTitle:(NSString *)title keyboardType:(UIKeyboardType )keyboardType
{
    array = myarray;
//    if (isCode) {
//        array = @[@"手机号",@"单号"];
//    }
    _buttonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [self setButton:_buttonView title:array.firstObject];
    //_buttonView.backgroundColor = RandomColor;
    _buttonView.titleLabel.font = [UIFont systemFontOfSize:13];
    _buttonView.titleLabel.adjustsFontSizeToFitWidth = YES;
    _buttonView.titleLabel.numberOfLines = 0;
    _buttonView.titleLabel.minimumScaleFactor = 11;
    [_buttonView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *textfield = [[UITextField alloc] init];
    textfield.frame = CGRectMake(0, (self.yq_height-kTextFieldH)*0.5, self.yq_width-kQueryBtnW-20, kTextFieldH);
    textfield.backgroundColor = RGB(241, 241, 241);
    textfield.layer.cornerRadius = kTextFieldH*0.5;
    textfield.layer.masksToBounds = YES;
    textfield.returnKeyType = UIReturnKeySearch;
    textfield.leftView = _buttonView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.placeholder = placeholder;
    textfield.font = [UIFont systemFontOfSize:13];
    textfield.keyboardType = keyboardType;
    textfield.delegate = self;
    self.textfield = textfield;
    [self performSelector:@selector(become) withObject:nil afterDelay:.7];
    [self addSubview:textfield];
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(textfield.yq_right, 0, kQueryBtnW, self.yq_height)];
    [queryBtn setTitle:title forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(queryClick:) forControlEvents:UIControlEventTouchUpInside];
    queryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:queryBtn];
}

- (void)setButton:(UIButton *)button title:(NSString *)title
{
    title = [NSString stringWithFormat:@"%@ \u25BE",title];
//    if (array.count>1) {
//    }
    
//    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
//    [mDic setObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
//    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:title];
//    [mStr addAttributes:mDic range:NSMakeRange(title.length-1, 1)];
//    
//    [button setAttributedTitle:mStr forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    //[button sizeToFit];
}

- (void)become
{
    [self.textfield becomeFirstResponder];
}

- (void)setCityStr:(NSString *)cityStr
{
    _cityStr = cityStr;
    
    [self setButton:_buttonView title:cityStr];
}

- (void)listClick:(UIButton *)sender
{
    self.buttonListView.hidden = YES;
    
    //[self.buttonView setTitle:sender.currentTitle forState:UIControlStateNormal];
    [self setButton:self.buttonView title:sender.currentTitle];
    
    self.tempButton.selected = NO;
    sender.selected = YES;
    self.tempButton = sender;
}

- (void)buttonClick:(UIButton *)sender
{
//    if (array.count>1) {
//        self.buttonListView.hidden = NO;
//    }
    if (self.searchViewCity) {
        self.searchViewCity();
    }
}

- (void)queryClick:(UIButton *)sender
{
    self.buttonListView.hidden = YES;
    [self.textfield resignFirstResponder];
    if (self.searchViewCancel) {
        self.searchViewCancel();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.buttonListView.hidden) {
        if (CGRectContainsPoint(self.buttonListView.frame, point)) {
            for (UIView *vv in self.buttonListView.subviews) {
                CGRect a = vv.frame;
                a.origin.y += self.buttonListView.yq_y;
                a.origin.x += self.buttonListView.yq_x;
                if (CGRectContainsPoint(a, point)) {
                    return vv;
                }
            }
        }
    }
    return [super hitTest:point withEvent:event];
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.beginEdit) {
        self.beginEdit(textField);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.query) {
        self.query(self.textfield.text, self.tempButton.tag);
    }
    return YES;
}
#pragma mark - 静态搜索框

- (void)initStaticSearchView:(NSString *)placeholder searchTitle:(NSString *)title
{
    UITextField *textfield = [[UITextField alloc] init];
    textfield.frame = CGRectMake(8, (self.yq_height-kTextFieldH)*0.5, self.yq_width-kQueryBtnW-8, kTextFieldH);
    textfield.backgroundColor = RGB(241, 241, 241);
    textfield.layer.cornerRadius = 4;
    textfield.layer.masksToBounds = YES;
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
    UIImageView *leftV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 15, 15)];
    leftV.image = [UIImage imageNamed:@"search"];
    [View addSubview:leftV];
    textfield.leftView = View;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.placeholder = placeholder;
    textfield.font = [UIFont systemFontOfSize:14];
    textfield.enabled = NO;
    [self addSubview:textfield];
    
    UILabel *queryLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.yq_right-kQueryBtnW, 0, kQueryBtnW, self.yq_height)];
    queryLbl.text = title;
    queryLbl.textAlignment = NSTextAlignmentCenter;
    queryLbl.textColor = THEMECOLOR;
    queryLbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:queryLbl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    if (self.press) {
        self.press();
    }
}

- (void)pressTap:(void (^)())block
{
    if (block) {
        self.press = block;
    }
}

@end

