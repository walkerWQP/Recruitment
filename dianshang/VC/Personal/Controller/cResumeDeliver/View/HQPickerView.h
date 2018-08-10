//
//  HQPickerView.h
//  HQPickerView
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQPickerView;

@protocol HQPickerViewDelegate <NSObject>

- (void)pickerView:(HQPickerView *)view didSelectText:(NSString *)text;

@end

@interface HQPickerView : UIView

@property (nonatomic, strong) NSArray *customArr;
@property (nonatomic, weak) id <HQPickerViewDelegate> delegate;

- (void)showAnimate;

@end
