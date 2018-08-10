//
//  CResumeDeliverCell.m
//  dianshang
//
//  Created by yunjobs on 2017/12/5.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CResumeDeliverCell.h"

#import "CompanyHomeEntity.h"

#import "NSString+MyDate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CResumeDeliverCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *positionLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *rnameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImg;
@end

@implementation CResumeDeliverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.closeBtn.hidden = YES;
    self.badgeImg.hidden = YES;
    
    self.payBtn.hidden = YES;
    self.payBtn.layer.cornerRadius = self.payBtn.yq_height *0.5;
    self.payBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.payBtn.layer.borderWidth = 1.0f;
    [self.payBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentBtn.layer.cornerRadius = self.commentBtn.yq_height *0.5;
    self.commentBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.commentBtn.layer.borderWidth = 1.0f;
    [self.commentBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headImgView.layer.cornerRadius = self.headImgView.yq_height * 0.5;
    self.headImgView.layer.masksToBounds = YES;
    
    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEntity:(CompanyHomeEntity *)entity
{
    _entity = entity;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    if ([entity.year isEqualToString:@""] || [entity.year isEqualToString:@"0"]) {
        self.workLbl.text = @"应届生";
    }else{
        self.workLbl.text = [entity.year stringByAppendingString:@"年"];
    }
    self.nameLbl.text = entity.name;
    self.cityLbl.text = entity.city;
    self.eduLbl.text = entity.edu;
    self.positionLbl.text = entity.pname;
    if (entity.rname.length > 0) {
        self.rnameLbl.text = [NSString stringWithFormat:@"推荐人:%@  靠谱值:%@",entity.rname,entity.reliable];
    }else{
        self.rnameLbl.text = @"";
    }
    
    if ([entity.see isEqualToString:@"1"]) {
        self.badgeImg.hidden = NO;
    }else{
        self.badgeImg.hidden = YES;
    }
    
    //self.closeBtn.hidden = self.curTable != 0;
    self.payBtn.hidden = YES;
    if (self.curTable == 0) {
        self.commentBtn.hidden = NO;
        if ([entity.cdealwith isEqualToString:@"1"]) {
            // 邀请面试
            [self normalCommentTitle:@"邀请面试" hidden:NO];
            
        }else if ([entity.cdealwith isEqualToString:@"3"]){
            // 面试详情
            [self normalCommentTitle:@"已邀请" hidden:NO];
        }else if ([entity.cdealwith isEqualToString:@"2"]){
            // 不合适
            [self grayCommentTitle:@"不合适"];
        }else{
            self.commentBtn.hidden = YES;
        }
    }else if (self.curTable == 1){
        if ([entity.cdealwith isEqualToString:@"3"]){
            // 面试详情
            [self normalCommentTitle:@"已邀请" hidden:NO];
        }else{
            self.commentBtn.hidden = YES;
        }
    }else if (self.curTable == 2){
        if ([entity.cdealwith isEqualToString:@"5"]){
            // 面试详情
            [self normalCommentTitle:@"是否入职" hidden:NO];
        }else if ([entity.cdealwith isEqualToString:@"4"]){
            // 面试详情
            [self grayCommentTitle:@"不合适"];
        }else{
            self.payBtn.hidden = NO;// 未面试按钮
            [self normalCommentTitle:@"是否通过" hidden:NO];
        }
    }else if (self.curTable == 3){
        if ([entity.cdealwith isEqualToString:@"6"]){
            // 面试详情
            //self.payBtn.hidden = NO;// 支付顾问费按钮
            [self normalCommentTitle:@"是否转正" hidden:NO];
        }else{
            self.commentBtn.hidden = YES;
        }
    }else if (self.curTable == 4){
        [self normalCommentTitle:@"已离职" hidden:NO];
    }else if (self.curTable == 5){
        self.commentBtn.hidden = YES;
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
    if (self.curTable == 0||self.curTable == 1) {
        // curTable == 0 邀请面试 // curTable == 0 面试详情
        if (self.invitationBlock) {
            NSIndexPath *path = [self indexPathWithView:sender];
            self.invitationBlock(path, self.entity);
        }
    }else{
        if (self.commentBlock) {
            NSIndexPath *path = [self indexPathWithView:sender];
            self.commentBlock(path, self.entity);
        }
    }
}
- (void)payBtnClick:(UIButton *)sender
{
    if (self.payBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.payBlock(path, self.entity);
    }
}

- (void)closeBtnClick:(UIButton *)sender
{
    if (self.closeBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.closeBlock(path, self.entity);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
