//
//  NSString+YQWidthHeight.h
//  dianshang
//
//  Created by yunjobs on 2017/9/14.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YQWidthHeight)

- (CGFloat)yq_stringHeightWithFixedWidth:(CGFloat)width font:(CGFloat)font;
- (CGFloat)yq_stringWidthWithFixedHeight:(CGFloat)height font:(CGFloat)font;

@end
