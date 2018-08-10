//
//  Foundation+Extension.m
//  runtime
//  runtime交换方法
//  Created by apple on 14-8-21.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <objc/runtime.h>

@implementation NSObject(Extension)
+ (void)swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    //class_getClassMethod获取类方法
    Method otherMehtod = class_getClassMethod(class, otherSelector);
    Method originMehtod = class_getClassMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}

+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    //class_getInstanceMethod获取对象方法
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}

//+ (void)load
//{
//    [self swizzleInstanceMethod:NSClassFromString(@"__NSObjectI") originSelector:@selector(setValuesForKeysWithDictionary:) otherSelector:@selector(hm_setValuesForKeysWithDictionary:)];
//}
//- (void)hm_setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues;
//{
//    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
//    NSNull *abcd = [[NSNull alloc] init];
//    for (NSString *key in keyedValues) {
//        id value = [keyedValues objectForKey:key];
//        if ([value isKindOfClass:[NSNumber class]]) {
//            value = [value stringValue];
//        }else if (value == nil) {
//            value = @"";
//        }else if ([value isEqual:abcd]){
//            value = @"";
//        }
//        [mDic setObject:value forKey:key];
//    }
//    return [self hm_setValuesForKeysWithDictionary:mDic];
//}

@end

@implementation NSArray(Extension)
+ (void)load
{
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(objectAtIndex:) otherSelector:@selector(hm_objectAtIndex:)];
}

- (id)hm_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self hm_objectAtIndex:index];
    } else {
        NSLog(@"数组溢出");
        return nil;
    }
}

@end

@implementation NSMutableArray(Extension)
+ (void)load
{
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(addObject:) otherSelector:@selector(hm_addObject:)];
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) otherSelector:@selector(hm_objectAtIndex:)];
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(insertObject:atIndex:) otherSelector:@selector(hm_insertObject:atIndex:)];
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(removeObjectAtIndex:) otherSelector:@selector(hm_removeObjectAtIndex:)];
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(replaceObjectAtIndex:withObject:) otherSelector:@selector(hm_replaceObjectAtIndex:withObject:)];
}

- (void)hm_addObject:(id)object
{
    if (object != nil) {
        [self hm_addObject:object];
    }else{
        NSLog(@"添加项为nil");
    }
}

- (id)hm_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self hm_objectAtIndex:index];
    } else {
        NSLog(@"数组溢出");
        return nil;
    }
}
- (void)hm_insertObject:(id)anObject atIndex:(NSUInteger)index{
    if (index > [self count]) {
        NSLog(@"%@",[NSString stringWithFormat:@"index[%ld] > count[%ld]",(long)index ,(long)[self count]]);
        return;
    }
    if (!anObject) {
        NSLog(@"object is nil");
        return;
    }
    [self hm_insertObject:anObject atIndex:index];
}
- (void)hm_removeObjectAtIndex:(NSUInteger)index{
    if (index >= [self count]) {
        NSLog(@"%@",[NSString stringWithFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]);
        return;
    }
    
    return [self hm_removeObjectAtIndex:index];
}
- (void)hm_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (index >= [self count]) {
        NSLog(@"%@",[NSString stringWithFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]);
        return;
    }
    if (!anObject) {
        NSLog(@"object is nil");
        return;
    }
    [self hm_replaceObjectAtIndex:index withObject:anObject];
}

@end

@implementation NSMutableDictionary(SafeKit)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(removeObjectForKey:) otherSelector:@selector(SKremoveObjectForKey:)];
        [self swizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(setObject:forKey:) otherSelector:@selector(SKsetObject:forKey:)];
    });
}

- (void)SKremoveObjectForKey:(id)aKey{
    if (!aKey) {
        NSLog(@"key is nil");
        return;
    }
    [self SKremoveObjectForKey:aKey];
}

- (void)SKsetObject:(id)anObject forKey:(id <NSCopying>)aKey{
    if (!anObject) {
        NSLog(@"object is nil");
        return;
    }
    if (!aKey) {
        NSLog(@"key is nil");
        return;
    }
    [self SKsetObject:anObject forKey:aKey];
}
@end
