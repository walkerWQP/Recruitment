//
//  NSMutableAttributedString+YQStringConvertImage.m
//  kuainiao
//
//  Created by yunjobs on 16/12/16.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "NSMutableAttributedString+YQStringConvertImage.h"
#import "NSString+RegularExpression.h"

@implementation NSMutableAttributedString (YQStringConvertImage)

static NSDictionary *_plistDict;

+ (NSString *)replaceString:(NSString *)content
{
    NSMutableString *String = [[NSMutableString alloc] initWithString:content];
    NSRange range = [content rangeOfString:@"{ez_auth}"];
    if (range.location != NSNotFound) {
        [String replaceCharactersInRange:range withString:@"[认证]"];
    }
    range = [String rangeOfString:@"{ez_unauth}"];
    if (range.location != NSNotFound) {
        [String replaceCharactersInRange:range withString:@"[未认证]"];
    }
//    range = [String rangeOfString:@"{username}"];
//    if (range.location != NSNotFound) {
//        [String replaceCharactersInRange:range withString:@"[姓名]"];
//    }
//    range = [String rangeOfString:@"{storename}"];
//    if (range.location != NSNotFound) {
//        [String replaceCharactersInRange:range withString:@"[店名]"];
//    }
//    range = [String rangeOfString:@"{tell}"];
//    if (range.location != NSNotFound) {
//        [String replaceCharactersInRange:range withString:@"[手机号]"];
//    }
//    range = [String rangeOfString:@"{company}"];
//    if (range.location != NSNotFound) {
//        [String replaceCharactersInRange:range withString:@"[快递公司]"];
//    }
    return String;
}

+ (NSMutableAttributedString *)handleString:(NSString *)content
{
    if (content == nil) {
        return [[NSMutableAttributedString alloc] init];
    }
    if (_plistDict == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageStringManage" ofType:@"plist"];
        _plistDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    // 1. 查找符合条件的文本 , 正则
    // \[\w+\]    由于[]在正则中是特殊语法, 因此使用 \[ 和 \] 来表示普通的[或]文本
    NSString *pattern = @"\\[\\w+\\]";
    // [图片名] 在 整句话当中的Range
    NSArray <NSValue *> *rangeArray = [content matchesRangeWithPattern:pattern];
    
    // content的富文本 (原始的)
    NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] initWithString:content];
    
    // 对每一个文字进行替换
    
    // lengthChanged 来记录 富文本替换表情后长度的变化
    NSUInteger totalLengthChanged = 0;
    for (NSValue *value in rangeArray) {
        // 1. 获取图片
        NSRange range = value.rangeValue;
        NSString *imagename = [content substringWithRange:NSMakeRange(range.location, range.length)];
        NSString *temp = [_plistDict objectForKey:imagename];
        if (temp.length) {
            imagename = temp;
        }else{
            continue;
        }
        
        UIImage *image = [UIImage imageNamed:imagename];
        if (image == nil) {
            continue;
        }
        // 2. 创建对应图片的富文本, 长度为1
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        CGFloat h = 20;
        CGFloat w = image.size.width*(h/image.size.height);
        attachment.bounds = CGRectMake(0, -3, w, h);
        NSAttributedString *imageAttrString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        /*================= AttrContent - NSTextAttributeString =================*/
        NSUInteger originalLength = attrContent.length;    // 改变前长度
        // 计算前的Range值
        NSRange newRange = NSMakeRange(range.location - totalLengthChanged, range.length);
        [attrContent replaceCharactersInRange:newRange withAttributedString:imageAttrString];
        NSUInteger finalLength = attrContent.length;    // 改变后的长度
        NSUInteger lengthChanged = originalLength - finalLength;    // 这一次图片替换长度的改变
        totalLengthChanged += lengthChanged;    // 累加每一次的改变
    }
    
    return attrContent;

}

@end
