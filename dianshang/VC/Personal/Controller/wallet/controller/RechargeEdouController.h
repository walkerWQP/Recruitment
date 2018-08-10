//
//  RechargeEdouController.h
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@interface RechargeEdouController : YQTableViewController

@end


@interface EdouItem : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) NSString *price;

@property (nonatomic, strong) NSString *priceStr;

@end

@class EdouItem;
@interface EdouView : UIButton

@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIColor *subTitleColor;

@property (nonatomic, strong) EdouItem *item;

@end
