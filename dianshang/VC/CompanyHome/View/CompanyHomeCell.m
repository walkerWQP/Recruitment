//
//  CompanyHomeCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyHomeCell.h"
#import "CompanyHomeEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CompanyHomeCell()

@property (weak, nonatomic) IBOutlet UILabel *jobNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *salaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@end

@implementation CompanyHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImgView.layer.cornerRadius = self.headImgView.yq_height *0.5;
    self.headImgView.layer.masksToBounds = YES;
}

- (void)setEntity:(CompanyHomeEntity *)entity
{
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    self.nameLbl.text = entity.name;
    NSString *workStr = [entity.year stringByAppendingString:@"年"];
    self.workLbl.text = [entity.year integerValue] == 0 ? @"应届生" : workStr;
    //self.workLbl.text = [entity.workStr stringByAppendingString:@"年"];
    self.salaryLbl.text = entity.salary;
    self.eduLbl.text = entity.edu;
    self.jobNameLbl.text = entity.pname;
    self.detailLbl.text = entity.desc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
