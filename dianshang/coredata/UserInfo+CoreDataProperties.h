//
//  UserInfo+CoreDataProperties.h
//  dianshang
//
//  Created by yunjobs on 2017/10/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "UserInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *hxuserId;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userHeadPath;

@end

NS_ASSUME_NONNULL_END
