//
//  XLAlertView.h
//  dianshang
//
//  Created by yunjobs on 2017/12/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XLAlertResult)(NSInteger index);

@class XLAlertView;

@protocol XLAlertViewDelegate <NSObject>
@optional

- (void)alertView:(XLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface XLAlertView : UIView

@property (nonatomic, copy) XLAlertResult resultIndex;

@property (nonatomic, weak) id<XLAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)showXLAlertView;

@end


