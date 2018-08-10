//
//  NSString+YQWidthHeight.m
//  dianshang
//
//  Created by yunjobs on 2017/9/14.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "NSString+YQWidthHeight.h"

@implementation NSString (YQWidthHeight)

- (CGFloat)yq_stringHeightWithFixedWidth:(CGFloat)width font:(CGFloat)font
{
    //NSLog(@"%@",self);
    CGSize stringSize = CGSizeZero;
    if (self.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringSize =[self
                     boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                     context:nil].size;
#else
        
        stringSize = [self sizeWithFont:[UIFont systemFontOfSize:font]
                      constrainedToSize:CGSizeMake(width, MAXFLOAT)
                          lineBreakMode:NSLineBreakByCharWrapping];
#endif
    }
    return stringSize.height;
}
- (CGFloat)yq_stringWidthWithFixedHeight:(CGFloat)height font:(CGFloat)font
{
    CGSize stringSize = CGSizeZero;
    if (self.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringSize =[self
                     boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                     context:nil].size;
#else
        
        stringSize = [self sizeWithFont:[UIFont systemFontOfSize:font]
                      constrainedToSize:CGSizeMake(MAXFLOAT, height)
                          lineBreakMode:NSLineBreakByCharWrapping];
#endif
    }
    return stringSize.width;
}

@end
