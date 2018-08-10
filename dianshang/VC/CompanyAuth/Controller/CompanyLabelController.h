//
//  CompanyLabelController.h
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQViewController.h"

@interface CompanyLabelController : YQViewController

@property (nonatomic, strong) void(^expectIndustryBlock)(NSArray *array);

// 是否可以添加自定义的  默认NO
@property (nonatomic, assign) BOOL isAdd;

// 标题
@property (nonatomic, assign) NSInteger selectCount;
// 标题
@property (nonatomic, strong) NSString *titleStr;
// 所有标签
@property (nonatomic, strong) NSMutableArray *allArray;
// 已选择标签
@property (nonatomic, strong) NSArray *expectArray;

@end
