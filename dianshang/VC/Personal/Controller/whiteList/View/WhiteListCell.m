//
//  WhiteListCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "WhiteListCell.h"
#import "WhiteListEntity.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface WhiteListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation WhiteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addBtn.layer.cornerRadius = self.addBtn.yq_height *0.5;
    self.addBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.addBtn.layer.borderWidth = 1.0f;
    [self.addBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headImg.layer.cornerRadius = self.headImg.yq_height *0.5;
    self.headImg.layer.masksToBounds = YES;
}



- (void)setEntity:(WhiteListEntity *)entity
{
    _entity = entity;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    self.nameLbl.text = entity.name;
    self.phoneLbl.text = entity.phone;
}

- (void)setAddTitle:(NSString *)addTitle
{
    _addTitle = addTitle;
    
    [self.addBtn setTitle:addTitle forState:UIControlStateNormal];
}

- (void)setIsAddBtn:(BOOL)isAddBtn
{
    _isAddBtn = isAddBtn;
    
    self.addBtn.hidden = !isAddBtn;
}

- (void)addBtnClick:(UIButton *)sender
{
    if (self.addBtnBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.addBtnBlock(path, self.entity);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
