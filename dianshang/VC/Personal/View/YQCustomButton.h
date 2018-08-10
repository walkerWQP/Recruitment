//
//  YQCustomButton.h
//  kuainiao
//
//  Created by yunjobs on 16/11/19.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

typedef NS_ENUM(NSInteger, CustomButtonType){
    CustomButtonTypeFixedSize = 0,  //固定大小
    CustomButtonTypeScale = 1,      //按比例缩放
};

#import <UIKit/UIKit.h>

@interface YQCustomButton : UIButton

@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, assign) CustomButtonType type;

/// CustomButtonType = CustomButtonTypeFixedSize 必须赋值
@property (nonatomic, assign) CGSize imageSize;

/// CustomButtonType = CustomButtonTypeScale 必须赋值
@property (nonatomic, assign) CGFloat scale;

@end


///仅在短信模板页面使用
@interface TemplateButton : UIButton

@property (nonatomic, strong) UITableView *table;

@end
