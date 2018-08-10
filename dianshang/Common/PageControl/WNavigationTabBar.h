//
//  WNavigationTabBar.h
//  dianshang
//
//  Created by yunjobs on 2018/4/18.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);

@interface WNavigationTabBar : UIView

@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;

-(instancetype)initWithTitles:(NSArray *)titles;

-(void)scrollToIndex:(NSInteger)index;

@property(nonatomic,strong)UIColor *sliderBackgroundColor;

@property(nonatomic,strong)UIColor *buttonNormalTitleColor;

@property(nonatomic,strong)UIColor *buttonSelectedTileColor;

@end
