//
//  DeliveryJobCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DeliveryJobCell.h"
#import "HomeJobEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DeliveryJobCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cHeadImgV;
@property (weak, nonatomic) IBOutlet UILabel *cNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *cPositionLbl;
@property (weak, nonatomic) IBOutlet UILabel *cAddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *rnameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation DeliveryJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commentBtn.hidden = YES;
    
    self.commentBtn.layer.cornerRadius = self.commentBtn.yq_height *0.5;
    self.commentBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.commentBtn.layer.borderWidth = 1.0f;
    [self.commentBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.statusLbl.textColor = THEMECOLOR;
    self.statusLbl.hidden = YES;
    self.timeLbl.hidden = YES;
}

- (void)setEntity:(HomeJobEntity *)entity
{
    _entity = entity;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.logo];
    [self.cHeadImgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    
    self.cNameLbl.text = entity.pname;
    self.cPositionLbl.text = entity.cname;
    self.cAddressLbl.text = entity.address;
    
    if (self.curTable == 0) {
        self.commentBtn.hidden = NO;
        if ([entity.cdealwith isEqualToString:@"3"]){
            // 面试详情
            [self normalCommentTitle:@"待面试" hidden:NO];
        }else if ([entity.cdealwith isEqualToString:@"4"]){
            [self grayCommentTitle:@"不合适"];
        }else if ([entity.cdealwith isEqualToString:@"5"]){
            [self grayCommentTitle:@"已通过"];
        }else{
            self.commentBtn.hidden = YES;
        }
    }else{
        self.commentBtn.hidden = YES;
    }
    
    if (entity.rname.length > 0) {
        self.rnameLbl.hidden = NO;
        self.rnameLbl.text = [NSString stringWithFormat:@"推荐人:%@ 靠谱值:%@",entity.rname,entity.reliable];
    }else{
        self.rnameLbl.hidden = YES;
    }
}

- (void)normalCommentTitle:(NSString *)str hidden:(BOOL)hidden
{
    self.commentBtn.layer.borderColor = THEMECOLOR.CGColor;
    [self.commentBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.commentBtn setTitle:str forState:UIControlStateNormal];
    
    self.commentBtn.hidden = hidden;
}

- (void)grayCommentTitle:(NSString *)str
{
    self.commentBtn.layer.borderColor = RGB(180, 180, 180).CGColor;
    [self.commentBtn setTitleColor:RGB(180, 180, 180) forState:UIControlStateNormal];
    [self.commentBtn setTitle:str forState:UIControlStateNormal];
    
    self.commentBtn.enabled = NO;
}

//- (void)setIsCommentBtn:(BOOL)isCommentBtn
//{
//    _isCommentBtn = isCommentBtn;
//
//    self.commentBtn.hidden = !isCommentBtn;
//}
//- (void)setCommentTitle:(NSString *)commentTitle
//{
//    _commentTitle = commentTitle;
//
//    [self.commentBtn setTitle:commentTitle forState:UIControlStateNormal];
//}
- (void)commentBtnClick:(UIButton *)sender
{
    if (self.commentBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.commentBlock(path, self.entity);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
