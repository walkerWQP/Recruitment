//
//  ShareIconView.h
//  dianshang
//
//  Created by yunjobs on 2017/9/18.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareIconItem;

@interface ShareIconView : UIView

@property (nonatomic, assign) NSInteger column;

@property (nonatomic, strong) NSMutableArray<ShareIconItem *> *items;

- (void)showAnimate;

@property (nonatomic, strong) void(^buttonPress)(NSInteger index);

@end


