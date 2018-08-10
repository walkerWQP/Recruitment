//
//  UserInfo+CoreDataProperties.m
//  dianshang
//
//  Created by yunjobs on 2017/10/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "UserInfo+CoreDataProperties.h"

@implementation UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
}

@dynamic userId;
@dynamic userName;
@dynamic userHeadPath;
@dynamic hxuserId;
@end
