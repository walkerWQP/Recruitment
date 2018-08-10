//
//  ResumeBrowerDetail.h
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResumeManageEntity;
@interface ResumeBrowerDetail : UIView

+ (instancetype)ResumeBrowerDetailView;
+ (CGFloat)detailViewHeight:(ResumeManageEntity *)entity;

@property (nonatomic, strong) ResumeManageEntity *entity;
@property (nonatomic, strong) void(^previewClick)(ResumeManageEntity *entity);
// 是否隐藏附件简历按钮
@property (nonatomic, assign) BOOL isPreviewBtn;

@end


@class ResumeManageSubEntity;
@interface RBDetailSubView : UIView

+ (instancetype)RBDetailView;

/// 1->工作经历;2->项目经验;3->教育经历
@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, strong) ResumeManageSubEntity *entity;

+ (CGFloat)detailViewHeight:(NSString *)str;

@end
