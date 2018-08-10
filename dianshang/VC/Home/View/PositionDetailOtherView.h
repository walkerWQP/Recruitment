//
//  PositionDetailOtherView.h
//  dianshang
//
//  Created by yunjobs on 2017/11/22.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionDetailOtherView : UIView

+ (instancetype)otherView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *content;

@end

@interface PositionDetailOtherTwoView : UIView

+ (instancetype)otherTwoView;

// 主页按钮回调
@property (nonatomic, strong) void(^homePage)(UIButton *sender);

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, strong) NSString *position;

@end
