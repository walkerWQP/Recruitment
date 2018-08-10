//
//  BusinessModel.h
//  dianshang
//
//  Created by yunjobs on 2018/4/16.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessModel : NSObject

@property (nonatomic, copy) NSDictionary *imgurl;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *post_source;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *descriptionStr;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *titleStr;

+ (instancetype)BusinessModelWithDict:(NSDictionary *)dict;

@end
