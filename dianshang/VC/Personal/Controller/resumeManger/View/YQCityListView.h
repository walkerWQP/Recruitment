//
//  YQCityListView.h
//  kuainiao
//
//  Created by yunjobs on 16/12/21.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)(NSString *provStr,NSString *cityStr,NSString *areaStr);

@interface YQCityListView : UIView

- (instancetype)initWithFrame:(CGRect)frame column:(NSInteger)column;

@property(nonatomic, strong) NSString *defultCityStr;

@property(nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) buttonBlock buttonPress;
- (void)buttonPress:(buttonBlock)block;

- (void)showAnimate;


@end
