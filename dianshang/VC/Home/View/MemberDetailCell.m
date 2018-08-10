//
//  MemberDetailCell.m
//  dianshang
//
//  Created by yunjobs on 2017/12/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "MemberDetailCell.h"
#import "HomeJobEntity.h"

@interface MemberDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *salaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *placeLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;

@end

@implementation MemberDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setEntity:(HomeJobEntity *)entity
{
    _entity = entity;
    
    self.nameLbl.text = entity.pname;
    if ([entity.pay hasPrefix:@"0"]) {
        self.salaryLbl.text = @"面议";
    }else{
        self.salaryLbl.text = [entity.pay stringByAppendingString:@"k"];
    }
    self.placeLbl.text = entity.city;
    self.workLbl.text = [[EZPublicList getExperienceList] objectAtIndex:[entity.exprience integerValue]];
    self.eduLbl.text = [[EZPublicList getEducationList] objectAtIndex:[entity.edu integerValue]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
