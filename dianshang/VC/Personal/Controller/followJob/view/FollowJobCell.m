//
//  FollowJobCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "FollowJobCell.h"
#import "HomeJobEntity.h"

#import "NSString+MyDate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FollowJobCell ()

@property (weak, nonatomic) IBOutlet UILabel *jobNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *cName;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation FollowJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.statusLbl.hidden = YES;
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
    
    self.eduLbl.text = [[EZPublicList getEducationList] objectAtIndex:[entity.edu integerValue]];
    self.workLbl.text = [[EZPublicList getExperienceList] objectAtIndex:[entity.exprience integerValue]];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.logo];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    //NSString *time = [NSString stringWithFormat:@"%@",entity.createtime];
    self.timeLbl.text = [NSString timeStampToString:entity.createtime formatter:@"MM-dd"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
