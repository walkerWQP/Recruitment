//
//  JobIntentionCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/10.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "JobIntentionCell.h"
#import "RMExpectindustryEntity.h"

@interface JobIntentionCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;





@end

@implementation JobIntentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.titleLbl.textColor = RGB(51, 51, 51);
    self.subTitleLbl.textColor = RGB(102, 102, 102);
    
}

- (void)setEntity:(RMJobIntentionEntity *)entity
{
    NSString *title = [NSString stringWithFormat:@"[%@] %@",entity.city, entity.name];
    self.titleLbl.text = title;
    NSString *salary = @"";
    if ([entity.low_salary isEqualToString:@"0"]) {
        salary = @"面议";
    }else{
        salary = [NSString stringWithFormat:@"%@-%@k",entity.low_salary,entity.top_salary];
    }
    NSString *subtitle = [NSString stringWithFormat:@"%@ %@",salary, entity.tradename];
    self.subTitleLbl.text = subtitle;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
