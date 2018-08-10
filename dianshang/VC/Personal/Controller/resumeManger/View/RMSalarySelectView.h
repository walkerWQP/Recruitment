//
//  RMSalarySelectView.h
//  dianshang
//  选择薪资视图
//  Created by yunjobs on 2017/11/10.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectSalaryBlock)(NSString *minStr,NSString *maxStr);

@interface RMSalarySelectView : UIView

- (void)setMinStr:(NSString *)minStr MaxStr:(NSString *)maxStr;

@property (nonatomic, strong) selectSalaryBlock selectSalaryBlock;

- (void)showAnimate;


@end
