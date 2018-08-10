//
//  ShareHRCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ShareHRCell.h"
#import "ShareHREntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShareHRCell ()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *positionLbl;
@property (weak, nonatomic) IBOutlet UILabel *salaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation ShareHRCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 初始化
    self.statusLbl.textColor = THEMECOLOR;
    self.statusLbl.hidden = YES;
    self.recommendBtn.hidden = YES;
    
    self.recommendBtn.layer.cornerRadius = self.recommendBtn.yq_height *0.5;
    self.recommendBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.recommendBtn.layer.borderWidth = 1.0f;
    [self.recommendBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.recommendBtn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headImgV.layer.cornerRadius = self.headImgV.yq_height *0.5;
    self.headImgV.layer.masksToBounds = YES;
}

- (void)setEntity:(ShareHREntity *)entity
{
    _entity = entity;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    self.nameLbl.text = entity.name;
    self.positionLbl.text = entity.posi_name;
    NSString *salary = [NSString stringWithFormat:@"%@-%@k",entity.low_salary,entity.top_salary];
    self.salaryLbl.text = salary;
    
    if ([entity.hrstart isEqualToString:@"2"]) {
        // 已推荐
        self.recommendBtn.layer.borderColor = RGB(180, 180, 180).CGColor;
        [self.recommendBtn setTitleColor:RGB(180, 180, 180) forState:UIControlStateNormal];
        [self.recommendBtn setTitle:@"已推荐" forState:UIControlStateNormal];
    }else if ([entity.hrstart isEqualToString:@"1"]){
        // 推荐
        self.recommendBtn.layer.borderColor = THEMECOLOR.CGColor;
        [self.recommendBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        [self.recommendBtn setTitle:@"推荐他" forState:UIControlStateNormal];
    }
    
    if ([entity.restatus isEqualToString:@"1"]||[entity.restatus isEqualToString:@"2"]) {
        self.typeLabel.text = @"在职";
        self.typeLabel.textColor = RGB(124, 124, 124);
    }else if ([entity.restatus isEqualToString:@"3"]){
        self.typeLabel.text = @"离职";
        self.typeLabel.textColor = RGB(124, 124, 124);
    }
    
}

- (void)setIsRecommendBtn:(BOOL)isRecommendBtn
{
    _isRecommendBtn = isRecommendBtn;
    
    self.recommendBtn.hidden = !isRecommendBtn;
    
    //self.statusLbl.hidden = isRecommendBtn;
}

- (void)setIsTypeLabel:(BOOL)isTypeLabel {
    
    _isTypeLabel = isTypeLabel;
    self.typeLabel.hidden = !isTypeLabel;
    
}

- (void)recommendBtnClick:(UIButton *)sender
{
    if (self.recommendBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.recommendBlock(path, self.entity);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
