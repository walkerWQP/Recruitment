//
//  YQCustomSendWXMessageCell.m
//  huanxin
//
//  Created by yunjobs on 2017/10/12.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQCustomSendWXMessageCell.h"

CGFloat const CustomSendWXMessageCellPadding = 5;

@interface YQCustomSendWXMessageCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation YQCustomSendWXMessageCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    YQCustomSendWXMessageCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor whiteColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:15];
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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _titleLabel.textColor = _titleLabelColor;
    _titleLabel.font = _titleLabelFont;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.frame = CGRectMake(0, 0, 110, 26);
    _titleLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width *0.5, 20);
    _titleLabel.layer.cornerRadius = _titleLabel.frame.size.height *0.5;
    _titleLabel.layer.masksToBounds = YES;
    //self.backgroundColor = [UIColor yellowColor];
    
    [self _setupTitleLabelConstraints];
}

#pragma mark - Setup Constraints

- (void)_setupTitleLabelConstraints
{
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:CustomSendWXMessageCellPadding]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-CustomSendWXMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:26]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-CustomSendWXMessageCellPadding]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:CustomSendWXMessageCellPadding]];
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
    return @"YQCustomSendWXMessageCell";
}

+ (CGFloat)cellHeight
{
    return 40;
}

@end
