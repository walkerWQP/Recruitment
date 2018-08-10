//
//  MessageCell.m
//  kuainiao
//
//  Created by yunjobs on 16/4/2.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "MessageCell.h"
#import "MessageEntity.h"

#import "NSString+MyDate.h"

@interface MessageCell ()
{
    UILabel *timeLbl;
    UILabel *titleLbl;
    UILabel *contentLbl;
}
@end

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initView];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    UINib *nib1 = [UINib nibWithNibName:@"MessageCell" bundle:nil];
    [tableView registerNib:nib1 forCellReuseIdentifier:@"message"];
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    
    return cell;
}

- (void)initView
{
    titleLbl = [self labelEdit:CGRectMake(10, 8, (APP_WIDTH-20)/2+50, 25) fontSize:16 align:NSTextAlignmentLeft];
    [self addSubview:titleLbl];
    
    timeLbl = [self labelEdit:CGRectMake(titleLbl.yq_right, 8, (APP_WIDTH-20)/2-50, 25) fontSize:16 align:NSTextAlignmentRight];
    timeLbl.textColor = RGB(180, 180, 180);
    [self addSubview:timeLbl];
    
    contentLbl = [self labelEdit:CGRectMake(10, titleLbl.yq_bottom, APP_WIDTH-20, 25) fontSize:13 align:NSTextAlignmentLeft];
    contentLbl.numberOfLines = 0;
    contentLbl.textColor = RGB(180, 180, 180);
    contentLbl.adjustsFontSizeToFitWidth = NO;
    [self addSubview:contentLbl];
}

- (UILabel *)labelEdit:(CGRect)frame fontSize:(int)fontSize align:(NSTextAlignment)align
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    //label.backgroundColor = RandomColor;
    [label setAdjustsFontSizeToFitWidth:YES];//字体自适应大小
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = align;
    return label;
}

- (void)setItem:(MessageEntity *)entity
{
    NSString *timeStr = [NSString stringWithFormat:@"%@",entity.createtime];
    
    timeLbl.text = [NSString timeStampToString:timeStr formatter:YYYYMMddHHmmss];
    titleLbl.text = entity.title;
    contentLbl.text = entity.message;
    contentLbl.yq_height = [self yq_textHeight:entity.message size:CGSizeMake(contentLbl.yq_width, MAXFLOAT) font:14].height;
}

- (CGSize)yq_textHeight:(NSString *)text size:(CGSize)size font:(NSInteger)font
{
    CGSize stringSize = CGSizeZero;
    if (text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringSize =[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                     context:nil].size;
#else
        
        stringSize = [text sizeWithFont:[UIFont systemFontOfSize:font]
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByCharWrapping];
#endif
    }
    return stringSize;
}

//- (void)setMesgCell:(MessageEntity *)entity
//{
//    NSString *confromTimespStr = [NSString timeStampToString:entity.create_time formatter:YYYYMMddHHmmss];
//    
//    timeLbl.text = confromTimespStr;
//    titleLbl.text = entity.mesTitle;
//    contentLbl.text = entity.mesContent;
//}

@end
