//
//  BusinessEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/12/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessEntity : NSObject

@property (nonatomic, copy) NSDictionary *imgurl;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *post_source;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *desc;

+ (instancetype)entityWithDict:(NSDictionary *)dict;

@end
