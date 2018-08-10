//
//  PositionDetailView.m
//  dianshang
//
//  Created by yunjobs on 2017/11/22.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "PositionDetailView.h"
#import "PositionDetailEntity.h"

#import "NSString+YQWidthHeight.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PositionDetailView ()
{
    CGFloat detailH;
}
@property (weak, nonatomic) IBOutlet UILabel *positionName;//职位名
@property (weak, nonatomic) IBOutlet UILabel *salaryLbl;//薪资要求
@property (weak, nonatomic) IBOutlet UILabel *placeLbl;//地点城市
@property (weak, nonatomic) IBOutlet UILabel *workLbl;//工作经历
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;//教育经历
@property (weak, nonatomic) IBOutlet UIImageView *cHeadImgV;//公司头像
@property (weak, nonatomic) IBOutlet UILabel *cNameLbl;//公司名
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraintH;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;//公司地址
@property (weak, nonatomic) IBOutlet UILabel *cIndustryLbl;//福利
@property (weak, nonatomic) IBOutlet UILabel *tradeLbl;// 行业标签
@property (weak, nonatomic) IBOutlet UILabel *jobPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *tryoutLbl;
@end

@implementation PositionDetailView

+ (instancetype)detailView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (CGFloat)detailViewHeight:(PositionDetailEntity *)entity
{
    CGFloat h = [entity.ctag yq_stringHeightWithFixedWidth:APP_WIDTH-20 font:13];
    if (h < 16) {
        h = 16;
    }
    CGFloat TopVH = (230-16) + h;
    return TopVH+8;
}

- (void)setEntity:(PositionDetailEntity *)entity
{
    CGFloat h = [entity.ctag yq_stringHeightWithFixedWidth:APP_WIDTH-20 font:13];
    if (h < 16) {
        h = 16;
    }
    h = (230-16) + h;
    self.topViewConstraintH.constant = h;
    
    self.eduLbl.text = [[EZPublicList getEducationList] objectAtIndex:[entity.edu integerValue]];
    self.workLbl.text = [[EZPublicList getExperienceList] objectAtIndex:[entity.exprience integerValue]];
    self.placeLbl.text = [entity.city stringByAppendingFormat:@" %@",entity.area];
    self.positionName.text = entity.pname;
    //NSString *salary = [NSString stringWithFormat:@"%@-%@k",entity.paylow,entity.paytop];
    self.cIndustryLbl.text = entity.ctag;
    self.salaryLbl.text = entity.salary;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ImageURL,entity.logo];
    [self.cHeadImgV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    self.cNameLbl.text = entity.cname;
    self.tradeLbl.text = entity.tname;
    self.addressLbl.text = [NSString stringWithFormat:@"%@%@",entity.city,entity.address];
    
    NSArray *array = @[@"无试用期",@"一个月",@"两个月",@"三个月"];
    self.tryoutLbl.text = [NSString stringWithFormat:@"试用期: %@",[array objectAtIndex:[entity.probation integerValue]]];
    
    if ([entity.consultant integerValue] == 0) {
        self.jobPriceLbl.text = @"无HR顾问费";
    }else{
        self.jobPriceLbl.text = [NSString stringWithFormat:@"HR顾问费: %@元",entity.consultant];
    }
    
    //detailH = self.addressLbl.yq_bottom + 5 + 8;
}
- (IBAction)companyHomeClick:(UIButton *)sender
{
    if (self.companyHomePage) {
        self.companyHomePage(sender);
    }
}
- (IBAction)addressHomeClick:(UIButton *)sender {
    self.addressHomeClick(sender);
}



@end
