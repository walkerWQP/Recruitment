//
//  CPositionMangerCell.m
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CPositionMangerCell.h"
#import "CPositionMangerEntity.h"

@interface CPositionMangerCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *lookLbl;
@property (weak, nonatomic) IBOutlet UILabel *chatLbl;

@property (weak, nonatomic) IBOutlet UIButton *hrRecommend;
@property (weak, nonatomic) IBOutlet UIButton *delivery;

@property (strong, nonatomic) UILabel *deliveryDot;
@property (strong, nonatomic) UILabel *hrDot;

@end

@implementation CPositionMangerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.deliveryDot = [self addReddot:self.delivery];
    self.hrDot = [self addReddot:self.hrRecommend];
    self.deliveryDot.hidden = YES;
    self.hrDot.hidden = YES;
    
    self.statusBtn.layer.cornerRadius = self.statusBtn.yq_height*0.5;
    self.statusBtn.backgroundColor = THEMECOLOR;
    
    //self.delivery.layer.cornerRadius = self.delivery.yq_height *0.5;
    self.delivery.layer.cornerRadius = 4;
    self.delivery.layer.borderColor = THEMECOLOR.CGColor;
    self.delivery.layer.borderWidth = 1.0f;
    [self.delivery setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.delivery addTarget:self action:@selector(deliveryClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.hrRecommend.layer.cornerRadius = self.hrRecommend.yq_height *0.5;
    self.hrRecommend.layer.cornerRadius = 4;
    self.hrRecommend.layer.borderColor = THEMECOLOR.CGColor;
    self.hrRecommend.layer.borderWidth = 1.0f;
    [self.hrRecommend setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.hrRecommend addTarget:self action:@selector(hrRecommendClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setEntity:(CPositionMangerEntity *)entity
{
    _entity = entity;
    
    self.titleLbl.text = [NSString stringWithFormat:@"%@",entity.pname];
    self.lookLbl.text = entity.look_num;
    self.chatLbl.text = entity.chat_num;
    
    if ([entity.issue isEqualToString:@"1"]) {
        [self.statusBtn setTitle:@"开放中" forState:UIControlStateNormal];
        self.statusBtn.backgroundColor = THEMECOLOR;
        self.hrRecommend.hidden = NO;
        self.delivery.hidden = NO;
    }else{
        [self.statusBtn setTitle:@"已关闭" forState:UIControlStateNormal];
        self.statusBtn.backgroundColor = [UIColor grayColor];
        self.hrRecommend.hidden = YES;
        self.delivery.hidden = YES;
    }
    if ([entity.pcount integerValue]>0) {
        self.deliveryDot.text = entity.pcount;
        [self.deliveryDot sizeToFit];
        if (self.deliveryDot.yq_width < 20) {
            self.deliveryDot.yq_width = 20;
        }
        self.deliveryDot.yq_height = 20;
        self.deliveryDot.hidden = NO;
    }else{
        self.deliveryDot.hidden = YES;
    }
    if ([entity.hrcount integerValue]>0) {
        self.hrDot.text = entity.hrcount;
        [self.hrDot sizeToFit];
        if (self.hrDot.yq_width < 20) {
            self.hrDot.yq_width = 20;
        }
        self.hrDot.yq_height = 20;
        self.hrDot.hidden = NO;
    }else{
        self.hrDot.hidden = YES;
    }
}

- (void)deliveryClick:(UIButton *)sender
{
    if (self.buttonBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.buttonBlock(path,1);
    }
}

- (void)hrRecommendClick:(UIButton *)sender
{
    if (self.buttonBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.buttonBlock(path,0);
    }
}

- (UILabel *)addReddot:(UIButton *)button
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    
    CGPoint point =CGPointMake(button.yq_width, 0);
    label.center = point;
    [button addSubview:label];
    
    return label;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
