//
//  HomePositionDetailVC.h
//  dianshang
//
//  Created by yunjobs on 2017/11/17.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@class HomeJobEntity;
@interface HomePositionDetailVC : YQViewController

@property (nonatomic, strong) HomeJobEntity *jobEntity;

@property (nonatomic, assign) BOOL isRecommend;

// 只有isHome = YES的时候 才显示推荐按钮
@property (nonatomic, assign) BOOL isHome;

@property (nonatomic, strong) NSString *puidStr;

@end
