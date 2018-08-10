//
//  YQDiscoverComment.h
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQDiscoverComment : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *commentText;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, assign) NSInteger hot_count;
@property (nonatomic, assign) BOOL isPraise;

+ (instancetype)DiscoverCommentWithDict:(NSDictionary *)dict;

@end
