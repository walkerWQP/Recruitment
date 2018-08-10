//
//  HomeJobCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/8.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "HomeJobCell.h"
#import "HomeJobEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeJobCell ()

@property (weak, nonatomic) IBOutlet UILabel *jobNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *cName;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *cMangeNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *cManageJobLbl;
@property (weak, nonatomic) IBOutlet UILabel *jobPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *tryoutLbl;

@end

@implementation HomeJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cMangeNameLbl.textColor = THEMECOLOR;
    self.cManageJobLbl.textColor = THEMECOLOR;
    
    self.headImgView.layer.cornerRadius = self.headImgView.yq_height*0.5;
    self.headImgView.layer.masksToBounds = YES;
}

- (void)setEntity:(HomeJobEntity *)entity
{
    _entity = entity;
    
    self.jobNameLbl.text = entity.pname;
    if ([entity.pay hasPrefix:@"0"]) {
        self.jobSalaryLbl.text = @"面议";
    }else{
        self.jobSalaryLbl.text = [entity.pay stringByAppendingString:@"k"];
    }
    self.cName.text = entity.cname;
    if (entity.area!=nil) {
        self.addressLbl.text = [entity.city stringByAppendingString:entity.area];
    }else{
        self.addressLbl.text = entity.city;
    }
    self.cMangeNameLbl.text = entity.name;

    NSArray *array = @[@"无试用期",@"一个月",@"两个月",@"三个月"];
    self.tryoutLbl.text = [NSString stringWithFormat:@"试用期: %@",[array objectAtIndex:[entity.probation integerValue]]];
    
    if ([entity.consultant integerValue] == 0) {
        self.jobPriceLbl.text = @"无HR顾问费";
    }else{
        self.jobPriceLbl.text = [NSString stringWithFormat:@"HR顾问费: %@元",entity.consultant];
    }
    self.eduLbl.text = [[EZPublicList getEducationList] objectAtIndex:[entity.edu integerValue]];
    self.workLbl.text = [[EZPublicList getExperienceList] objectAtIndex:[entity.exprience integerValue]];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    self.cManageJobLbl.text = entity.post;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
