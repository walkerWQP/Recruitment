//
//  ResumeManageEntity.m
//  dianshang
//
//  Created by yunjobs on 2017/11/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ResumeManageEntity.h"
#import "NSString+MyDate.h"

@implementation ResumeManageEntity

+ (instancetype)ResumeManageEntityWithDict:(NSDictionary *)dict
{
    ResumeManageEntity *obj = [[ResumeManageEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _uid = value;
    }else if ([key isEqualToString:@"description"]){
        _desc = value;
    }
}

- (NSString *)workStr
{
//    NSString *date = [NSString dateToString:[NSDate date] formatter:@"YYYY"];
//    NSString *str = [NSString stringWithFormat:@"%li",[date integerValue]-[self.year integerValue]];
    return _year;
}

- (NSString *)age
{
    NSString *cur = [NSString dateToString:[NSDate date] formatter:@"YYYY"];
    NSString *birth = @"1999";
    if (self.birthday.length >= 4) {
        birth = [self.birthday substringToIndex:4];
    }
    return [NSString stringWithFormat:@"%li",[cur integerValue] - [birth integerValue]];
}

- (void)setSex:(NSString *)sex
{
    NSString *sexStr = [sex isEqualToString:@"1"] ? @"男" : @"女";
    _sex = sexStr;
}
- (void)setEdu:(NSString *)edu
{
    NSArray *array = [EZPublicList getEducationList];
    _edu = [array objectAtIndex:[edu integerValue]];
}
- (void)setBirthday:(NSString *)birthday
{
    if ([birthday isEqualToString:@"0"]) {
        _birthday = @"";
    }else{
    //NSString *string = [NSString timeStampToString:birthday formatter:YYYYMMdd];
        _birthday = [NSString timeStampToString:birthday formatter:YYYYMMdd];
    }
}

- (void)setEdus:(NSMutableArray *)edus
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in edus) {
        ResumeManageSubEntity *en = [ResumeManageSubEntity ResumeManageSubEntityWithDict:dict];
        [array addObject:en];
    }
    _edus = array;
}

- (void)setWork:(NSMutableArray *)work
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in work) {
        ResumeManageSubEntity *en = [ResumeManageSubEntity ResumeManageSubEntityWithDict:dict];
        [array addObject:en];
    }
    _work = array;
}

- (void)setProject:(NSMutableArray *)project
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in project) {
        ResumeManageSubEntity *en = [ResumeManageSubEntity ResumeManageSubEntityWithDict:dict];
        [array addObject:en];
    }
    _project = array;
}

@end

@implementation ResumeManageSubEntity

+ (instancetype)ResumeManageSubEntityWithDict:(NSDictionary *)dict
{
    ResumeManageSubEntity *obj = [[ResumeManageSubEntity alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _itemId = value;
    }
}

// 工作经历
- (NSString *)entrytimeStr
{
    return [NSString timeStampToString:self.entrytime formatter:@"YYYY.MM"];
}
- (NSString *)leavetimeStr
{
    if ([self.leavetime isEqualToString:@"943891200"]) {
        return @"至今";
    }
    return [NSString timeStampToString:self.leavetime formatter:@"YYYY.MM"];
}

// 教育经历
- (NSString *)entrancetimeStr
{
    return [NSString timeStampToString:self.entrancetime formatter:@"YYYY.MM"];
}
- (NSString *)graduateStr
{
    if ([self.graduate isEqualToString:@"943891200"]) {
        return @"至今";
    }
    return [NSString timeStampToString:self.graduate formatter:@"YYYY.MM"];
}

// 项目经验
- (NSString *)starttimeStr
{
    return [NSString timeStampToString:self.starttime formatter:@"YYYY.MM"];
}
- (NSString *)endtimeStr
{
    if ([self.endtime isEqualToString:@"943891200"]) {
        return @"至今";
    }
    return [NSString timeStampToString:self.endtime formatter:@"YYYY.MM"];
}


- (void)setEdu:(NSString *)edu
{
    NSArray *array = [EZPublicList getEducationList];
    _edu = [array objectAtIndex:[edu integerValue]];
}

@end
