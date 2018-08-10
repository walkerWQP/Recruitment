//
//  LPlaceHolderTextView.h
//  MobileLuoYang
//  自定义textView
//  Created by csip on 15-1-16.
//  Copyright (c) 2015年 com.hn3l.mobilely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
@private
    UILabel *placeHolderLabel;
}

@property(nonatomic, retain) UILabel *placeHolderLabel;

@property(nonatomic, retain) UIImageView *placeHolderImage;

@property(nonatomic, retain) NSString *placeholderImg;

@property(nonatomic, retain) NSString *placeholder;

@property(nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
