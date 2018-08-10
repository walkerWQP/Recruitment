//
//  BusinessCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "BusinessCell.h"
#import "BusinessEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+MyDate.h"

@interface BusinessCell()

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initView];
}

- (void)initView
{
    _logo.layer.cornerRadius = _logo.yq_height*0.5;
    _logo.layer.masksToBounds = YES;
}

- (void)setEntity:(BusinessEntity *)entity
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,entity.thumb]];
    [_logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    
    _titile.text = entity.title;
    NSString *timeStr = [NSString stringWithFormat:@"%@",entity.create_time];
    _time.text = [NSString timeStampToString:timeStr formatter:MMddHHmmss];
    _desc.text = entity.desc;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
