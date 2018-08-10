//
//  YQDiscoverDetailCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQDiscoverDetailCell.h"
#import "YQDiscoverComment.h"
#import "YQToolBarButton.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YQDiscoverDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (strong, nonatomic) YQDiscoverCommentButton *praiseBtn;


@end

@implementation YQDiscoverDetailCell

- (YQDiscoverCommentButton *)praiseBtn
{
    if (_praiseBtn == nil) {
        YQDiscoverCommentButton *button = [[YQDiscoverCommentButton alloc] init];
        //button.backgroundColor = RandomColor;
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 10;
        [button setImage:[UIImage imageNamed:@"discover_unpraise"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"discover_praise"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _praiseBtn = button;
    }
    return _praiseBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLbl.textColor = RGB(102, 102, 102);
    self.contentLbl.textColor = RGB(51, 51, 51);
    self.contentLbl.font = [UIFont systemFontOfSize:14];
    self.titleLbl.font = [UIFont systemFontOfSize:14];
    self.headImgView.layer.cornerRadius = self.headImgView.yq_height*0.5;
    self.headImgView.layer.masksToBounds = YES;
    
    [self addSubConstraint:self.praiseBtn toView:self.contentView];
}

- (void)addSubConstraint:(UIView *)view toView:(UIView *)cell
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [cell addSubview:view];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.praiseBtnBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        if (path != nil) {
            self.praiseBtnBlock(path);
        }
    }
}

- (void)setEntity:(YQDiscoverComment *)entity
{
    self.titleLbl.text = entity.name;
    self.contentLbl.text = entity.commentText;
    
    self.praiseBtn.selected = entity.isPraise;
    
    if ([entity.avatar hasPrefix:@"http"]) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:entity.avatar] placeholderImage:[UIImage imageNamed:@"headImg"]];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    }
    
    if (entity.hot_count > 0) {
        if (entity.hot_count >= 1000) {
            [self.praiseBtn setTitle:@"999+" forState:UIControlStateNormal];
        }else{
            [self.praiseBtn setTitle:[NSString stringWithFormat:@"%li",entity.hot_count] forState:UIControlStateNormal];
        }
    }else{
        [self.praiseBtn setTitle:@"" forState:UIControlStateNormal];
    }
}



@end

@implementation YQDiscoverCommentButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float imageX = 0;
    float imageY = 0;
    float imageW = 0;
    float imageH = 0;
    
    float h = self.yq_width > self.yq_height ? self.yq_height : self.yq_width;
    imageW = h * 0.6;
    imageH = imageW;
    imageX = self.yq_width - imageW;
    imageY = (self.yq_height - imageH)*0.5;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    self.titleLabel.yq_x = 0;
    self.titleLabel.yq_width = self.yq_width - imageW-2;
    //self.titleLabel.center = CGPointMake(imageX+imageW, imageY);
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    //self.titleLabel.backgroundColor = [UIColor whiteColor];
}

@end



