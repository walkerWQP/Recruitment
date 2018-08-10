//
//  ResumeManageCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/8.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ResumeManageCell.h"
#import "ResumeManageEntity.h"

#import "NSString+MyDate.h"
#import "RMAddEditResume.h"

@interface ResumeManageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *topLbl;
@property (weak, nonatomic) IBOutlet UILabel *middleLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomLbl;

@end

@implementation ResumeManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topLbl.textColor = RGB(102, 102, 102);
    self.middleLbl.textColor = RGB(51, 51, 51);
    self.bottomLbl.textColor = RGB(51, 51, 51);
}

- (void)setItem:(ResumeManageSubEntity *)item indexPath:(NSIndexPath *)indexPath totalCount:(NSInteger)totalCount
{
    // 设置背景图片
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    NSString *imageStr = indexPath.row == 0 ? @"rm_bg_top" : @"rm_bg_middle";
    UIImage *image = [UIImage imageNamed:imageStr];
    _bgView.image = [image resizableImageWithCapInsets:insets];
    
    if (totalCount == 1) {
        self.topLine.hidden = YES;
        self.bottomLine.hidden = YES;
    }else{
        if (indexPath.row == 0) {
            self.topLine.hidden = YES;
            self.bottomLine.hidden = NO;
        }else if (indexPath.row == totalCount-1){
            self.topLine.hidden = NO;
            self.bottomLine.hidden = YES;
        }else{
            self.topLine.hidden = NO;
            self.bottomLine.hidden = NO;
        }
    }
    //RMSectionTypeWorking
    if (indexPath.section == RMSectionTypeWorking) {
        // 时间
//        NSString *start = [NSString timeStampToString:item.entrytime formatter:YYYYMMdd];
//        NSString *end = [NSString timeStampToString:item.leavetime formatter:YYYYMMdd];
        NSString *str = [NSString stringWithFormat:@"%@-%@",item.entrytimeStr,item.leavetimeStr];
        self.topLbl.text = str;
        
        self.middleLbl.text = item.companyname;
        self.bottomLbl.text = item.position;
        
    }else if (indexPath.section == RMSectionTypeExperience){
        
        // 时间
//        NSString *start = [NSString timeStampToString:item.starttime formatter:YYYYMMdd];
//        NSString *end = [NSString timeStampToString:item.endtime formatter:YYYYMMdd];
        NSString *str = [NSString stringWithFormat:@"%@-%@",item.starttimeStr,item.endtimeStr];
        self.topLbl.text = str;
        
        self.middleLbl.text = item.pname;
        self.bottomLbl.text = item.describetion;
        
    }else if (indexPath.section == RMSectionTypeEducational){
        
        // 时间
//        NSString *start = [NSString timeStampToString:item.entrancetime formatter:YYYYMMdd];
//        NSString *end = [NSString timeStampToString:item.graduate formatter:YYYYMMdd];
        NSString *str = [NSString stringWithFormat:@"%@-%@",item.entrancetimeStr,item.graduateStr];
        self.topLbl.text = str;
        
        self.middleLbl.text = item.schoolname;
        
        self.bottomLbl.text = [NSString stringWithFormat:@"%@ | %@",item.edu,item.major];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
