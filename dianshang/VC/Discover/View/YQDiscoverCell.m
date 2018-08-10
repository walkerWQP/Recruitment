//
//  YQMainCell.m
//  dianshang
//
//  Created by yunjobs on 2017/10/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#import <CoreText/CoreText.h>

#import "YQDiscoverCell.h"
#import "YQIconView.h"
#import "YQDiscoverPhotosView.h"
#import "YQDiscoverPhotoView.h"
#import "YQDiscoverToolBar.h"
#import "YQDiscoverCommentView.h"

#import "UITableViewCell+YQIndexPath.h"
#import "NSString+Extension.h"
#import "UILabel+YBAttributeTextTapAction.h"

#import "YQDiscoverFrame.h"
#import "YQDiscover.h"
#import "YQDiscoverUser.h"

@interface YQDiscoverCell ()<YBAttributeTapActionDelegate,YQDiscoverPhotosViewDelegate,YQDiscoverToolBarDelegate>

/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) YQIconView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) YQDiscoverPhotosView *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 正文 */
@property (nonatomic, weak) UIButton *openButton;

/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property (nonatomic, weak) YQDiscoverPhotosView *retweetPhotosView;

/** 工具条 */
@property (nonatomic, weak) YQDiscoverToolBar *toolbar;

/** 评论视图 */
@property (nonatomic, weak) YQDiscoverCommentView *commentView;

@end

@implementation YQDiscoverCell

+(instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"status";
    
    YQDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[YQDiscoverCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.isToolbar = YES;
        self.backgroundColor = [UIColor whiteColor];
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化原创微博
        [self setupOriginal];
        // 初始化转发微博
        [self setupRetweet];
        //初始化工具条
        [self setupToolbar];
        
        [self setupCommentView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, YQStatusCellSpacing*2)];
        view.backgroundColor = RGB(239, 239, 239);
        [self.contentView addSubview:view];
    }
    return  self;
}
- (void)setupCommentView
{
    YQDiscoverCommentView *commentView = [YQDiscoverCommentView commentView];
    [self.contentView addSubview:commentView];
    
    self.commentView = commentView;
    
    //commentView.backgroundColor = RandomColor;
}
/**
 *   初始化工具条
 */
-(void)setupToolbar{
    
    YQDiscoverToolBar *toolbar = [[YQDiscoverToolBar alloc]init];
    //toolbar.backgroundColor = [UIColor orangeColor];
    toolbar.delegate = self;
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
    
    //toolbar.backgroundColor = RandomColor;
}

/**
 * 初始化转发微博
 */
