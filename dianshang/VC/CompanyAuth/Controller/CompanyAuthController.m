//
//  CompanyAuthController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyAuthController.h"
#import "EZCPersonCenterEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CompanyAuthController ()
{
    NSInteger headTag;
}
@property (nonatomic, strong) UIImageView *frontImageV;
@property (nonatomic, strong) UIImageView *backImageV;

@property (nonatomic, strong) NSString *frontUrl;//
@property (nonatomic, strong) NSString *backUrl;//

@property (nonatomic, strong) UITextField *cardNumTxt;//

@property (nonatomic, strong) UIScrollView *scroller;

@end

@implementation CompanyAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"负责人身份认证";
    
    [self initView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"保存" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
}

- (void)initView
{
    CGFloat w = APP_WIDTH;
    CGFloat h = 250;
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, APP_HEIGHT-APP_NAVH)];
    //[scroller setContentSize:CGSizeMake(w, (array.count+1)*h+50)];
    [scroller addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerClick)]];
    [self.view addSubview:scroller];
    self.scroller = scroller;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, w, h)];
    contentView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:contentView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 75, 35)];
    label.text = @"身份证号";
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.yq_right, label.yq_y, contentView.yq_width-label.yq_right-15, 35)];
    tf.text = @"";
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:tf];
    self.cardNumTxt = tf;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(tf.yq_x-5, tf.yq_bottom+0, tf.yq_width+5, 1)];
    lineView.backgroundColor = THEMECOLOR;
    [contentView addSubview:lineView];
    
    NSArray *array = @[@"身份证正面照",@"身份证反面照"];
    CGFloat y = label.yq_bottom+10;
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, y+i*245, 200, 35)];
        titlelabel.text = array[i];
        titlelabel.textColor = RGB(51, 51, 51);
        titlelabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:titlelabel];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom+8, contentView.yq_width-30, 200)];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.backgroundColor = RGB(243, 243, 243);
        imageV.userInteractionEnabled = YES;
        [contentView addSubview:imageV];
        imageV.tag = i+1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick:)];
        [imageV addGestureRecognizer:tap];
        
        if (i == 0) {
            self.frontImageV = imageV;
        }else if (i == 1){
            self.backImageV = imageV;
        }
    }
    
    contentView.yq_height = self.backImageV.yq_bottom+10;
    
    y = contentView.yq_bottom;
    CGFloat x = 0;
    CGFloat jianju = 8;
    
    for (int i = 0; i < 1; i++) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(x, y+jianju*(i+1)+h*i, w, 90)];
        contentView.backgroundColor = [UIColor whiteColor];
        [scroller addSubview:contentView];
        //self.contentView = contentView;
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 35)];
        titlelabel.text = @"注意事项:";
        titlelabel.textColor = RGB(51, 51, 51);
        titlelabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:titlelabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_bottom-15)];
        label.text = @"请上传公司负责人的有效身份证件信息";
        label.numberOfLines = 0;
        label.textColor = RGB(102, 102, 102);
        label.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:label];
    }
    
    scroller.contentSize = CGSizeMake(APP_WIDTH, y+100);
    
    EZCompanyInfoEntity *en = self.entity.companyEn;
    if (![en.id_card_num isEqualToString:@""]) {
        self.cardNumTxt.text = en.id_card_num;
    }
    if (![en.id_card_top isEqualToString:@""]) {
        [self.frontImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,en.id_card_top]]];
        self.frontUrl = en.id_card_top;
    }
    if (![en.id_card_bottom isEqualToString:@""]) {
        [self.backImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,en.id_card_bottom]]];
        self.backUrl = en.id_card_bottom;
    }
}

#pragma mark - 选择头像
//点击头像选择图库还是拍照
- (void)headTapClick:(UIGestureRecognizer *)sender
{
    [self hideKeyboard];
    headTag = sender.view.tag;
    self.isClip = NO;//表示不需要裁剪
    [self openActionSheet:0];
}

- (void)uploadImage:(UIImage *)originImage filePath:(NSString *)filePath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 显示
    if (headTag == 1) {
        self.frontImageV.image = originImage;
    }else if (headTag == 2){
        self.backImageV.image = originImage;
    }
    
    // 保存图片到数组
    NSData *imageData = UIImagePNGRepresentation(originImage);
    [self changePersonInfo_headImg:imageData];
}
// 修改头像
- (void)changePersonInfo_headImg:(NSData *)headImg
{
    [self.slideView show:YES];
    [[RequestManager sharedRequestManager] uploadImage_uid:[UserEntity getUid] imageArr:@[headImg] progressBlock:^(CGFloat f) {
        self.slideView.progress = f;
    } success:^(id resultDic) {
        [self.slideView hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSDictionary *dict = resultDic[DATA];
            if (headTag == 1) {
                self.frontUrl = [dict objectForKey:@"file"];
            }else if (headTag == 2) {
                self.backUrl = [dict objectForKey:@"file"];
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark - 事件

- (void)rightClick:(UIButton *)sender
{
    NSString *cardStr = self.cardNumTxt.text;
    
    NSString *msg = @"";
    if (self.frontUrl.length == 0) {
        msg = @"请选择身份证正面照片";
    }else if (self.frontUrl.length == 0) {
        msg = @"请选择身份证反面照片";
    }else if (cardStr.length == 0) {
        msg = @"请填写身份证号";
    }else{
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] companyAuthBaseInfo_uid:[UserEntity getUid] id_card_num:cardStr id_card_top:self.frontUrl id_card_bottom:self.backUrl success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                self.entity.companyEn.id_card_num = cardStr;
                self.entity.companyEn.id_card_bottom = self.backUrl;
                self.entity.companyEn.id_card_top = self.frontUrl;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlreadyPerfect" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
    if (msg.length >0) {
        [YQToast yq_ToastText:msg bottomOffset:100];
    }
}


- (void)scrollerClick
{
    [self hideKeyboard];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.cardNumTxt resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
