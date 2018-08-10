//
//  YQDiscoverToolBar.m
//  dianshang
//
//  Created by yunjobs on 2017/10/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQDiscoverToolBar.h"
#import "YQDiscover.h"
#import "YQToolBarButton.h"

@interface YQDiscoverToolBar()

/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的分割线 */
//@property (nonatomic, strong) NSMutableArray *dividers;
@property (nonatomic, weak) YQToolBarButton *repostBtn;
@property (nonatomic, weak) YQToolBarButton *commentBtn;
@property (nonatomic, weak) YQToolBarButton *attitudeBtn;

@end

@implementation YQDiscoverToolBar


-(NSMutableArray *)btns {
    
    if (!_btns) {
        self.btns = [NSMutableArray array];
        
    }
    return _btns;
    
}

//- (NSMutableArray *)dividers
//{
//    if (!_dividers) {
//        self.dividers = [NSMutableArray array];
//    }
//    return _dividers;
//}



+ (instancetype)toolbar
{
    return [[self alloc]init];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 添加按钮
        self.attitudeBtn = [self setupBtn:@"" icon:@"discover_unpraise" selected:@"discover_praise"];
        self.attitudeBtn.tag = 3;
        self.repostBtn = [self setupBtn:@"" icon:@"discover_share" selected:@"discover_share"];
        self.repostBtn.tag = 1;
        self.commentBtn = [self setupBtn:@"" icon:@"discover_comment" selected:@"discover_comment"];
        self.commentBtn.tag = 2;
        
    }
    
    
    return self;
    
}
/**
 * 初始化一个按钮
 * @param title : 按钮文字
 * @param icon : 按钮图标
 */

-(YQToolBarButton *)setupBtn:(NSString *)title icon:(NSString *)icon selected:(NSString *)selected{
    
    YQToolBarButton *btn = [[YQToolBarButton alloc]init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    //[btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.minimumScaleFactor = 10;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor = RandomColor;
    [self addSubview:btn];
    [self.btns addObject:btn];
    
    return btn;
}

- (void)addSubConstraint:(UIView *)view toView:(UIView *)cell
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [cell addSubview:view];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:3]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.yq_height]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.yq_width]];
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 设置按钮的frame
    int btnCount = (int)self.btns.count;
    CGFloat btnw = 60;
    CGFloat btnH = self.yq_height;
    CGFloat left = self.yq_width-YQStatusCellPadding-btnw*3;
    
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.yq_height = btnH;
        btn.yq_width = btnw;
        btn.yq_x = left + i*btnw;
        btn.yq_y = 0;
        
    }
//    // 设置分割线的frame
//    int dividerCount = (int)self.dividers.count;
//    for (int i = 0; i<dividerCount; i++) {
//        UIImageView *divider = self.dividers[i];
//        divider.yq_width = 1;
//        divider.yq_height = btnH;
//        divider.yq_x = left+(i+1) * btnw;
//        divider.yq_y = 0;
//        
//    }
    
    
}

-(void)setStatus:(YQDiscover *)status {
    
    _status = status;
    
    if (status.reposts_count > 0) {
        //转发
        [self setupBtnCount:status.reposts_count btn:self.repostBtn title:@""];
        //[self addSubConstraint:self.repostLbl toView:self.self.repostBtn];
    }else{
        [self.repostBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if (status.comments_count>0) {
        // 评论
        [self setupBtnCount:status.comments_count btn:self.commentBtn title:@""];
        //[self addSubConstraint:self.commentLbl toView:self.self.commentBtn];
    }else{
        [self.commentBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if (status.attitudes_count>0) {
        // 赞
        [self setupBtnCount:status.attitudes_count btn:self.attitudeBtn title:@""];
        //[self addSubConstraint:self.attitudeLbl toView:self.self.attitudeLbl];
    }else{
        [self.attitudeBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    self.attitudeBtn.selected = status.isPraise;
    
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarButton:)]) {
        [self.delegate toolBarButton:sender];
    }
}


- (void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title {
    
    if (count) {
        if (count < 1000) {
            title = [NSString stringWithFormat:@"%d",count];
        }else{
//            double wan = count / 10000;
//            title = [NSString stringWithFormat:@"%.1f万",wan];
//            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
            title = @"999+";
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];// = title;
//    [btn sizeToFit];
}


@end
