//
//  YQDiscover.h
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YQDiscoverUser;

@interface YQDiscover : NSObject

/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;
/**	bool	是否展开正文*/
@property (nonatomic, assign) BOOL isOpen;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) YQDiscoverUser *user;
/**	string	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	微博来源*/
@property (nonatomic, copy) NSString *source;

/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;

/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property (nonatomic, strong) YQDiscover *retweeted_status;
/**	int	转发数*/
@property (nonatomic, assign) int reposts_count;
/**	int	评论数*/
@property (nonatomic, assign) int comments_count;
/**	array	评论列表*/
@property (nonatomic, strong) NSArray *commentList;
/**	int	点赞数*/
@property (nonatomic, assign) int attitudes_count;
/**	bool 是否点赞*/
@property (nonatomic, assign) BOOL isPraise;
@end
