//
//  RecommendOrderCell.m
//  dianshang
//
//  Created by yunjobs on 2017/12/15.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RecommendOrderCell.h"
#import "RecommendOrderEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+MyDate.h"

@interface RecommendOrderCell()
@property (weak, nonatomic) IBOutlet UILabel *orderLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIImageView *rHeadImgV;

@property (weak, nonatomic) IBOutlet UILabel *rnameLbl;

@property (weak, nonatomic) IBOutlet UILabel *positionLbl;

@property (weak, nonatomic) IBOutlet UILabel *costLbl;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UILabel *byTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *byDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *byMoneyLbl;
@end

@implementation RecommendOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.statusLbl.hidden = YES;
    
    self.rHeadImgV.layer.cornerRadius = self.rHeadImgV.yq_height *0.5;
    self.rHeadImgV.layer.masksToBounds = YES;
    
    self.payBtn.layer.cornerRadius = self.payBtn.yq_height *0.5;
    self.payBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.payBtn.layer.borderWidth = 1.0f;
    [self.payBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)normalCommentTitle:(NSString *)str hidden:(BOOL)hidden
{
    self.payBtn.layer.borderColor = THEMECOLOR.CGColor;
    [self.payBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.payBtn setTitle:str forState:UIControlStateNormal];
    
    self.payBtn.hidden = hidden;
}

- (void)grayCommentTitle:(NSString *)str
{
    self.payBtn.layer.borderColor = RGB(180, 180, 180).CGColor;
    [self.payBtn setTitleColor:RGB(180, 180, 180) forState:UIControlStateNormal];
    [self.payBtn setTitle:str forState:UIControlStateNormal];
    
    self.payBtn.enabled = NO;
}

- (void)redCommentTitle:(NSString *)str
{
    self.payBtn.layer.borderColor = [UIColor redColor].CGColor;
    [self.payBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.payBtn setTitle:str forState:UIControlStateNormal];
    
    self.payBtn.enabled = NO;
}

- (void)setEntity:(RecommendOrderEntity *)entity
{
    _entity = entity;
    
    self.statusLbl.text = [NSString timeStampToString:entity.checktime formatter:MMddHHmmss];
    
    self.orderLbl.text = [NSString stringWithFormat:@"订单号:%@",entity.ordernum];
    self.rnameLbl.text = [NSString stringWithFormat:@"%@ · %@",entity.sharename,entity.pname];
    NSArray *array = @[@"无试用期",@"一个月",@"两个月",@"三个月"];
    NSString *str0 = [array objectAtIndex:[entity.probation integerValue]];
    self.positionLbl.text = [NSString stringWithFormat:@"试用期:%@",str0];
    self.costLbl.text = [NSString stringWithFormat:@"顾问费:%@",entity.price];
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.shareavatar];
    [self.rHeadImgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    if ([entity.check isEqualToString:@"1"]) {
    
        self.byTitleLbl.text = @"";
        self.byDateLbl.text = @"";
        self.byMoneyLbl.text = @"";
        
        [self grayCommentTitle:@"已完成"];
        
    }else{
        
        if ([entity.overdue isEqualToString:@"1"]) {
            self.byTitleLbl.text = @"";
            self.byDateLbl.text = @"";
            self.byMoneyLbl.text = @"";
            
            [self redCommentTitle:@"已逾期"];
        }else{
            self.byTitleLbl.text = [NSString stringWithFormat:@"第%@期",entity.subOrder.time];
            NSString *str = [NSString timeStampToString:entity.subOrder.paytime formatter:YYYYMMdd];
            self.byDateLbl.text = [NSString stringWithFormat:@"付款日期:%@",str];
            self.byMoneyLbl.text = [NSString stringWithFormat:@"%@元",entity.subOrder.money];
            
            
            if ([entity.subOrder.orderstatus isEqualToString:@"1"]) {
                [self normalCommentTitle:@"去支付" hidden:NO];
            }else{
                [self grayCommentTitle:@"已支付"];
            }
        }
    }
}

- (void)setIsPayBtn:(BOOL)isPayBtn
{
    _isPayBtn = isPayBtn;
    
    self.payBtn.hidden = !isPayBtn;
}

- (void)payBtnClick:(UIButton *)sender
{
    if (self.payBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.payBlock(path, self.entity);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
