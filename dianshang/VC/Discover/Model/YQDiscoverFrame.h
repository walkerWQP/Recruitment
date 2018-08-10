//
//  YQDiscoverFrame.h
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <Foundation/Foundation.h>

// 昵称字体
#define XFStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define XFStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define XFStatusCellSourceFont XFStatusCellTimeFont
// 正文字体
#define XFStatusCellContentFont [UIFont systemFontOfSize:15]
// 被转发微博的正文字体
#define XFStatusCellRetweetContentFont [UIFont systemFontOfSize:15]


@class YQDiscover;

@interface YQDiscoverFrame : NSObject

@property (nonatomic, strong) YQDiscover *status;

/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photosViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;
/** 全文/收起按钮 */
@property (nonatomic, assign) CGRect openButtonF;

/** 评论列表 */
@property (nonatomic, assign) CGRect commentListF;

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotosViewF;
/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
