//
//  DetailRecord.h
//  dianshang
//
//  Created by yunjobs on 2017/9/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailRecordEntity : NSObject

//@property (nonatomic, copy) NSString *alipay;
//@property (nonatomic, copy) NSString *uid;
//@property (nonatomic, copy) NSString *updatetime;
//@property (nonatomic, copy) NSString *itemId;
//@property (nonatomic, copy) NSString *status;
//@property (nonatomic, copy) NSString *astatus;
//@property (nonatomic, copy) NSString *mstatus;
//@property (nonatomic, copy) NSString *alipayname;
//@property (nonatomic, copy) NSString *createtime;
//@property (nonatomic, copy) NSString *money;
//@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *astatus;
@property (nonatomic, copy) NSString *type; //1充值记录；2、消费记录；3、提现记录

+ (instancetype)entityWithDict:(NSDictionary *)dict;


@end
