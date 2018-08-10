//
//  CompanyDetailCell.m
//  dianshang
//
//  Created by yunjobs on 2017/12/8.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyDetailCell.h"
#import "CompanyDetailEntity.h"

@interface CompanyDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CompanyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    
    [self.openBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setEntity:(CDescItem *)entity
{
    _entity = entity;
    
    self.titleLbl.text = entity.title;
    self.descLbl.text = entity.desc;
    
    self.openBtn.selected = entity.isOpen;
    self.openBtn.hidden = entity.height < 80;
}

- (void)openClick:(UIButton *)sender
{
    if (self.openBlock) {
        self.openBlock([self indexPathWithView:sender]);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
