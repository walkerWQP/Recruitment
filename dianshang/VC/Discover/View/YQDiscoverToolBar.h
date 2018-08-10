//
//  YQDiscoverToolBar.h
//  dianshang
//
//  Created by yunjobs on 2017/10/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQDiscover;

@protocol YQDiscoverToolBarDelegate <NSObject>

- (void)toolBarButton:(UIButton *)sender;

@end



@interface YQDiscoverToolBar : UIView

@property(nonatomic,strong) YQDiscover *status;
@property(nonatomic,strong) id<YQDiscoverToolBarDelegate> delegate;

+(instancetype)toolbar;

@end


