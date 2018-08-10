//
//  MemberDetailEntity.h
//  dianshang
//
//  Created by yunjobs on 2017/11/23.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberDetailEntity : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *identify;
@property (nonatomic, copy) NSString *approve;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *cvedit;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *tradename;

@property (nonatomic, copy) NSMutableArray *positions;

+ (instancetype)MemberDetailEntityWithDict:(NSDictionary *)dict;

@end
