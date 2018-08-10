//
//  RecommendPersonCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RecommendPersonCell.h"

#import "RecommendPersonEntity.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface RecommendPersonCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cHeadImgV;
@property (weak, nonatomic) IBOutlet UILabel *cNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *cPositionLbl;
@property (weak, nonatomic) IBOutlet UILabel *cAddressLbl;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation RecommendPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventAllEvents];
}

- (void)setEntity:(RecommendPersonEntity *)entity
{
    _entity = entity;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.logo];
    [self.cHeadImgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    
    self.selectBtn.selected = entity.isSelect;
    
    self.cNameLbl.text = entity.cname;
    self.cPositionLbl.text = entity.pname;
    self.cAddressLbl.text = [NSString stringWithFormat:@"%@%@",entity.city,entity.address];
}

- (void)selectClick:(UIButton *)sender
{
    if (self.selectBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.selectBlock(path, _entity);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
