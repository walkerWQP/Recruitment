//
//  RMHeadView.m
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RMHeadView.h"
#import "ResumeManageEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RMHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;


@end

@implementation RMHeadView

+ (instancetype)headView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImg.image = [UIImage imageNamed:@""];
    self.headImg.layer.cornerRadius = self.headImg.yq_height*0.5;
    self.headImg.layer.masksToBounds = YES;
    
    self.titleLbl.textColor = RGB(51, 51, 51);
    self.subTitleLbl.textColor = RGB(51, 51, 51);
}


- (void)setEntity:(ResumeManageEntity *)entity
{
    NSString *avatar = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"headImg"]];
    NSString *str = [NSString stringWithFormat:@"%@ | %@",entity.name,entity.sex];
    self.titleLbl.text = str;
    
    self.subTitleLbl.text = @"编辑个人信息";
}

@end
