//
//  YQEvaluateView.m
//  dianshang
//
//  Created by yunjobs on 2017/11/24.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQEvaluateView.h"

@interface YQEvaluateView()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) NSArray *statusArr;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation YQEvaluateView

- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.statusArr = @[@"很差",@"差",@"一般",@"好",@"非常好"];
        [self initView:frame];
    }
    return self;
}

- (void)initView:(CGRect)frame
{
    CGFloat height = frame.size.height;
    
    CGFloat h = 40;
    CGFloat w = h;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (height-h)*0.5, 70, h)];
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    //label.backgroundColor = RandomColor;
    [self addSubview:label];
    self.label = label;
    
    CGFloat right = label.yq_right;
    for (int j = 0; j < 5; j++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(label.yq_right+w*j, (height-h)*0.5, h, h)];
        button.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [button setImage:[UIImage imageNamed:@"icon_xing"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"icon_unxing"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(xingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //button.backgroundColor = RandomColor;
        [self addSubview:button];
        button.tag = j;
        [self.buttons addObject:button];
        button.selected = YES;
        if (j == 4) {
            right = button.yq_right;
        }
    }
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(right+8, (height-h)*0.5, 60, h)];
    label1.textColor = RGB(102, 102, 102);
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = self.statusArr.lastObject;
    [self addSubview:label1];
    self.statusLabel = label1;
    
    self.resultStr = [NSString stringWithFormat:@"%d",5*20];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.label.text = title;
}

- (void)xingBtnClick:(UIButton *)sender
{
    for (UIButton *button in self.buttons) {
        button.selected = sender.tag >= button.tag;
    }
    self.resultStr = [NSString stringWithFormat:@"%li",(sender.tag +1)*20];
    self.statusLabel.text = self.statusArr[sender.tag];
}

@end
