//
//  ModelManager.h
//  Meeting
//  CoreData 功能管理类
//  Created by abc on 14-6-26.
//  Copyright (c) 2014年 appbees.net. All rights reserved.
//

#define DBNAME @"Model.sqlite"  /**< 数据库名称 */

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface ModelDataManager : NSObject

/*!
 *  @author 15-09-05 10:09:10
 *
 *  @brief  单例
 *
 *  @return 模型对象
 */
+ (ModelDataManager *)sharedManager;

/*!
 *  @author 15-09-05 10:09:10
 *
 *  @brief  保存方法
 */
- (void)saveContextUpdates;

/*!
 *  @author 15-09-05 10:09:04
 *
 *  @brief  初始化managedObjectContext 对象
 *
 *  @return 返回managedObjectContext对象
 */
- (NSManagedObjectContext *)managedObjectContext;

@end
