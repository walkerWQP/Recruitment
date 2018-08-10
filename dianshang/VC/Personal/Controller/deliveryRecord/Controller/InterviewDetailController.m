//
//  InterviewDetailController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "InterviewDetailController.h"
#import "HomeJobEntity.h"

#import "NSString+YQWidthHeight.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface InterviewDetailController ()

@property (nonatomic, strong) NSDictionary *resultDict;

@end

@implementation InterviewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"面试详情";
    
    [self reqInterviewDetail];
    
}

- (void)initView
{
    CGFloat w = APP_WIDTH;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, w, 80)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    NSDictionary *dict = self.resultDict;
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    [headView addSubview:headImg];
    NSString *url = [NSString stringWithFormat:@"%@%@",ImageURL,dict[@"logo"]];
    NSString *placeholderImage = @"cheadImg";
    if ([UserEntity getIsCompany]) {
        placeholderImage = @"headImg";
        headImg.layer.cornerRadius = headImg.yq_height*0.5;
        headImg.layer.masksToBounds = YES;
        NSString *a = dict[@"avatar"];
        url = [NSString stringWithFormat:@"%@%@",ImageURL,a];
    }
    [headImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholderImage]];
    
    
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(headImg.yq_right+10, headImg.yq_y, w-headImg.yq_right-20-40, 30)];
    titlelabel.text = dict[@"cname"];
    if ([UserEntity getIsCompany]) {
        titlelabel.text = dict[@"name"];
    }
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:16];
    [headView addSubview:titlelabel];
    
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(titlelabel.yq_x, titlelabel.yq_bottom, w-headImg.yq_right-20-40, 20)];
    NSString *pay = dict[@"pay"];
    if ([pay isEqualToString:@"0-0"]) {
        pay = @"薪资面议";
    }else{
        pay = [pay stringByAppendingString:@"k"];
    }
    NSString *str = [NSString stringWithFormat:@"面试%@(%@)",dict[@"pname"],pay];
    subTitle.text = str;
    subTitle.textColor = RGB(102, 102, 102);
    subTitle.font = [UIFont systemFontOfSize:14];
    [headView addSubview:subTitle];
    
    //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(w-45, 15, 40, 50)];
    //    [button setTitle:@"更改" forState:UIControlStateNormal];
    //    [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    //    button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    //    button.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [button addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [headView addSubview:button];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 80-1, APP_WIDTH-20, 0.5)];
    lineView.backgroundColor = RGB(239, 239, 239);
    [headView addSubview:lineView];
    
    
    NSArray *array = @[@"时间:",@"地点:",@"补充说明:"];
    NSArray *dataArr = @[dict[@"date"],dict[@"address"],dict[@"describe"]];
    CGFloat height = 45;
    CGFloat top = headView.yq_bottom;
    CGFloat left = 15;
    
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, top, w, 80)];
    detailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:detailView];
    
    for (int i = 0; i < array.count; i++) {
//        UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, height, height)];
//        headImg.image = [UIImage imageNamed:@"a"];
//        [headView addSubview:headImg];
        
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, i*height, 60, height)];
        subTitle.text = array[i];
        subTitle.textColor = RGB(51, 51, 51);
        subTitle.font = [UIFont systemFontOfSize:14];
        [subTitle sizeToFit];
        subTitle.yq_width += 5;
        subTitle.yq_height = height;
        [detailView addSubview:subTitle];
        
        CGFloat ww = w-subTitle.yq_right-20;
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(subTitle.yq_right+10, subTitle.yq_y, ww, height)];
        titlelabel.text = dataArr[i];
        //titlelabel.backgroundColor = RandomColor;
        titlelabel.textColor = RGB(51, 51, 51);
        titlelabel.numberOfLines = 0;
        titlelabel.font = [UIFont systemFontOfSize:16];
        [detailView addSubview:titlelabel];
        if (i == array.count-1) {
            [titlelabel sizeToFit];
            if (titlelabel.yq_height < height) {
                titlelabel.yq_height = height;
            }
            titlelabel.yq_width = ww;
            detailView.yq_height = titlelabel.yq_bottom;
        }
        
        if (i != array.count-1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, titlelabel.yq_bottom-1, APP_WIDTH-20, 0.5)];
            lineView.backgroundColor = RGB(239, 239, 239);
            [detailView addSubview:lineView];
        }
    }
    NSString *redpacket = dict[@"redpacket"];
    if (redpacket.length > 0) {
        if ([redpacket floatValue] > 0){
            [self redpacketView:detailView redpacket:redpacket];
        }
    }
}

- (UIView *)redpacketView:(UIView *)storePhotoView redpacket:(NSString *)redpacket
{
    CGFloat w = self.view.yq_width;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, 95)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    contentView.layer.masksToBounds = YES;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, w-16, 45)];
    titlelabel.text = @"面试红包: 您有红包面试邀请哦,只有您真实面试后企业确定您已面试,红包才会到账您的账户余额.";
    if ([UserEntity getIsCompany]) {
        titlelabel.text = @"面试红包: 只有人才真实面试后,您在对应职位已面试列表点击是否通过,红包才会发放给人才哦.如果人才没有来面试请点击未面试,红包金额会返回到您的余额.";
        titlelabel.yq_height += 20;
        contentView.yq_height += 20;
    }
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:14];
    titlelabel.numberOfLines = 0;
    [contentView addSubview:titlelabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, titlelabel.yq_bottom+5, 75, 35)];
    label.text = @"红包金额";
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.yq_right, label.yq_y, contentView.yq_width-label.yq_right-15, 35)];
    tf.text = [NSString stringWithFormat:@"%@元",redpacket];
    tf.textColor = [UIColor redColor];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.font = [UIFont systemFontOfSize:14];
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    tf.enabled = NO;
    [contentView addSubview:tf];
    
//    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, label.yq_bottom+5, contentView.yq_width-16, 45)];
//    tipLabel.text = @"您有红包面试邀请哦,只有您真实面试后企业确定您已面试,红包才会到账您的账户余额.";
//    tipLabel.textColor = RGB(51, 51, 51);
//    tipLabel.font = [UIFont systemFontOfSize:14];
//    tipLabel.numberOfLines = 0;
//    [contentView addSubview:tipLabel];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(tf.yq_x-5, tf.yq_bottom+0, tf.yq_width+5, 1)];
//    lineView.backgroundColor = THEMECOLOR;
//    [contentView addSubview:lineView];
    
    return contentView;
}

- (void)reqInterviewDetail
{
    NSString *typeStr = @"2";
    if ([UserEntity getIsCompany]) {
        typeStr = @"1";
    }
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] interviewDetail_uid:[UserEntity getUid] orderid:self.orderid type:typeStr success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            self.resultDict = resultDic[DATA];
            
            [self initView];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
