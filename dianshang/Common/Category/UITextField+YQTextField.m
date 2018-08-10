//
//  UITextField+YQTextField.m
//  kuainiao
//
//  Created by yunjobs on 16/12/20.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "UITextField+YQTextField.h"

@implementation UITextField (YQTextField)

- (void)yq_setTitle:(NSString *)title titleColor:(UIColor *)color
{
    CGRect frame = self.frame;
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = color;
    label.font = self.font;
    label.textAlignment = NSTextAlignmentRight;
    [label sizeToFit];
    [[self superview] addSubview:label];
    label.frame = CGRectMake(10, frame.origin.y+(frame.size.height-label.frame.size.height)*0.5, label.frame.size.width, label.frame.size.height);
    self.frame = CGRectMake(label.frame.size.width+10+10, frame.origin.y+(frame.size.height-32)*0.5, frame.size.width-label.frame.size.width-30, 32);
}

- (void)yq_setTitle:(NSString *)title titleColor:(UIColor *)color rightImage:(NSString *)image
{
    CGRect frame = self.frame;
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = color;
    label.font = self.font;
    label.textAlignment = NSTextAlignmentRight;
    [label sizeToFit];
    [[self superview] addSubview:label];
    label.frame = CGRectMake(10, frame.origin.y+(frame.size.height-label.frame.size.height)*0.5, label.frame.size.width, label.frame.size.height);
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-25-10, frame.origin.y+(frame.size.height-25)*0.5, 25, 25)];
    imageV.image = [UIImage imageNamed:image];
    //imageV.contentMode = UIViewContentModeScaleAspectFit;
    [[self superview] addSubview:imageV];
    
    self.frame = CGRectMake(label.frame.size.width+10+10, frame.origin.y+(frame.size.height-32)*0.5, frame.size.width-label.frame.size.width-30-imageV.frame.size.width, 32);
}

@end
