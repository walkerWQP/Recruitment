//
//  YQHotCityCell.m
//  dianshang
//
//  Created by yunjobs on 2017/9/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQHotCityCell.h"
#import "JurisdictionMethod.h"

@interface YQHotCityCell ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation YQHotCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


int indexx = 0;
- (void)setHotCell:(NSArray *)arr
{
    self.array = arr;
    int y = -1;
    int x = 0;
    for (int i = 0; i<arr.count; i++) {
        if (i%3 == 0) {
            y++;
            x=0;
        }
        NSDictionary *dict = [arr objectAtIndex:indexx++];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x * (APP_WIDTH-30)/3 + 15, 50*y+10, (APP_WIDTH-30)/3-10, 40)];
        [button setTitle:dict[@"city"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.cornerRadius = 5;
        button.tag = [dict[@"citycode"] integerValue];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        [self addSubview:button];
        x++;
    }
    indexx = 0;
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag != -1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hotCell:didSelectCellAtCityDict:)]) {
            NSString *code = [NSString stringWithFormat:@"%d",(int)sender.tag];
            [self.delegate hotCell:self didSelectCellAtCityDict:@{@"city":sender.currentTitle,@"citycode":code}];
        }
    }else{
        if (![JurisdictionMethod locationJurisdiction]) {
            [[JurisdictionMethod shareJurisdictionMethod] locationJurisdictionAlert];
        }else{
            [self.delegate hotCell:self didSelectCellAtCityDict:@{@"city":@"error",@"citycode":@"-1"}];
        }
    }
}

//- (void)hotCity:(void (^)(NSString *))block
//{
//    if (block) {
//        self.hotCity = block;
//    }
//}


@end