- (void)setupRetweet {
    
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = RGB(240, 240, 240);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.numberOfLines = 0;
    //retweetContentLabel.userInteractionEnabled = YES;
    retweetContentLabel.font = XFStatusCellRetweetContentFont;
    retweetContentLabel.lineBreakMode = NSLineBreakByClipping;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    YQDiscoverPhotosView *retweetPhotosView = [[YQDiscoverPhotosView alloc] init];
    //retweetPhotosView.backgroundColor = [UIColor blueColor];
    [retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView = retweetPhotosView;
    
    //self.retweetContentLabel.backgroundColor = RandomColor;
}

/**
 * 初始化原创微博
 */
- (void)setupOriginal {
    
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    YQIconView *iconView = [[YQIconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    YQDiscoverPhotosView *photosView = [[YQDiscoverPhotosView alloc] init];
    [originalView addSubview:photosView];
    self.photosView = photosView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = XFStatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = XFStatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = XFStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = XFStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    /** 全文/收起按钮 */
    UIButton *openBtn = [[UIButton alloc] init];
    [originalView addSubview:openBtn];
    [openBtn setTitle:@"全文" forState:UIControlStateNormal];
    [openBtn setTitle:@"收起" forState:UIControlStateSelected];
    [openBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    //[openBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openDetail:) forControlEvents:UIControlEventTouchUpInside];
    openBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    openBtn.titleLabel.font = XFStatusCellContentFont;
    self.openButton = openBtn;
    
    
    //contentLabel.backgroundColor = RandomColor;
    //openBtn.backgroundColor = RandomColor;
    //iconView.backgroundColor = RandomColor;
    //nameLabel.backgroundColor = RandomColor;
}

-(void)setStatusFrame:(YQDiscoverFrame *)statusFrame {
    
    _statusFrame = statusFrame;
    YQDiscover *status = statusFrame.status;
    YQDiscoverUser *user = status.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.user = user;
    self.iconView.layer.cornerRadius = statusFrame.iconViewF.size.width*0.5;
    self.iconView.layer.masksToBounds = YES;
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (status.pic_urls.count) {
        self.photosView.frame = statusFrame.photosViewF;
        
        self.photosView.photos = status.pic_urls;
        self.photosView.delegate = self;
        self.photosView.hidden = NO;
        
    }else {
        self.photosView.delegate = nil;
        self.photosView.hidden = YES;
    }
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = status.created_at;
    CGFloat timeX = statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelF) + YQStatusCellSpacing;
    CGSize timeSize = [time sizeWithFont:XFStatusCellTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + YQStatusCellSpacing;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:XFStatusCellSourceFont];
    self.sourceLabel.textColor = [UIColor grayColor];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    self.sourceLabel.text = status.source;
    
    
    /** 正文 */
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    // 详情里面默认全部展开不需要显示收起按钮
    if (self.isToolbar) {
        if (statusFrame.openButtonF.size.height > 0) {
            self.openButton.selected = status.isOpen;
            self.openButton.frame = statusFrame.openButtonF;
            self.openButton.hidden = NO;
        }else{
            self.openButton.hidden = YES;
        }
    }else{
        self.openButton.hidden = YES;
    }
    
    /** 被转发的微博 */
    if (status.retweeted_status) {
        YQDiscover *retweeted_status = status.retweeted_status;
        
        self.retweetView.hidden = NO;
        /** 被转发的微博整体 */
        self.retweetView.frame = statusFrame.retweetViewF;
        
        /** 被转发的微博正文 */
        // 设置转发体内容富文本
        [self retweetContentAttributedString:statusFrame];
        
        /** 被转发的微博配图 */
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewF;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
            self.retweetPhotosView.hidden = NO;
        } else {
            self.retweetPhotosView.hidden = YES;
        }
    } else {
        self.retweetView.hidden = YES;
    }
    
    if (self.isToolbar) {
        self.toolbar.frame = statusFrame.toolbarF;
        self.toolbar.status = status;
        self.toolbar.hidden = NO;
    }else{
        self.toolbar.hidden = YES;
    }
    
    // 在详情里面不显示工具条也就是不显示评论列表
    if (self.isToolbar) {
        if (status.commentList.count>0) {
            self.commentView.frame = statusFrame.commentListF;
            self.commentView.list = status.commentList;
            self.commentView.hidden = NO;
        }else{
            self.commentView.hidden = YES;
        }
    }else{
        self.commentView.hidden = YES;
    }
}

- (void)openDetail:(UIButton *)sender
{
    NSIndexPath *path = [self indexPathWithView:sender];
    if (self.textOpenBlock) {
        self.textOpenBlock(path);
    }
}

#pragma mark - YQDiscoverPhotosViewDelegate

- (void)photoViewSelected:(YQDiscoverPhotosView *)photosView photoView:(YQDiscoverPhotoView *)photoView photoViewArray:(NSMutableArray<NSDictionary *> *)array
{
    if (self.photoClickBlock) {
        NSIndexPath *path = [self indexPathWithView:photoView];
        self.photoClickBlock(path,array,photoView);
    }
}
#pragma mark - YQDiscoverToolBarDelegate

- (void)toolBarButton:(UIButton *)sender
{
    if (self.toolbarBlock) {
        NSIndexPath *path = [self indexPathWithView:sender];
        self.toolbarBlock(path, sender);
    }
}
#pragma mark - private

- (void)retweetContentAttributedString:(YQDiscoverFrame *)statusFrame
{
    YQDiscover *status = statusFrame.status;
    YQDiscover *retweeted_status = status.retweeted_status;
    YQDiscoverUser *retweeted_status_user = retweeted_status.user;
    
    NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
    self.retweetContentLabel.text = retweetContent;
    self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
    
    // 如果text高度大于最大值
    if (statusFrame.retweetContentLabelF.size.height == YQStatusTextMaxH) {
        NSArray *arr = [self getSeparatedLinesFromLabel:self.retweetContentLabel];
        NSInteger length = 0;
//        NSInteger row = 0;
        for (NSString *string in arr) {
            if ([string isEqualToString:arr.lastObject]) {
                length += ([string length]-4);
            }else{
                length += [string length];
            }
//            row++;
//            if (row == 2) {
//                length += ([string length]-4);
//                break;
//            }else{
//                length += [string length];
//            }
        }
        retweetContent = [retweetContent substringToIndex:length];
        retweetContent = [retweetContent stringByAppendingString:@"...全文"];
        self.retweetContentLabel.text = retweetContent;
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:THEMECOLOR forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString *mAstring = [[NSMutableAttributedString alloc] initWithString:retweetContent];
    // 给转发体姓名设置颜色
    [mAstring addAttributes:dict range:NSMakeRange(0, retweeted_status_user.name.length+1)];
    // 字体大小self.retweetContentLabel 保持一致
    [mAstring addAttributes:@{NSFontAttributeName:self.retweetContentLabel.font} range:NSMakeRange(0, retweetContent.length)];
    // 调整行间距
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:3];
//    [mAstring addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, retweetContent.length)];
    if (statusFrame.retweetContentLabelF.size.height == YQStatusTextMaxH)
    {
        // 如果高度超出最大值就给最后两个字(全文)设置颜色
        [mAstring addAttributes:dict range:NSMakeRange(retweetContent.length-2, 2)];
    }
    self.retweetContentLabel.attributedText = mAstring;
    // 添加点击回调
    [self.retweetContentLabel yb_addAttributeTapActionWithStrings:@[retweeted_status_user.name,@"全文"] delegate:self];
}

-(NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label attributedText].string;
    UIFont *font = [label font];
    CGRect rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    // 获取行高
    CGSize size = [self yq_getLineSizes:(__bridge CTLineRef )lines.firstObject];
    // 最多能放几行
    NSInteger count = floor(YQStatusTextMaxH / size.height);
    
    //for (id line in lines)
    for (int i = 0; i < count; i++)
    {
        if (i < lines.count) {
            id line = [lines objectAtIndex:i];
            CTLineRef lineRef = (__bridge CTLineRef )line;
            CFRange lineRange = CTLineGetStringRange(lineRef);
            NSRange range = NSMakeRange(lineRange.location, lineRange.length);
            
            NSString *lineString = [text substringWithRange:range];
            [linesArray addObject:lineString];
        }else{
            break;
        }
    }
    return (NSArray *)linesArray;
}

- (CGSize)yq_getLineSizes:(CTLineRef)line
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent) + leading;
    
    return CGSizeMake(width, height);
}

#pragma mark - YBAttributeTapActionDelegate

- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    CLog(@"%@",string);
}
@end
