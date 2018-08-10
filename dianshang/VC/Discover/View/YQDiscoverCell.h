//
//  YQMainCell.h
//  dianshang
//
//  Created by yunjobs on 2017/10/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQDiscoverFrame;
@class YQDiscoverPhotoView;

@interface YQDiscoverCell : UITableViewCell

@property (nonatomic,strong) YQDiscoverFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 是否需要工具条 */
@property (nonatomic, assign) BOOL isToolbar;
/** 点赞/分享/评论按钮操作回调 */
@property (nonatomic, strong) void(^toolbarBlock)(NSIndexPath *path, UIButton *sender);

/** 全文/收起按钮操作回调 */
@property (nonatomic, strong) void(^textOpenBlock)(NSIndexPath *path);

/** 图片点击回调 */
@property (nonatomic, strong) void(^photoClickBlock)(NSIndexPath *path, NSMutableArray<NSDictionary *> *photos, YQDiscoverPhotoView *photoView);

@end
