//
//  YQDiscoverCommentView.m
//  dianshang
//
//  Created by yunjobs on 2017/10/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQDiscoverCommentView.h"
#import "YQDiscoverComment.h"
#import "NSString+Extension.h"

static NSInteger DisplayAllBtnHeitht = 25;
static NSInteger MarginTop = 8;

@interface YQDiscoverCommentView ()

@property (weak, nonatomic) IBOutlet UIView *bodyView;

@property (weak, nonatomic) IBOutlet UIButton *displayAllBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allBtnHeight;

@end

@implementation YQDiscoverCommentView

+ (instancetype)commentView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)setList:(NSArray *)list
{
    _list = list;
    //CGFloat width = APP_WIDTH - 40;
    
    NSInteger commentCount = list.count > 3 ? 3 : list.count;
    
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.bodyView.subviews.count < commentCount) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15];
        [self.bodyView addSubview:label];
    }
    
    // 遍历所有的控件，设置text
    NSInteger flag = 0;
    for (int i = 0; i<self.bodyView.subviews.count; i++) {
        UILabel *label = self.bodyView.subviews[i];
        
        if (i < commentCount) { // 显示
            YQDiscoverComment *comment = list[i];
            NSString *str = [comment.name stringByAppendingString:@":"];
            str = [str stringByAppendingString:comment.commentText];
            label.text = str;
            label.hidden = NO;
        } else { // 隐藏
            label.hidden = YES;
        }
        flag ++;
        if (flag == 3) {
            break;
        }
    }
    
    if (list.count>3) {
        //self.allBtnHeight.constant = DisplayAllBtnHeitht;
        self.displayAllBtn.hidden = NO;
        [self.displayAllBtn setTitle:[NSString stringWithFormat:@"显示全部%d条评论",(int)list.count] forState:UIControlStateNormal];
    }else{
        //self.allBtnHeight.constant = 0;
        self.displayAllBtn.hidden = YES;
    }
    
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat photosW = APP_WIDTH-40;
    
    //设置图片的尺寸和位置
    int photosCount = (int)self.bodyView.subviews.count;
    NSInteger commentCount = self.list.count > 3 ? 3 : self.list.count;
    
    CGFloat praviousBottom = 0;
    
    // 遍历所用控件
    for (int i = 0; i < photosCount; i++) {
        
        UILabel *label = self.bodyView.subviews[i];
        label.yq_x = 0;
        label.yq_y = praviousBottom+2;
        label.yq_width = photosW;
        
        if (i < commentCount) {
            YQDiscoverComment *comment = [self.list objectAtIndex:i];
            NSString *str = [comment.name stringByAppendingString:@":"];
            str = [str stringByAppendingString:comment.commentText];
            
            CGFloat subH = [comment.commentText sizeWithFont:[UIFont systemFontOfSize:15] maxW:photosW].height;
            if (subH < 25) {
                subH = 25;
            }
            label.yq_height = subH;
        }else{
            label.yq_height = 0;
        }
        
        praviousBottom = label.yq_bottom;
    }
    
}



+ (CGFloat)commentViewHeightWithFixedWidth:(CGFloat)width commentList:(NSArray *)list
{
    CGFloat h = 0;
    NSInteger flag = 0;
    for (YQDiscoverComment *comment in list) {
        NSString *str = [comment.name stringByAppendingString:@":"];
        str = [str stringByAppendingString:comment.commentText];
        
        CGFloat subH = [comment.commentText sizeWithFont:[UIFont systemFontOfSize:15] maxW:width].height;
        
        if (subH < 25) {
            subH = 25;
        }
        h += subH;
        h += 2;// label间距
        flag ++;
        if (flag == 3) {
            break;
        }
    }
    
    if (list.count>3) {
        h += DisplayAllBtnHeitht;
    }
    
    return h+MarginTop;
}

@end
