//
//  YQBannerView.h
//  kuainiao
//
//  Created by yunjobs on 16/11/25.
//  Copyright © 2016年 yunjobs. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YQPageControlShowStyle)
{
    YQPageControlShowStyleNone,//default
    YQPageControlShowStyleLeft,
    YQPageControlShowStyleCenter,
    YQPageControlShowStyleRight,
};


@class YQBannerItem;

@interface YQBannerView : UIScrollView

@property (nonatomic, strong) NSMutableArray *items;
@property (assign,nonatomic,readwrite) YQPageControlShowStyle pageControlShowStyle;

/// 点击操作
@property (nonatomic, strong) void(^itemPress)(NSInteger index, YQBannerItem *item);
- (void)itemPress:(void(^)(NSInteger index, YQBannerItem *item))block;

- (void)stopTimer;

@end


@interface YQBannerItem : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *Id;

@property (nonatomic, strong) NSDictionary *ext;

+ (instancetype)itemWithDictionary:(NSDictionary *)dict;

@end
