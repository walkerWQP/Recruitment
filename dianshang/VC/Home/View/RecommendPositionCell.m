//
//  RecommendPositionCell.m
//  dianshang
//
//  Created by yunjobs on 2017/12/25.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RecommendPositionCell.h"
#import "ShareHREntity.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface RecommendPositionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation RecommendPositionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImgView.layer.cornerRadius = self.headImgView.yq_height * 0.5;
    self.headImgView.layer.masksToBounds = YES;
    
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventAllEvents];
}

- (void)setEntity:(ShareHREntity *)entity
{
    _entity = entity;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    self.selectBtn.selected = entity.isSelect;
    if ([entity.restatus isEqualToString:@"1"]||[entity.restatus isEqualToString:@"2"]) {
        self.typeLabel.text = @"在职";
    }else if ([entity.restatus isEqualToString:@"3"]){
        self.typeLabel.text = @"离职";
    }
    self.nameLbl.text = entity.name;
    self.positionLbl.text = entity.posi_name;
    self.cityLbl.text = entity.city;
    
//    self.workLbl.text = [entity. stringByAppendingString:@"年"];
//    self.eduLbl.text = entity.edu;
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
