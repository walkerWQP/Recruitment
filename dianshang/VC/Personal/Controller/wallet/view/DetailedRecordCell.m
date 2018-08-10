//
//  DetailedRecordCell.m
//  dianshang
//
//  Created by yunjobs on 2017/9/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DetailedRecordCell.h"
#import "DetailRecordEntity.h"
#import "NSString+MyDate.h"

@interface DetailedRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation DetailedRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setEntity:(DetailRecordEntity *)entity
{
    self.title.text = entity.title;
    
    if (self.tableIndex == 0) {
        self.price.text = entity.price;
    }else{
        self.price.text = entity.coin;
    }
    
    if ([entity.type  isEqualToString:@"3"]) {
        self.stateLbl.text = entity.astatus;
        self.stateLbl.hidden = NO;
    }else{
        self.stateLbl.text = @"";
        self.stateLbl.hidden = YES;
    }
    
//    if ([entity.astatus isEqualToString:@"1"]) {
//        self.stateLbl.text = @"审核中";
//    }else if ([entity.astatus isEqualToString:@"2"]) {
//        self.stateLbl.text = @"驳回";
//    }else if ([entity.astatus isEqualToString:@"3"]) {
//        self.stateLbl.text = @"已打款";
//    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",entity.createtime];
    self.timeLbl.text = [NSString timeStampToString:timeStr formatter:MMddHHmmss];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
