//
//  CFollowPersonCell.m
//  dianshang
//
//  Created by yunjobs on 2017/12/4.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CFollowPersonCell.h"
#import "CompanyHomeEntity.h"

#import "NSString+MyDate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CFollowPersonCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *positionLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@end

@implementation CFollowPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImgView.layer.cornerRadius = self.headImgView.yq_height * 0.5;
    self.headImgView.layer.masksToBounds = YES;
}

- (void)setEntity:(CompanyHomeEntity *)entity
{
    _entity = entity;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    NSString *workStr = [entity.year stringByAppendingString:@"年"];
    self.workLbl.text = [entity.year integerValue] == 0 ? @"应届生" : workStr;
    self.nameLbl.text = entity.name;
    self.cityLbl.text = entity.city;
    self.eduLbl.text = entity.edu;
    self.positionLbl.text = entity.pname;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
