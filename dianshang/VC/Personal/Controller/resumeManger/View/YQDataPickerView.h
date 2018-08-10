//
//  YQDataPickerView.h
//  dianshang
//
//  Created by yunjobs on 2017/9/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)(NSString *yearStr,NSString *monthStr);

@interface YQDataPickerView : UIView

@property (nonatomic, strong) buttonBlock buttonPress;

//是否需要月份
@property (nonatomic, assign) BOOL isMonth;

- (void)showAnimate;
@end
