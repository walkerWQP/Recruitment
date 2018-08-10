//
//  YQDowndropHeadView.m
//  CustomTable
//
//  Created by yunjobs on 2017/10/24.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#import "YQDowndropHeadView.h"
#import "YQDowndropItem.h"

@interface YQDowndropHeadView ()

@end

@implementation YQDowndropHeadView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray<YQHeadViewItem *> *)titleArr
{
    if (self = [super initWithFrame:frame])
    {
        int count = (int)titleArr.count;
        
        NSLog(@"%d",count);
        
        int width = self.frame.size.width;
        int height = self.frame.size.height;
        
        int btnW = width / count;
        int btnH = height;
        
        
        for (int i = 0; i < count; i++)
        {
            //NSLog(@"%d",(int)titleArr.count);
            YQHeadViewItem *item = titleArr[i];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, btnH)];
            [btn setTitle:item.text forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            item.titleView = btn;
            
            if (i != count-1) {
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x+btnW, 15/2, 0.5, btnH-15)];
                lineview.backgroundColor = [UIColor grayColor];
                [self addSubview:lineview];
            }
        }
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5, width, 0.5)];
        lineview.backgroundColor = [UIColor grayColor];
        [self addSubview:lineview];
    }
    return self;
}

- (void)btnClick:(UIButton *)sender
{
    if (self.headViewBlock) {
        NSLog(@"aaaaaaaaaaaaaaaa %ld",(long)sender.tag);
        self.headViewBlock(sender.tag);
    }
}

@end
