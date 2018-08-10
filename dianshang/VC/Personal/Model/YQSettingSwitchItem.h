//
//  YQSettingSwitchItem.h
//  caipiao
//
//  Created by yunjobs on 16/8/6.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQCellItem.h"

@interface YQSettingSwitchItem : YQCellItem

//记录是否打开状态的key,如果不设置就不记录
@property (nonatomic, strong) NSString *isOnKey;
@property (nonatomic, assign) BOOL isOn;

@end
