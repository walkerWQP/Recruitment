//
//  ResumeBrowerDetail.m
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ResumeBrowerDetail.h"

#import "ResumeManageEntity.h"

#import "NSString+MyDate.h"
#import "NSString+YQWidthHeight.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ResumeBrowerDetail()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *companyLbl;
@property (weak, nonatomic) IBOutlet UILabel *restatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *workLbl;
@property (weak, nonatomic) IBOutlet UILabel *eduLbl;
@property (weak, nonatomic) IBOutlet UILabel *salaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@property (weak, nonatomic) IBOutlet UILabel *jobNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLbl;
@property (weak, nonatomic) IBOutlet UILabel *jobCityLbl;
@property (weak, nonatomic) IBOutlet UILabel *jobTradeLbl;
// 附件简历按钮
@property (weak, nonatomic) IBOutlet UIButton *enclosureBtn;

@end

@implementation ResumeBrowerDetail

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImgV.layer.cornerRadius = self.headImgV.yq_height*0.5;
    self.headImgV.layer.masksToBounds = YES;
    
//    self.enclosureBtn.layer.cornerRadius = self.enclosureBtn.yq_height *0.5;
//    self.enclosureBtn.layer.borderColor = THEMECOLOR.CGColor;
//    self.enclosureBtn.layer.borderWidth = 1.0f;
    [self.enclosureBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.enclosureBtn addTarget:self action:@selector(enclosureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

+ (instancetype)ResumeBrowerDetailView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    ResumeBrowerDetail *view = nil;
    for (UIView *v in array) {
        if (v.tag == 1) {
            view = (ResumeBrowerDetail *)v;
            break;
        }
    }
    return view;
}

+ (CGFloat)detailViewHeight:(ResumeManageEntity *)entity
{
    CGFloat h = [entity.desc yq_stringHeightWithFixedWidth:APP_WIDTH-30 font:14];
    if (h < 17) {
        h = 17;
    }
    CGFloat TopVH = (328-17) + h;
    return TopVH;
}

- (void)setEntity:(ResumeManageEntity *)entity
{
    _entity = entity;
    
    NSString *str = [NSString stringWithFormat:@"%@%@",ImageURL,entity.avatar];
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headImg"]];
    self.nameLbl.text = entity.name;
    //self.companyLbl.text = entity.name;
    self.descLbl.text = entity.desc;
    NSString *workStr = [entity.year stringByAppendingString:@"年"];
    self.workLbl.text = [entity.year integerValue] == 0 ? @"应届生" : workStr;
    self.eduLbl.text = entity.edu;
    self.salaryLbl.text = [entity.age stringByAppendingString:@"岁"];
    
    if ([entity.is_asset isEqualToString:@"1"]) {
        self.enclosureBtn.hidden = NO;
    }else{
        self.enclosureBtn.hidden = YES;
    }
    
    self.restatusLbl.text = [[EZPublicList getJobIntentionStateList] objectAtIndex:[entity.restatus integerValue]];
    NSString *status = @"";
    if ([entity.restatus isEqualToString:@"1"]||[entity.restatus isEqualToString:@"2"]) {
        status = @"在职 ";
    }else if ([entity.restatus isEqualToString:@"3"]){
        status = @"曾任 ";
    }
    if (entity.pname == nil || entity.companyname == nil) {
        self.companyLbl.text = [NSString stringWithFormat:@"%@",status];
    }else{
        self.companyLbl.text = [NSString stringWithFormat:@"%@%@·%@",status,entity.pname,entity.companyname];
    }
    if (entity.working.count > 0) {
        NSDictionary *dict = entity.working.firstObject;
        self.jobNameLbl.text = dict[@"pname"];
        self.jobCityLbl.text = dict[@"city"];
        if ([dict[@"top_salary"] integerValue] == 0) {
            self.jobSalaryLbl.text = @"面议";
        }else{
            self.jobSalaryLbl.text = [NSString stringWithFormat:@"%@-%@k",dict[@"low_salary"],dict[@"top_salary"]];
        }
        self.jobTradeLbl.text = dict[@"tradename"];
        
    }else{
        
    }
}
- (void)setIsPreviewBtn:(BOOL)isPreviewBtn
{
    self.enclosureBtn.hidden = isPreviewBtn;
}
- (void)enclosureBtnClick:(UIButton *)sender
{
    if (self.previewClick) {
        self.previewClick(self.entity);
    }
}

@end

@interface RBDetailSubView()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation RBDetailSubView

+ (instancetype)RBDetailView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ResumeBrowerDetail" owner:nil options:nil];
    RBDetailSubView *view = nil;
    for (UIView *v in array) {
        if (v.tag == 2) {
            view = (RBDetailSubView *)v;
            break;
        }
    }
    return view;
}
- (void)setEntity:(ResumeManageSubEntity *)entity
{
    if (self.flag == 1) {
        self.title.text = entity.companyname;
        self.subTitle.text = entity.position;
//        NSString *start = [entity.entrytime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//        NSString *end = [entity.leavetime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.time.text = [NSString stringWithFormat:@"%@-%@",entity.entrytimeStr,entity.leavetimeStr];
        self.content.text = entity.content;
    }else if (self.flag == 2) {
        self.title.text = entity.pname;
        self.subTitle.text = entity.duty;
        //        NSString *start = [entity.entrytime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        //        NSString *end = [entity.leavetime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.time.text = [NSString stringWithFormat:@"%@-%@",entity.starttimeStr,entity.endtimeStr];
        self.content.text = entity.describetion;
    }else if (self.flag == 3) {
        self.title.text = entity.schoolname;
        self.subTitle.text = [NSString stringWithFormat:@"%@ | %@",entity.edu,entity.major];
        //        NSString *start = [entity.entrytime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        //        NSString *end = [entity.leavetime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.time.text = [NSString stringWithFormat:@"%@-%@",entity.entrancetimeStr,entity.graduateStr];
        self.content.text = entity.experience;
    }
}

+ (CGFloat)detailViewHeight:(NSString *)str
{
    CGFloat h = [str yq_stringHeightWithFixedWidth:APP_WIDTH-30 font:14];
    if (h < 34) {
        h = 34;
    }
    CGFloat TopVH = (110-34) + h;
    return TopVH;
}

@end


