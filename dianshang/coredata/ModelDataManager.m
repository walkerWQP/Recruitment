//
//  ModelManager.m
//  Meeting
//
//  Created by abc on 14-6-26.
//  Copyright (c) 2014年 appbees.net. All rights reserved.
//

#import "ModelDataManager.h"

#import <CoreData/CoreData.h>

static ModelDataManager *sharedManager;

@interface ModelDataManager()
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation ModelDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

/*!
 *  @author 15-09-05 10:09:10
 *
 *  @brief  单例
 *
 *  @return 模型对象
 */
+ (ModelDataManager *)sharedManager
{
    if(!sharedManager)
    {
        sharedManager = [[ModelDataManager alloc] init];
    }
    return sharedManager;
}
- (id) init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

#pragma mark -
#pragma mark Core Data Utilites
/*!
 *  @author 15-09-05 10:09:10
 *
 *  @brief  保存方法
 */
- (void)saveContextUpdates
{
    if(self.managedObjectContext)
    {
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"managedObjectContext save error:%@", error.localizedDescription);
        }
    }
}

#pragma mark - 搭建CoreData上下文环境

/*!
 *  @author 15-09-05 10:09:27
 *
 *  @brief  获取沙盒位置
 *
 *  @return 沙盒位置
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/*!
 *  @author 15-09-05 10:09:04
 *
 *  @brief  初始化managedObjectContext 对象
 *
 *  @return 返回managedObjectContext对象
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

/*!
 *  @author 15-09-05 10:09:42
 *
 *  @brief  初始化 managedObjectModel 对象
 *
 *  @return 返回 managedObjectModel 对象
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    // 从应用程序包中加载模型文件
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

/*!
 *  @author 15-09-05 10:09:08
 *
 *  @brief  初始化 persistentStoreCoordinator 对象
 *
 *  @return 返回 persistentStoreCoordinator 对象
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:DBNAME]];
    //NSLog(@"path:%@",storeUrl);
    NSError *error = nil;
    // 根据模型对象，初始化NSPersistentStoreCoordinator
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:optionsDictionary error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
@end
