//
//  YQDiscoverFrame.m
//  dianshang
//
//  Created by yunjobs on 2017/10/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "YQDiscoverFrame.h"
#import "YQDiscover.h"
#import "YQDiscoverUser.h"
#import "NSString+Extension.h"
#import "YQDiscoverPhotosView.h"
#import "YQDiscoverComment.h"
#import "YQDiscoverCommentView.h"

@implementation YQDiscoverFrame

-(void)setStatus:(YQDiscover *)status {
    
    _status  = status;
    
    YQDiscoverUser *user = status.user;
    // cell的宽度
    
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 40;
    CGFloat iconX = YQStatusCellPadding;
    CGFloat iconY = YQStatusCellPadding;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + YQStatusCellSpacing;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:XFStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX,nameY},nameSize};
    
    
    /** 会员图标 */
    if (user.isVip) {
        
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + YQStatusCellSpacing;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + YQStatusCellSpacing;
    CGSize timeSize = [status.created_at sizeWithFont:XFStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + YQStatusCellSpacing;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:XFStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    
    /** 正文 */
    
    CGFloat contentX = YQStatusCellPadding;
    CGFloat contentY = CGRectGetMaxY(self.iconViewF) + YQStatusCellSpacing;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeWithFont:XFStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    if (contentSize.height > YQStatusTextMaxH) {
        if (status.isOpen) {
            self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
        }else{
            self.contentLabelF = (CGRect){{contentX, contentY}, CGSizeMake(maxW, YQStatusTextMaxH)};
        }
        /** 全文/收起按钮 */
        CGFloat openButtonX = YQStatusCellPadding;
        CGFloat openButtonY = CGRectGetMaxY(self.contentLabelF);
        CGSize openButtonSize = CGSizeMake(60, 25);
        self.openButtonF = (CGRect){{openButtonX, openButtonY}, openButtonSize};
    }else{
        CGFloat openButtonX = YQStatusCellPadding;
        CGFloat openButtonY = CGRectGetMaxY(self.contentLabelF);
        CGSize openButtonSize = CGSizeZero;
        self.openButtonF = (CGRect){{openButtonX, openButtonY}, openButtonSize};
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = YQStatusCellSpacing;
    CGFloat originalW = cellW;
    
    /** 配图 */
    CGFloat originalH = 0;
    if (status.pic_urls.count) {
        CGFloat photosX = YQStatusCellPadding;
        CGFloat photosY = CGRectGetMaxY(self.openButtonF) + YQStatusCellSpacing;
        CGSize photosSize = [YQDiscoverPhotosView sizeWithCount:(int)status.pic_urls.count superWidth:originalW];
        self.photosViewF = (CGRect){{photosX, photosY}, photosSize};
        originalH = CGRectGetMaxY(self.photosViewF) + YQStatusCellSpacing;
    }else { // 没配图
        originalH = CGRectGetMaxY(self.openButtonF) + YQStatusCellSpacing;
    }
    
    
    /** 原创微博整体 */
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    
    
    CGFloat toolbarY = 0;
    /* 被转发微博 */
    if (status.retweeted_status) {
        YQDiscover *retweeted_status = status.retweeted_status;
        YQDiscoverUser *retweeted_status_user = retweeted_status.user;
        
        /** 被转发微博正文 */
        CGFloat retweetContentX = YQStatusCellPadding*0.5;
        CGFloat retweetContentY = YQStatusCellSpacing;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        CGSize retweetContentSize = [retweetContent sizeWithFont:XFStatusCellRetweetContentFont maxW:maxW-retweetContentX*2];
        
        if (retweetContentSize.height > YQStatusTextMaxH) {
            retweetContentSize.height = YQStatusTextMaxH;
            //status.retweeted_status.text = [status.retweeted_status.text stringByAppendingString:@"全文"];
        }
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        /** 被转发微博整体 */
        CGFloat retweetX = YQStatusCellPadding;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW-retweetX*2;
        
        /** 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) { // 转发微博有配图
            CGSize retweetPhotosSize = [YQDiscoverPhotosView sizeWithCount:(int)retweeted_status.pic_urls.count superWidth:retweetW];
            CGFloat retweetPhotosX = retweetContentX;
            CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + YQStatusCellSpacing*2;
            self.retweetPhotosViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetPhotosSize};
            
            retweetH = CGRectGetMaxY(self.retweetPhotosViewF) + YQStatusCellSpacing;
        } else { // 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + YQStatusCellSpacing;
        }
        
        /** 被转发微博整体 */
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        toolbarY = CGRectGetMaxY(self.retweetViewF) + YQStatusCellSpacing;
    } else {
        toolbarY = CGRectGetMaxY(self.originalViewF) + YQStatusCellSpacing;
    }
    
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 40;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /** 评论列表高度 */
    
    if (status.commentList.count > 0) {
        CGFloat commentX = YQStatusCellPadding;
        CGFloat commentY = CGRectGetMaxY(self.toolbarF)+YQStatusCellSpacing;
        CGFloat commentW = cellW - commentX*2;
        CGFloat commentH = [YQDiscoverCommentView commentViewHeightWithFixedWidth:commentW commentList:status.commentList];
        
        self.commentListF = CGRectMake(commentX, commentY, commentW, commentH);
        
        /* cell的高度 */
        self.cellHeight = CGRectGetMaxY(self.commentListF) + YQStatusCellPadding;
        
    }else{
        /* cell的高度 */
        self.cellHeight = CGRectGetMaxY(self.toolbarF) + YQStatusCellPadding;
    }
    
    
    
    
    
}

@end
