//
//  CompanyLicenseController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/28.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyLicenseController.h"

#import "EZCPersonCenterEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CompanyLicenseController ()

@property (nonatomic, strong) UIImageView *companyImageV;

@property (nonatomic, strong) NSString *logoUrl;// 公司宣传图地址

@property (nonatomic, strong) UITextField *linkTxt;// 官网链接

@property (nonatomic, strong) UIScrollView *scroller;

@end

@implementation CompanyLicenseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"营业执照";
    
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
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 35)];
    titlelabel.text = @"营业执照";
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:titlelabel];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom+8, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_bottom-15-45)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.backgroundColor = RGB(243, 243, 243);
    imageV.userInteractionEnabled = YES;
    [contentView addSubview:imageV];
    self.companyImageV = imageV;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick:)];
    [imageV addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, imageV.yq_bottom+5, 135, 35)];
    label.text = @"统一社会信用代码";
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.yq_right, label.yq_y, contentView.yq_width-label.yq_right-15, 35)];
    tf.text = @"";
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:tf];
    self.linkTxt = tf;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(tf.yq_x-5, tf.yq_bottom+0, tf.yq_width+5, 1)];
    lineView.backgroundColor = THEMECOLOR;
    [contentView addSubview:lineView];
    
    CGFloat y = contentView.yq_bottom;
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
        label.text = @"请上传公司经营有效的营业执照和统一社会信用代码";
        label.numberOfLines = 0;
        label.textColor = RGB(102, 102, 102);
        label.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:label];
    }
    
    EZCompanyInfoEntity *en = self.entity.companyEn;
    if (![en.license_num isEqualToString:@""]) {
        self.linkTxt.text = en.license_num;
    }
    if (![en.license isEqualToString:@""]) {
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,en.license]]];
        self.logoUrl = en.license;
    }
}

#pragma mark - 选择头像
//点击头像选择图库还是拍照
- (void)headTapClick:(UIGestureRecognizer *)sender
{
    self.isClip = NO;//表示不需要裁剪
    [self openActionSheet:0];
}

- (void)uploadImage:(UIImage *)originImage filePath:(NSString *)filePath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 显示
    self.companyImageV.image = originImage;
    
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
            self.logoUrl = [dict objectForKey:@"file"];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark - 事件

- (void)rightClick:(UIButton *)sender
{
    NSString *linkStr = self.linkTxt.text;
    
    NSString *msg = @"";
    if (self.logoUrl.length == 0) {
        msg = @"请选择公司执照";
    }else if (linkStr.length == 0) {
        msg = @"请填写执照编码";
    }else{
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] companyAuthBaseInfo_uid:[UserEntity getUid] license:self.logoUrl license_num:linkStr success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                self.entity.companyEn.license_num = linkStr;
                self.entity.companyEn.license = self.logoUrl;
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
    [self.linkTxt resignFirstResponder];
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
