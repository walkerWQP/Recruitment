//
//  YQDiscoverUser.m
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQDiscoverUser.h"

@implementation YQDiscoverUser

+(instancetype)userWithDict:(NSDictionary *)dict {
    
    YQDiscoverUser * user= [[self alloc]init];
    user.name = dict[@"name"];
    user.idstr = dict[@"idstr"];
    user.profile_image_url = dict[@"profile_image_url"];
    
    return user;
    
}

-(void)setMbtype:(int)mbtype {
    
    _mbtype = mbtype;
    self.vip = mbtype > 2;
    
}

@end
