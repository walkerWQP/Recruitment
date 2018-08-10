//
//  UserInfo+CoreDataClass.h
//  dianshang
//
//  Created by yunjobs on 2017/10/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "ModelDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSManagedObject

/**
 *  插入数据
 *
 *  @param studentDic 需要插入的数据
 */
+(void)insertDataWithData:(NSDictionary *)studentDic;

/**
 *  根据id查询信息
 *
 *  @param userid id
 *
 *  @return 查询结果
 */
+ (UserInfo *)selectDataWithUserId:(NSString *)userid;
/**
 *  根据hxid查询信息
 *
 *  @param userid id
 *
 *  @return 查询结果
 */
+ (UserInfo *)selectDataWithUserHXId:(NSString *)hxid;
@end

NS_ASSUME_NONNULL_END

#import "UserInfo+CoreDataProperties.h"
