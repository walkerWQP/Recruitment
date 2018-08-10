//
//  YQGuideCell.m
//  caipiao
//
//  Created by yunjobs on 16/8/5.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQGuideCell.h"

@interface YQGuideCell ()

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation YQGuideCell

- (UIButton *)startBtn
{
    if (_startBtn == nil) {
        _startBtn = [[UIButton alloc] init];
        _startBtn.frame = CGRectMake(0, 0, self.yq_width, self.yq_height);
        _startBtn.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.9);
        _startBtn.hidden = YES;
        //_startBtn.backgroundColor = THEMECOLOR;
        _startBtn.layer.cornerRadius = 5;
        _startBtn.layer.masksToBounds = YES;
        //[_startBtn setTitle:@"开启快递工作新方式!" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        
        [_startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_startBtn];
    }
    return _startBtn;
}

- (UIImageView *)imageV
{
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
    }
    return _imageV;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageV.image = _image;
    //self.imageV.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    //self.imageV.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    self.imageV.frame = self.bounds;
}


- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count pressStartBtn:(void (^)())block
{
    if (indexPath.row == count-1) {
        self.startBtn.hidden = NO;
    }else{
        self.startBtn.hidden = YES;
    }
    if (block) {
        self.pressStartBtn = block;
    }
}

- (void)startBtnClick:(UIButton *)sender
{
    if (self.pressStartBtn) {
        self.pressStartBtn();
    }
}

@end


