//
//  YQCustomRecvResumeCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQCustomRecvResumeCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YQCustomRecvResumeCell

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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 75)];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    [self addSubConstraint:bgView toView:self.bubbleView];
    
    NSDictionary *ext = model.message.ext;
    
    CGFloat width = bgView.frame.size.width;
    CGFloat height = bgView.frame.size.height;
    CGFloat left = 15;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    imageV.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    [bgView addSubview:imageV];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, width-left*2, 30)];
    //titleLbl.backgroundColor = [UIColor redColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = [ext objectForKey:kResumeDesFlag];
    titleLbl.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:titleLbl];
    
    CGFloat y = titleLbl.yq_bottom;
    CGFloat imgH = height-y-8;
    CGFloat imgW = imgH;
    
    UIImageView *headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(left, y, imgW, imgH)];
    NSString *url = [NSString stringWithFormat:@"%@",[ext objectForKey:kResumeImgFlag]];
    [headImgV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"EaseUIResource.bundle/user"]];
    [bgView addSubview:headImgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headImgV.yq_right+4, y, width-14-headImgV.yq_right, imgH)];
    //label.backgroundColor = [UIColor redColor];
    label.text = [ext objectForKey:kResumeTitleFlag];
    label.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:label];
    
    self.bubbleView.backgroundImageView.hidden = YES;
}

- (void)tapClick
{
    if (self.recvResumeDelegate && [self.recvResumeDelegate respondsToSelector:@selector(recvResumeClick:)]) {
        [self.recvResumeDelegate recvResumeClick:self.model];
    }
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    //[_bubbleView updateTextMargin:bubbleMargin];
}

+ (NSString *)cellIdentifier
{
    return @"YQCustomResumeMessageCell";
}
+ (CGFloat)cellHeight
{
    return 90;
}

- (void)addSubConstraint:(UIView *)view toView:(UIView *)cell
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.yq_width]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.yq_height]];
}

@end
