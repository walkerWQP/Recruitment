//
//  YQCustomRecvWXMessageCell.m
//  huanxin
//
//  Created by yunjobs on 2017/10/12.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQCustomRecvWXMessageCell.h"
//#import "EaseBubbleView+Text.h"

@implementation YQCustomRecvWXMessageCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
}

#pragma mark - IModelCell

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    return YES;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
    //self.backgroundColor = RandomColor;
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 65)];
    [self addSubConstraint:bgView toView:self.bubbleView];
    //self.bubbleView.layer.masksToBounds = YES;
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(10, 30, 10, 30);
//    UIImage *image = [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"];
//    image = [image resizableImageWithCapInsets:insets];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    imageV.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    [bgView addSubview:imageV];
    
//    NSString *titleStr = @"";
//    NSString *lyqKey = [model.message.ext objectForKey:kKeyFlag];
//    if ([lyqKey isEqualToString:kWXFlag]) {
//        titleStr = @"我想要和您交换微信,您是否同意";
//    }else if ([lyqKey isEqualToString:kTelFlag]){
//        titleStr = @"我想要和您交换电话,您是否同意";
//    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 210, 25)];
    //label.backgroundColor = [UIColor redColor];
    label.text = [model.message.ext objectForKey:kRecvTextFlag];
    label.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame), 80, 30)];
    //button.backgroundColor = RandomColor;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"同意" forState:UIControlStateNormal];
    [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = RGB(102, 102, 102).CGColor;
    button.layer.borderWidth = .5f;
    [button addTarget:self action:@selector(AgreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 0;
    [bgView addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+8, CGRectGetMaxY(label.frame), 80, 30)];
    button1.backgroundColor = THEMECOLOR;
    [button1 addTarget:self action:@selector(RefuseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    button1.layer.cornerRadius = 5;
    button1.layer.masksToBounds = YES;
    [button1 setTitle:@"拒绝" forState:UIControlStateNormal];
    button1.tag = 1;
    [bgView addSubview:button1];
    
    self.bubbleView.backgroundImageView.hidden = YES;
}

- (void)RefuseButtonClick:(UIButton *)sender
{
    if (self.wxDelegate && [self.wxDelegate respondsToSelector:@selector(wxButtonClick:buttonIndex:)]) {
        [self.wxDelegate wxButtonClick:self.model buttonIndex:sender.tag];
    }
}
- (void)AgreeButtonClick:(UIButton *)sender
{
    if (self.wxDelegate && [self.wxDelegate respondsToSelector:@selector(wxButtonClick:buttonIndex:)]) {
        [self.wxDelegate wxButtonClick:self.model buttonIndex:sender.tag];
    }
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    //[_bubbleView updateTextMargin:bubbleMargin];
}
+ (CGFloat)cellHeight
{
    return 90;
}
+ (NSString *)cellIdentifier
{
    return @"YQCustomRecvWXMessageCell";
}

- (void)addSubConstraint:(UIView *)view toView:(UIView *)cell
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:230]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:65]];
}


@end
