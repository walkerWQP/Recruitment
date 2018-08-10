//
//  LPlaceHolderTextView.m
//  MobileLuoYang
//  自定义textView
//  Created by csip on 15-1-16.
//  Copyright (c) 2015年 com.hn3l.mobilely. All rights reserved.
//

#import "LPlaceHolderTextView.h"

@implementation LPlaceHolderTextView
@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize placeHolderImage;
@synthesize placeholderImg;
- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    [self setPlaceholder:@""];
    
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPlaceholder:@""];
        
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)textChanged:(NSNotification *)notification
{
    
    if([[self placeholder] length] == 0)
    {
        return;
    }
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
        placeHolderImage.hidden = NO;
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
        placeHolderImage.hidden = YES;
    }
}

- (void)setText:(NSString *)text {
    
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0)
    {
//        if (placeHolderImage == nil)
//        {
//            placeHolderImage = [[UIImageView alloc] initWithFrame:CGRectMake(8,10,19,15)];
//            placeHolderImage.image = [UIImage imageNamed:placeholderImg];
//            [self addSubview:placeHolderImage];
//        }
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            placeHolderLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:placeHolderLabel];
        }
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
        
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}

@end
