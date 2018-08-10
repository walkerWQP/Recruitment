//
//  BusinessCollectionViewCell.m
//  dianshang
//
//  Created by yunjobs on 2018/4/16.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "BusinessCollectionViewCell.h"
#import "BusinessModel.h"
#import "UIImageView+WebCache.h"

@interface BusinessCollectionViewCell()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UIImageView *imgView;


@end

@implementation BusinessCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.contentView.frame.size.width * 0.6, 30)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.titleLabel.frame.size.height + 10, self.contentView.frame.size.width * 0.6, 30)];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 55, 20, 50, 50)];
    self.imgView.layer.cornerRadius = self.imgView.yq_height*0.5;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.userInteractionEnabled = YES;
    
    
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.imgView];
    
    
}


- (void)setModel:(BusinessModel *)model {
    
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.descriptionStr;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]];
    NSLog(@"aaaaa %@",url);
    
    [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}


@end
