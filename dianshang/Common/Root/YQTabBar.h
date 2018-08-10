//
//  YQTabBar.h
//  dianshang
//
//  Created by yunjobs on 2017/11/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQTabBar;

@protocol YQTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(YQTabBar *)tabBar;
@end

@interface YQTabBar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<YQTabBarDelegate> YQDelegate ;

@end
