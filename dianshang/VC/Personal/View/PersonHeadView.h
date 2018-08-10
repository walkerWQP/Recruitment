//
//  PersonHeadView.h
//  dianshang
//
//  Created by yunjobs on 2017/9/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

//#define kHeadViewH 200+180
#define kHeadImgWH 90

#import <UIKit/UIKit.h>

@class PersonItem;

@protocol PersonHeadViewDelegate <NSObject>

- (void)buttonViewClick:(UIButton *)sender item:(PersonItem *)item;
- (void)messageBtnClick:(UIButton *)messageBtn;
- (void)headImageTap:(UIImageView *)headImage;

@end

@interface PersonHeadView : UIView

@property (weak, nonatomic) id<PersonHeadViewDelegate> delegate;

@property (strong, nonatomic) NSString *headImageUrl;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *balance;
@property (strong, nonatomic) NSString *synopsis;

+ (CGFloat)personHeadHeight;

@end
