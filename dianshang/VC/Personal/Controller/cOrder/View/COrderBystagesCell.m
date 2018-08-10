//
//  COrderBystagesCell.m
//  dianshang
//
//  Created by yunjobs on 2018/1/3.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "COrderBystagesCell.h"
#import "RecommendOrderEntity.h"
#import "NSString+MyDate.h"
@interface COrderBystagesCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end

@implementation COrderBystagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.statusLbl.textColor = THEMECOLOR;
}

- (void)setEntity:(COrderBystagesEntity *)entity
{
    _entity = entity;

    self.titleLbl.text = [NSString stringWithFormat:@"第%@期",entity.time];
    NSString *str = [NSString timeStampToString:entity.paytime formatter:YYYYMMdd];
    self.dateLbl.text = [NSString stringWithFormat:@"付款日期:%@",str];
    self.priceLbl.text = [NSString stringWithFormat:@"%@",entity.money];
    
    if ([entity.orderstatus isEqualToString:@"1"]) {
        self.statusLbl.text = @"未付款";
        self.statusLbl.textColor = THEMECOLOR;
    }else if ([entity.orderstatus isEqualToString:@"2"]){
        self.statusLbl.text = @"已付清";
        self.statusLbl.textColor = RGB(102, 102, 102);
    }else if ([entity.orderstatus isEqualToString:@"3"]){
        self.statusLbl.text = @"已逾期";
        self.statusLbl.textColor = [UIColor redColor];
    }else{
        self.statusLbl.text = @"";
        self.titleLbl.text = @"";
        self.dateLbl.text = @"";
        self.priceLbl.text = @"";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
