//
//  PositionDetailOtherView.m
//  dianshang
//
//  Created by yunjobs on 2017/11/22.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "PositionDetailOtherView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PositionDetailOtherView()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;


@end

@implementation PositionDetailOtherView

+ (instancetype)otherView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    PositionDetailOtherView *view = nil;
    for (UIView *v in array) {
        if (v.tag == 1) {
            view = (PositionDetailOtherView *)v;
            break;
        }
    }
    return view;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLbl.text = title;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    self.contentLbl.text = content;
}

- (void)setImage:(NSString *)image
{
    _image = image;
    
    self.imgView.image = [UIImage imageNamed:image];
}

@end

@interface PositionDetailOtherTwoView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *positionLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation PositionDetailOtherTwoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImgV.layer.cornerRadius = self.headImgV.yq_height * 0.5;
    self.headImgV.layer.masksToBounds = YES;
    
}

+ (instancetype)otherTwoView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PositionDetailOtherView" owner:nil options:nil];
    PositionDetailOtherTwoView *view = nil;
    for (UIView *v in array) {
        if (v.tag == 2) {
            view = (PositionDetailOtherTwoView *)v;
            break;
        }
    }
    return view;
}

- (void)setHeadImage:(NSString *)headImage
{
    _headImage = headImage;
    NSString *url = [NSString stringWithFormat:@"%@%@",ImageURL,headImage];
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    self.nameLbl.text = name;
}

- (void)setStatus:(NSString *)status
{
    _status = status;
    
    self.statusLbl.text = status;
}

- (void)setPosition:(NSString *)position
{
    _position = position;
    
    self.positionLbl.text = position;
}

- (IBAction)personHomeClick:(UIButton *)sender
{
    if (self.homePage) {
        self.homePage(sender);
    }
}

@end
