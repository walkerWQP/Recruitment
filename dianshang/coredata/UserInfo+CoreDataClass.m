//
//  UserInfo+CoreDataClass.m
//  dianshang
//
//  Created by yunjobs on 2017/10/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#define kUserInfo @"UserInfo"


#import "UserInfo+CoreDataClass.h"

@implementation UserInfo

/**
 *  插入数据
 *
 *  @param userDict 需要插入的数据
 */
+ (void)insertDataWithData:(NSDictionary *)userDict
{
    NSString *userhxid = [userDict objectForKey:kHXUserID];
    
    // 如果存在就更新 不存在就插入
    if ([self selectDataWithUserId:userhxid]) {
        [self updateDataWithData:userDict];
    }else{
        NSString *userid = [userDict objectForKey:kProfileUserID];
        NSString *username = [userDict objectForKey:kProfileUserName];
        NSString *userheadpath = [userDict objectForKey:kProfileUserHeadPath];
        
        NSManagedObjectContext *managedObjectContext = [[ModelDataManager sharedManager] managedObjectContext];
        
        //把数据添加到数据库中
        UserInfo *userinfo = [NSEntityDescription insertNewObjectForEntityForName:kUserInfo inManagedObjectContext:managedObjectContext];
        userinfo.hxuserId = userhxid;
        userinfo.userId = userid;
        userinfo.userName = username;
        userinfo.userHeadPath = userheadpath;
        //NSLog(@"存入数据库id------>%@",student);
        [[ModelDataManager sharedManager] saveContextUpdates];
    }
    
}
/**
 *  更新所有的字段
 *
 *  @param userDict 需要的信息
 */
+ (void)updateDataWithData:(NSDictionary *)userDict
{
    NSManagedObjectContext *context = [[ModelDataManager sharedManager] managedObjectContext];
    
    NSString *userid = [userDict objectForKey:kProfileUserID];
    NSString *username = [userDict objectForKey:kProfileUserName];
    NSString *hxuserid = [userDict objectForKey:kHXUserID];
    NSString *userheadpath = [userDict objectForKey:kProfileUserHeadPath];
    
    //根据studentId 在 Student 表中查询出对应信息
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kUserInfo inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *str = [NSString stringWithFormat:@"%@='%@'",@"hxuserId",hxuserid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjectsArray = [context executeFetchRequest:fetchRequest error:&error];
    //把查询到的信息更新为现有的数据
    for (UserInfo *userinfo in fetchedObjectsArray) {
        userinfo.hxuserId = hxuserid;
        userinfo.userId = userid;
        userinfo.userName = username;
        userinfo.userHeadPath = userheadpath;
    }
    
    //NSLog(@"更新数据库id------>%@",userDict);
    [[ModelDataManager sharedManager] saveContextUpdates];
}

/**
 *  根据id查询信息
 *
 *  @param userid id
 *
 *  @return 查询结果
 */
+ (UserInfo *)selectDataWithUserId:(NSString *)userid
{
    NSManagedObjectContext *context = [[ModelDataManager sharedManager] managedObjectContext];
    //根据studentId 在 Student 表中查询出对应信息
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kUserInfo inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *str = [NSString stringWithFormat:@"%@='%@'",@"userId",userid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //返回 Student 类型的数据
    return [fetchedObjects firstObject];
}
/**
 *  根据hxid查询信息
 *
 *  @param userid id
 *
 *  @return 查询结果
 */
+ (UserInfo *)selectDataWithUserHXId:(NSString *)userid
{
    NSManagedObjectContext *context = [[ModelDataManager sharedManager] managedObjectContext];
    //根据studentId 在 Student 表中查询出对应信息
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kUserInfo inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *str = [NSString stringWithFormat:@"%@='%@'",@"hxuserId",userid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //返回 Student 类型的数据
    return [fetchedObjects firstObject];
}
/**
 *  查询所有的信息
 *
 *  @return 所有信息数组
 */
+(NSArray *)selectAllData
{
    NSManagedObjectContext *context = [[ModelDataManager sharedManager] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kUserInfo inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

/**
 *  删除指定id
 *
 *  @param userid id_
 */
+ (void)deleteId:(NSString *)userid
{
    NSManagedObjectContext *managedObjectContext = [[ModelDataManager sharedManager] managedObjectContext];
    //先根据id 查询出id 对应的对象 再将对象删除
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:kUserInfo inManagedObjectContext:managedObjectContext];
    //查询的条件
    NSString *str = [NSString stringWithFormat:@"%@='%@'",@"hxuserId",userid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *objs = [managedObjectContext executeFetchRequest:request error:&error];
    //删除一条对象
    [managedObjectContext deleteObject:[objs firstObject]];
    [[ModelDataManager sharedManager] saveContextUpdates];
}

/**
 *  删除所有数据
 *
 */
+ (void)deleteAllData
{
    NSManagedObjectContext *managedObjectContext = [[ModelDataManager sharedManager] managedObjectContext];
    //查询出所有的对象，再将对象逐个删除
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:kUserInfo inManagedObjectContext:managedObjectContext];
    
    NSError *error = nil;
    NSArray *objs = [managedObjectContext executeFetchRequest:request error:&error];
    
    //删除每一条数据
    for (NSManagedObject *obj in objs)
    {
        // 传入需要删除的实体对象
        [managedObjectContext deleteObject:obj];
        // 将结果同步到数据库
        //保存
        [[ModelDataManager sharedManager] saveContextUpdates];
    }
}

@end
