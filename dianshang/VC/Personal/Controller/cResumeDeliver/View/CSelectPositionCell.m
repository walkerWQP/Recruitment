//
//  CSelectPositionCell.m
//  dianshang
//
//  Created by yunjobs on 2017/12/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CSelectPositionCell.h"
#import "CPositionMangerEntity.h"

@interface CSelectPositionCell()

@property (weak, nonatomic) IBOutlet UILabel *pnameLbl;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;

@property (weak, nonatomic) IBOutlet UIImageView *cityicon;
@property (weak, nonatomic) IBOutlet UIImageView *workicon;
@property (weak, nonatomic) IBOutlet UIImageView *eduicon;
@end

@implementation CSelectPositionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


- (void)setEntity:(CPositionMangerEntity *)entity
{
    _entity = entity;
    
    self.pnameLbl.text = [NSString stringWithFormat:@"%@",entity.pname];
    self.cityLbl.text = entity.city;
    self.workLbl.text = [[EZPublicList getExperienceList] objectAtIndex:[entity.exprience integerValue]];
    self.eduLbl.text = [[EZPublicList getEducationList] objectAtIndex:[entity.edu integerValue]];
    
    self.selectBtn.selected = entity.isSelect;
    
    if (self.indexx == 0) {
        self.cityLbl.hidden = YES;
        self.workLbl.hidden = YES;
        self.eduLbl.hidden = YES;
        self.cityicon.hidden = YES;
        self.workicon.hidden = YES;
        self.eduicon.hidden = YES;
    }else{
        self.cityLbl.hidden = NO;
        self.workLbl.hidden = NO;
        self.eduLbl.hidden = NO;
        self.cityicon.hidden = NO;
        self.workicon.hidden = NO;
        self.eduicon.hidden = NO;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
