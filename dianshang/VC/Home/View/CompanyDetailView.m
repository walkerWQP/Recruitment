//
//  CompanyDetailView.m
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyDetailView.h"
#import "YQBannerView.h"
#import "CompanyDetailEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+YBAttributeTextTapAction.h"

@interface CompanyDetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *companyImgV;
@property (weak, nonatomic) IBOutlet YQBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *cHeadImgV;
@property (weak, nonatomic) IBOutlet UILabel *cNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *cTagLbl;
@property (weak, nonatomic) IBOutlet UILabel *cLinkLbl;


@end

@implementation CompanyDetailView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.cLinkLbl.textColor = THEMECOLOR;
    self.cLinkLbl.userInteractionEnabled = YES;
}

+ (instancetype)companyView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setEntity:(CompanyDetailEntity *)entity
{
    _entity = entity;
    
    NSString *str1 = [NSString stringWithFormat:@"%@%@",ImageURL,entity.logo];
    [self.cHeadImgV sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    
    self.cNameLbl.text = entity.cname;
    self.cTagLbl.text = [NSString stringWithFormat:@"%@  %@",entity.cvedit,entity.scale];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.img];
    [self.companyImgV sd_setImageWithURL:[NSURL URLWithString:str]];
    
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setObject:THEMECOLOR forKey:NSForegroundColorAttributeName];
    [mDic setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    NSString *linkStr = [NSString stringWithFormat:@"%@",entity.link];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:linkStr];
    [aStr addAttributes:mDic range:NSMakeRange(linkStr.length-entity.link.length, entity.link.length)];
    self.cLinkLbl.text = entity.link;
    YQWeakSelf;
    [self.cLinkLbl yb_addAttributeTapActionWithStrings:@[entity.link] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        [weakSelf handleTapAction:string];
    }];
    
    /*
    NSArray *resultArr = @[
                           @"http://www.yjacct.com/res/admin/uploads_admin/banner/20171016/6cfab862d63e232b2ad8386e047c10d3.jpg"];
    NSArray *urlArr = @[@"http://h5.welian.com/event/i/eyJhaWQiOjQyMjczfQ==",@"http://3g.tongxingzhe.cn/micWeb/html/login.html",@"http://zugeliang01.com/?icode=3JctF"];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < resultArr.count; i++) {
        YQBannerItem *item = [[YQBannerItem alloc] init];
        item.image = resultArr[i];
        item.url = urlArr[i];
        [array addObject:item];
    }
    self.bannerView.items = array;
    self.bannerView.pageControlShowStyle = YQPageControlShowStyleRight;
     */
}

- (void)handleTapAction:(NSString *)string
{
    if (self.linkClick) {
        self.linkClick(self.entity);
    }
}

@end
