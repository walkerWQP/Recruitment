
//
//  XFIconView.m
//  Weibo
//
//  Created by Fay on 15/10/4.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "YQIconView.h"
#import "YQDiscoverUser.h"
#import "UIImageView+WebCache.h"

@interface YQIconView ()
@property (nonatomic,weak)UIImageView *verifiedView;
@end
@implementation YQIconView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    
    return self;
}

-(UIImageView *)verifiedView {
    
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc]init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    
    return _verifiedView;
    
}

-(void)setUser:(YQDiscoverUser *)user {
    
    _user = user;
    
    // 1.下载图片
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,user.profile_image_url];
   [self sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    // 2.设置加V图片
    
    switch (user.verified_type) {
        case YQUserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case YQUserVerifiedOrgEnterprice:
        case YQUserVerifiedOrgMedia:
        case YQUserVerifiedOrgWebsite: // 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case YQUserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    
    }
    
    
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.verifiedView.yq_size = self.verifiedView.image.size;
    
    self.verifiedView.yq_x = self.yq_width - self.verifiedView.yq_width * 0.6;
    self.verifiedView.yq_y = self.yq_height - self.verifiedView.yq_height * 0.6;
    
    
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
