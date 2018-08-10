//
//  UITextField+YQTextField.h
//  kuainiao
//
//  Created by yunjobs on 16/12/20.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (YQTextField)

- (void)yq_setTitle:(NSString *)title titleColor:(UIColor *)color;
- (void)yq_setTitle:(NSString *)title titleColor:(UIColor *)color rightImage:(NSString *)image;
@end
