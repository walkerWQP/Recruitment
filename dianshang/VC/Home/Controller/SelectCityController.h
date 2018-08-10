//
//  SelectCityViewController.h
//  dianshang
//
//  Created by yunjobs on 2017/9/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQTableViewController.h"

@interface SelectCityController : YQTableViewController

@property (nonatomic, strong) NSMutableArray *cityListArray;

@property (nonatomic, strong) NSDictionary *loc_cityDic;
//@property (nonatomic, strong) NSString *loc_cityCode;

@property (nonatomic, strong) void (^selectcity)(NSDictionary *dict);
- (void)selectcity:(void(^)(NSDictionary *dict))block;

@end
