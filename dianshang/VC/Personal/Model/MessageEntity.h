//
//  MessageEntity.h
//  kuainiao
//
//  Created by yunjobs on 16/4/2.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageEntity : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *see;
@property (nonatomic, copy) NSString *createtime;

+ (instancetype)messageEntityWithDict:(NSDictionary *)dict;

@end
