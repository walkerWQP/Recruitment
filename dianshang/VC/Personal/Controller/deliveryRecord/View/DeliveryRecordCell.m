//
//  DeliveryRecordCell.m
//  dianshang
//
//  Created by yunjobs on 2017/12/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DeliveryRecordCell.h"

#import "HomeJobEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DeliveryRecordCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cHeadImgV;
@property (weak, nonatomic) IBOutlet UILabel *cNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *cPositionLbl;
@property (weak, nonatomic) IBOutlet UILabel *cAddressLbl;

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *invitationBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refuseConst;

@property (weak, nonatomic) IBOutlet UILabel *rNameLbl;
@end

@implementation DeliveryRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.refuseBtn.layer.cornerRadius = self.refuseBtn.yq_height *0.5;
    self.refuseBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.refuseBtn.layer.borderWidth = 1.0f;
    [self.refuseBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.refuseBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.refuseBtn.tag = 2;
    
    self.invitationBtn.layer.cornerRadius = self.invitationBtn.yq_height *0.5;
    self.invitationBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.invitationBtn.layer.borderWidth = 1.0f;
    [self.invitationBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.invitationBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.invitationBtn.tag = 3;
    
    self.agreeBtn.layer.cornerRadius = self.agreeBtn.yq_height *0.5;
    self.agreeBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.agreeBtn.layer.borderWidth = 1.0f;
    [self.agreeBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.agreeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.agreeBtn.tag = 1;
    
    self.invitationBtn.hidden = YES;
    self.agreeBtn.hidden = YES;
    
    self.timeLbl.hidden = YES;
    self.statusLbl.hidden = YES;
    self.statusLbl.textColor = THEMECOLOR;
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
        self.rNameLbl.text = @"";
    }else{
        if (entity.rname.length > 0) {
            self.rNameLbl.text = [NSString stringWithFormat:@"推荐人:%@ 靠谱值:%@",entity.rname,entity.reliable];
        }else{
            self.rNameLbl.text = @"";
        }
    }
    
    
    if (self.curTable == 0) {
        if ([entity.cdealwith isEqualToString:@"1"]) {
            // 等待邀请
            [self grayCommentTitle:@"等待邀请"];
        }else if ([entity.cdealwith isEqualToString:@"3"]){
            // 面试详情
            [self normalCommentTitle:@"邀请详情" hidden:NO];
        }else if ([entity.cdealwith isEqualToString:@"2"]){
            // 不合适
            [self grayCommentTitle:@"不合适"];
        }else{
            self.refuseBtn.hidden = YES;
            self.statusLbl.hidden = NO;
            self.statusLbl.text = @"已完成";
        }
    }else{
        self.agreeBtn.hidden = YES;
        self.invitationBtn.hidden = YES;
        if ([entity.cdealwith isEqualToString:@"1"]) {
            // 等待邀请
            [self normalCommentTitle:@"等待邀请" hidden:NO];
        }else if ([entity.cdealwith isEqualToString:@"3"]){
            // 同意/拒绝
            if ([entity.mdealwith isEqualToString:@"1"]) {
                [self normalCommentTitle:@"邀请详情" hidden:NO];
            }else if ([entity.mdealwith isEqualToString:@"2"]) {
                [self grayCommentTitle:@"已拒绝"];
            }else{
                [self normalCommentTitle:@"拒绝" hidden:NO];
                self.agreeBtn.hidden = NO;
                self.invitationBtn.hidden = NO;
            }
            
        }else if ([entity.cdealwith isEqualToString:@"2"]){
            // 不合适
            [self grayCommentTitle:@"不合适"];
        }else{
            self.refuseBtn.hidden = YES;
            self.statusLbl.hidden = NO;
            self.statusLbl.text = @"已完成";
        }
    }
    
}

- (void)normalCommentTitle:(NSString *)str hidden:(BOOL)hidden
{
    self.refuseBtn.layer.borderColor = THEMECOLOR.CGColor;
    [self.refuseBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.refuseBtn setTitle:str forState:UIControlStateNormal];
    
    self.refuseBtn.hidden = hidden;
}

- (void)grayCommentTitle:(NSString *)str
{
    self.refuseBtn.layer.borderColor = RGB(180, 180, 180).CGColor;
    [self.refuseBtn setTitleColor:RGB(180, 180, 180) forState:UIControlStateNormal];
    [self.refuseBtn setTitle:str forState:UIControlStateNormal];
    
    self.refuseBtn.enabled = NO;
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.curTable == 0) {
        if (self.detailBlock) {
            NSIndexPath *path = [self indexPathWithView:sender];
            self.detailBlock(path, self.entity);
        }
    }else{
        if (self.otherBlock) {
            NSIndexPath *path = [self indexPathWithView:sender];
            self.otherBlock(path, self.entity, sender.tag);
        }
    }
}

//- (void)setButtonTitle:(NSString *)buttonTitle
//{
//    _buttonTitle = buttonTitle;
//    
//    [self.refuseBtn setTitle:buttonTitle forState:UIControlStateNormal];
//}

//- (void)setIsAgreeBtn:(BOOL)isAgreeBtn
//{
//    self.agreeBtn.hidden = isAgreeBtn;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
