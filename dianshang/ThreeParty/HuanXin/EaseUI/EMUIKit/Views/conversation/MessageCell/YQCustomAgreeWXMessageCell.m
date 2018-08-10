//
//  YQCustomAgreeWXMessageCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQCustomAgreeWXMessageCell.h"

@interface YQCustomAgreeWXMessageCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation YQCustomAgreeWXMessageCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    YQCustomAgreeWXMessageCell *cell = [self appearance];
    cell.titleLabelColor = RGB(102, 102, 102);
    cell.titleLabelFont = [UIFont systemFontOfSize:14];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _setupSubview];
    }
    
    return self;
}

#pragma mark - setup subviews

- (void)_setupSubview
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    [self addSubConstraint:bgView];
    
    CGFloat h = 50;
    CGFloat w = h;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300-w-20, h)];
    //label.backgroundColor = [UIColor redColor];
    label.numberOfLines = 0;
    [bgView addSubview:label];
    self.titleLabel = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(300-w, 0, w, h)];
    button.backgroundColor = THEMECOLOR;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"复制" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(CopyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 0;
    [bgView addSubview:button];
}

- (void)CopyButtonClick:(UIButton *)sender
{
    NSArray *arr = [self.title componentsSeparatedByString:@":"];
    NSString *str = arr.lastObject;
    //系统级别
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
    [YQToast yq_ToastText:@"复制成功" bottomOffset:100];
}

#pragma mark - setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
    //    [_titleLabel sizeToFit];
    //
    //    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_titleLabel.yq_width+6]];
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}

#pragma mark - public

+ (NSString *)cellIdentifier
{
    return @"YQCustomAgreeWXMessageCell";
}

+ (CGFloat)cellHeight
{
    return 65;
}
- (void)addSubConstraint:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
}


@end
