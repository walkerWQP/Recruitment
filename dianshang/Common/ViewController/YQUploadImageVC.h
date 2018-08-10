//
//  YQUploadImageVC.h
//  kuainiao
//
//  Created by yunjobs on 16/8/23.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

typedef NS_ENUM(NSUInteger, YQImageClipType) {
    YQClipTypeRectangle = 1, // 长方形
    YQClipTypeSquare = 2, // 正方形
};

#import "YQTableViewController.h"

@interface YQUploadImageVC : YQTableViewController

@property (nonatomic, strong) MBProgressHUD *slideView;//上传进度

@property (nonatomic, assign) BOOL isClip;

//打开选择图片的UIActionSheet
- (void)openActionSheet:(YQImageClipType)clipType;

//在这个方法里上传照片需要继承者重写
- (void)uploadImage:(UIImage *)originImage filePath:(NSString *)filePath;

@end
