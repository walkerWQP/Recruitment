//
//  MemberDetailView.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "MemberDetailView.h"
#import "MemberDetailEntity.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface MemberDetailView ()
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *authStatus;
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;

@property (weak, nonatomic) IBOutlet UIImageView *cLogoV;
@property (weak, nonatomic) IBOutlet UILabel *cNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@end

@implementation MemberDetailView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImgV.layer.cornerRadius = self.headImgV.yq_height*0.5;
    self.headImgV.layer.masksToBounds = YES;
    
    //[self.detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEntity:(MemberDetailEntity *)entity
{
    _entity = entity;
    
    self.titleLbl.text = [NSString stringWithFormat:@"%@@%@",entity.name,entity.cname];
    self.nameLbl.text = [NSString stringWithFormat:@"%@ · %@",entity.name,entity.post];
    self.companyName.text = entity.cname;
    if ([entity.approve isEqualToString:@"1"]) {
        self.authStatus.text = @"认证用户";
    }else{
        self.authStatus.text = @"非认证用户";
    }
    
    NSString *cvedit = [[EZPublicList getFinancingList] objectAtIndex:[entity.cvedit integerValue]];
    NSString *scale = [[EZPublicList getScopeList] objectAtIndex:[entity.scale integerValue]];
    NSString *trade = [[EZPublicList getTradeList] objectAtIndex:[entity.tradeid integerValue]];
    self.descLbl.text = [NSString stringWithFormat:@"%@ %@ %@",trade,cvedit,scale];
    
    self.cNameLbl.text = entity.cname;
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    NSString *str1 = [NSString stringWithFormat:@"%@%@",ImageURL,entity.logo];
    [self.cLogoV sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"cheadImg"]];
}

+ (instancetype)memberView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)gotoCompany:(id)sender
{
    if (self.goCompanyPress) {
        self.goCompanyPress(self.entity);
    }
}

@end
