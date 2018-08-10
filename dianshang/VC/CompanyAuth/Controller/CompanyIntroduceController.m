//
//  CompanyIntroduceController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/28.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define zishu 2000


#import "CompanyIntroduceController.h"

#import "EZCPersonCenterEntity.h"
#import "CompanyBaseInfoController.h"
#import "UITextView+ZWPlaceHolder.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CompanyIntroduceController ()<UITextViewDelegate>
{
    NSInteger contentViewY;
}
@property (nonatomic, strong) UIScrollView *scroller;

@property (nonatomic, strong) UITextView *companyTxt;
@property (nonatomic, strong) UITextView *teamTxt;
@property (nonatomic, strong) UITextView *productTxt;
@property (nonatomic, strong) UILabel    *companyLbl;
@property (nonatomic, strong) UILabel    *teamLbl;
@property (nonatomic, strong) UILabel    *productLbl;

@property (nonatomic, strong) UIImageView *companyImageV;

@property (nonatomic, strong) NSString    *logoUrl;// 公司宣传图地址

@property (nonatomic, strong) UITextField *linkTxt;// 官网链接

@end

@implementation CompanyIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公司介绍";
    
    [self initView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"保存" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    
    
}

- (void)initView
{
    CGFloat w = APP_WIDTH;
    CGFloat h = 250;
    NSArray *array = @[@"公司介绍",@"团队介绍",@"公司产品介绍"];
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, APP_HEIGHT-APP_NAVH)];
    [scroller setContentSize:CGSizeMake(w, (array.count+1)*h+50)];
    [scroller addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerClick)]];
    [self.view addSubview:scroller];
    self.scroller = scroller;
    
    NSLog(@"%@",self.typeStr);
    if ([self.typeStr isEqualToString:@"1"]) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, w, 50)];
        headView.backgroundColor = [UIColor whiteColor];
        [scroller addSubview:headView];
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, w - 100, 30)];
        headLabel.text = @"公司基本信息";
        headLabel.textColor = RGB(51, 51, 51);
        headLabel.font = [UIFont systemFontOfSize:14];
        [headView addSubview:headLabel];
        
        UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectMake(w - 30, 15, 20, 20)];
        [headButton setImage:[UIImage imageNamed:@"back_right"] forState:UIControlStateNormal];
        [headButton addTarget:self action:@selector(headButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:headButton];
        
        UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, w, 50)];
        headBtn.backgroundColor = [UIColor clearColor];
        [headBtn addTarget:self action:@selector(headButtonSelector:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:headBtn];
        
        
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, w, h)];
        contentView.backgroundColor = [UIColor whiteColor];
        [scroller addSubview:contentView];
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 35)];
        titlelabel.text = @"公司宣传照片";
        titlelabel.textColor = RGB(51, 51, 51);
        titlelabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:titlelabel];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom+8, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_bottom-15-45)];
        imageV.backgroundColor = RGB(243, 243, 243);
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.userInteractionEnabled = YES;
        [contentView addSubview:imageV];
        self.companyImageV = imageV;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick:)];
        [imageV addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, imageV.yq_bottom+5, 120, 35)];
        label.text = @"官网链接 http://";
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:label];
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.yq_right, label.yq_y, contentView.yq_width-label.yq_right-15, 35)];
        tf.text = @"";
        tf.placeholder = @"选填";
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:tf];
        self.linkTxt = tf;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(tf.yq_x-60, tf.yq_bottom+0, tf.yq_width+60, 1)];
        lineView.backgroundColor = THEMECOLOR;
        [contentView addSubview:lineView];
        
        CGFloat y = contentView.yq_bottom;
        CGFloat x = 0;
        CGFloat jianju = 8;
        
        for (int i = 0; i < array.count; i++) {
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(x, y+jianju*(i+1)+h*i, w, h)];
            contentView.backgroundColor = [UIColor whiteColor];
            [scroller addSubview:contentView];
            //self.contentView = contentView;
            UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 35)];
            titlelabel.text = array[i];
            titlelabel.textColor = RGB(51, 51, 51);
            titlelabel.font = [UIFont systemFontOfSize:14];
            [contentView addSubview:titlelabel];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom+8, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_bottom-25)];
            textView.tag = i+1;
            textView.delegate = self;
            textView.backgroundColor = RGB(243, 243, 243);
            textView.font = [UIFont systemFontOfSize:16];
            textView.layer.cornerRadius = 5;
            [contentView addSubview:textView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textView.yq_width-102, contentView.yq_height-20, 100, 20)];
            label.text = [NSString stringWithFormat:@"0/%d",zishu];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = RGB(102, 102, 102);
            label.font = [UIFont systemFontOfSize:12];
            [contentView addSubview:label];
            if (i == 0) {
                self.companyTxt = textView;
                self.companyLbl = label;
            }else if (i == 1) {
                self.teamTxt = textView;
                self.teamLbl = label;
            }else if (i == 2) {
                self.productTxt = textView;
                self.productLbl = label;
            }
        }
        EZCompanyInfoEntity *en = self.entity.companyEn;
        if (![en.link isEqualToString:@""]) {
            self.linkTxt.text = en.link;
        }
        if (![en.companyinfo isEqualToString:@""]) {
            self.companyTxt.text = en.companyinfo;
            self.companyLbl.text = [NSString stringWithFormat:@"%li/%d",en.companyinfo.length,zishu];
        }
        if (![en.productinfo isEqualToString:@""]) {
            self.productTxt.text = en.productinfo;
            self.productLbl.text = [NSString stringWithFormat:@"%li/%d",en.productinfo.length,zishu];
        }
        if (![en.teaminfo isEqualToString:@""]) {
            self.teamTxt.text = en.teaminfo;
            self.teamLbl.text = [NSString stringWithFormat:@"%li/%d",en.teaminfo.length,zishu];
        }
        if (![en.img isEqualToString:@""]) {
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,en.img]]];
            self.logoUrl = en.img;
        }
        
    } else {
       
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, w, h)];
        contentView.backgroundColor = [UIColor whiteColor];
        [scroller addSubview:contentView];
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 35)];
        titlelabel.text = @"公司宣传照片";
        titlelabel.textColor = RGB(51, 51, 51);
        titlelabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:titlelabel];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom+8, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_bottom-15-45)];
        imageV.backgroundColor = RGB(243, 243, 243);
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.userInteractionEnabled = YES;
        [contentView addSubview:imageV];
        self.companyImageV = imageV;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick:)];
        [imageV addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, imageV.yq_bottom+5, 120, 35)];
        label.text = @"官网链接 http://";
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:label];
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.yq_right, label.yq_y, contentView.yq_width-label.yq_right-15, 35)];
        tf.text = @"";
        tf.placeholder = @"选填";
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:tf];
        self.linkTxt = tf;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(tf.yq_x-60, tf.yq_bottom+0, tf.yq_width+60, 1)];
        lineView.backgroundColor = THEMECOLOR;
        [contentView addSubview:lineView];
        
        CGFloat y = contentView.yq_bottom;
        CGFloat x = 0;
        CGFloat jianju = 8;
        
        for (int i = 0; i < array.count; i++) {
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(x, y+jianju*(i+1)+h*i, w, h)];
            contentView.backgroundColor = [UIColor whiteColor];
            [scroller addSubview:contentView];
            //self.contentView = contentView;
            UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 35)];
            titlelabel.text = array[i];
            titlelabel.textColor = RGB(51, 51, 51);
            titlelabel.font = [UIFont systemFontOfSize:14];
            [contentView addSubview:titlelabel];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom+8, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_bottom-25)];
            textView.tag = i+1;
            textView.delegate = self;
            textView.backgroundColor = RGB(243, 243, 243);
            textView.font = [UIFont systemFontOfSize:16];
            textView.layer.cornerRadius = 5;
            [contentView addSubview:textView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textView.yq_width-102, contentView.yq_height-20, 100, 20)];
            label.text = [NSString stringWithFormat:@"0/%d",zishu];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = RGB(102, 102, 102);
            label.font = [UIFont systemFontOfSize:12];
            [contentView addSubview:label];
            if (i == 0) {
                self.companyTxt = textView;
                self.companyLbl = label;
            }else if (i == 1) {
                self.teamTxt = textView;
                self.teamLbl = label;
            }else if (i == 2) {
                self.productTxt = textView;
                self.productLbl = label;
            }
        }
        EZCompanyInfoEntity *en = self.entity.companyEn;
        if (![en.link isEqualToString:@""]) {
            self.linkTxt.text = en.link;
        }
        if (![en.companyinfo isEqualToString:@""]) {
            self.companyTxt.text = en.companyinfo;
            self.companyLbl.text = [NSString stringWithFormat:@"%li/%d",en.companyinfo.length,zishu];
        }
        if (![en.productinfo isEqualToString:@""]) {
            self.productTxt.text = en.productinfo;
            self.productLbl.text = [NSString stringWithFormat:@"%li/%d",en.productinfo.length,zishu];
        }
        if (![en.teaminfo isEqualToString:@""]) {
            self.teamTxt.text = en.teaminfo;
            self.teamLbl.text = [NSString stringWithFormat:@"%li/%d",en.teaminfo.length,zishu];
        }
        if (![en.img isEqualToString:@""]) {
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,en.img]]];
            self.logoUrl = en.img;
        }
        
    }

}

//公司基本信息点击事件
- (void)headButtonSelector : (UIButton *)sender {
    NSLog(@"点击公司基本信息");
    CompanyBaseInfoController *CompanyBaseInfoVC = [[CompanyBaseInfoController alloc] init];
    CompanyBaseInfoVC.entity = self.entity;
    CompanyBaseInfoVC.typeStr = @"1";
    [self.navigationController pushViewController:CompanyBaseInfoVC animated:YES];
    
}




#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    contentViewY = [textView superview].yq_y;
    
    [self.scroller setContentOffset:CGPointMake(0, contentViewY) animated:YES];
    
//    [UIView animateWithDuration:.3f animations:^{
//        [textView superview].yq_y = 0;
//    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    [UIView animateWithDuration:.3f animations:^{
//        [textView superview].yq_y = contentViewY;
//    }];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>zishu) {
        NSMutableString *a = [NSMutableString stringWithString:textView.text];
        textView.text = [a substringToIndex:zishu];
    }
    if (textView.tag == 1) {
        self.companyLbl.text = [NSString stringWithFormat:@"%d/%d",(int)textView.text.length,zishu];
    }else if (textView.tag == 2) {
        self.teamLbl.text = [NSString stringWithFormat:@"%d/%d",(int)textView.text.length,zishu];
    }else if (textView.tag == 3) {
        self.productLbl.text = [NSString stringWithFormat:@"%d/%d",(int)textView.text.length,zishu];
    }
}

#pragma mark - 选择头像
//点击头像选择图库还是拍照
- (void)headTapClick:(UIGestureRecognizer *)sender
{
    [self hideKeyboard];
    self.isClip = YES;//表示需要裁剪
    [self openActionSheet:YQClipTypeRectangle];
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
    
    if ([self.typeStr isEqualToString:@"1"]) {
        
        NSLog(@"1     %@",self.entity.companyEn.cname);
        NSLog(@"2     %@",self.entity.companyEn.scale);
        NSLog(@"3     %@",self.entity.companyEn.cvedit);
        NSLog(@"4     %@",self.entity.companyEn.lng);
        NSLog(@"5     %@",self.entity.companyEn.lat);
        NSLog(@"6     %@",self.entity.companyEn.province);
        NSLog(@"7     %@",self.entity.companyEn.city);
        NSLog(@"8     %@",self.entity.companyEn.area);
        NSLog(@"9     %@",self.entity.companyEn.address);
        NSLog(@"10    %@",self.entity.companyEn.tradeid);
        NSLog(@"11    %@",self.entity.companyEn.ctag);
        NSLog(@"12    %@",self.entity.companyEn.logo);
        NSLog(@"13    %@",self.entity.companyEn.tradeid);//行业id
        NSLog(@"14    %@",self.entity.companyEn.license);//营业执照
        NSLog(@"15    %@",self.entity.companyEn.id_card_num);//身份证号码
        NSLog(@"16    %@",self.entity.companyEn.id_card_top);//身份证正面照
        NSLog(@"17    %@",self.entity.companyEn.id_card_bottom);//身份证发面照
        NSLog(@"18    %@",self.entity.companyEn.province);
        NSLog(@"19    %@",self.entity.companyEn.city);
        NSLog(@"20    %@",self.entity.companyEn.area);
        NSLog(@"21    %@",self.entity.companyEn.address);
        
        NSString *linkStr = self.linkTxt.text;
        NSString *companyStr = self.companyTxt.text;
        NSString *teamStr = self.teamTxt.text;
        NSString *productStr = self.productTxt.text;
        
        NSString *msg = @"";
        if (self.logoUrl.length == 0) {
            msg = @"请选择公司照片";
        }
        //    else if (linkStr.length == 0) {
        //        msg = @"请填写官网地址";
        //    }
        else if (companyStr.length == 0) {
            msg = @"请填写公司介绍";
        }else if (teamStr.length == 0) {
            msg = @"请填写公司团队介绍";
        }else if (productStr.length == 0) {
            msg = @"请填写公司产品介绍";
        } else {
            [self.hud show:YES];
            [[RequestManager sharedRequestManager] seteditorapprove_uid:[UserEntity getUid] cname:self.entity.companyEn.cname tradeid:self.entity.companyEn.tradeid license:self.entity.companyEn.license id_card_num:self.entity.companyEn.id_card_num id_card_top:self.entity.companyEn.id_card_top id_card_bottom:self.entity.companyEn.id_card_bottom license_num:self.entity.companyEn.license_num province:self.entity.companyEn.province city:self.entity.companyEn.city area:self.entity.companyEn.area address:self.entity.companyEn.address lng:self.entity.companyEn.lng lat:self.entity.companyEn.lat logo:self.entity.companyEn.logo ctag:self.entity.companyEn.ctag scale:self.entity.companyEn.scale companyinfo:companyStr productinfo:productStr link:linkStr cvedit:self.entity.companyEn.cvedit img:self.entity.companyEn.img team:teamStr success:^(id resultDic) {
                [self.hud hide:YES];
                NSLog(@"%@",resultDic);
                if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                    [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                    self.entity.companyEn.companyinfo = companyStr;
                    self.entity.companyEn.productinfo = productStr;
                    self.entity.companyEn.teaminfo = teamStr;
                    self.entity.companyEn.link = linkStr;
                    self.entity.companyEn.img = self.logoUrl;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlreadyPerfect" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(NSError *error) {
                [self.hud hide:YES];
                NSLog(@"网络连接错误");
            }];
        }
        
      } else {
        NSString *linkStr = self.linkTxt.text;
        NSString *companyStr = self.companyTxt.text;
        NSString *teamStr = self.teamTxt.text;
        NSString *productStr = self.productTxt.text;
        
        NSString *msg = @"";
        if (self.logoUrl.length == 0) {
            msg = @"请选择公司照片";
        }
        //    else if (linkStr.length == 0) {
        //        msg = @"请填写官网地址";
        //    }
        else if (companyStr.length == 0) {
            msg = @"请填写公司介绍";
        }else if (teamStr.length == 0) {
            msg = @"请填写公司团队介绍";
        }else if (productStr.length == 0) {
            msg = @"请填写公司产品介绍";
        }else{
            [self.hud show:YES];
            [[RequestManager sharedRequestManager] companyAuthBaseInfo_uid:[UserEntity getUid] img:self.logoUrl link:linkStr companyinfo:companyStr team:teamStr productinfo:productStr success:^(id resultDic) {
                [self.hud hide:YES];
                if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                    [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                    self.entity.companyEn.companyinfo = companyStr;
                    self.entity.companyEn.productinfo = productStr;
                    self.entity.companyEn.teaminfo = teamStr;
                    self.entity.companyEn.link = linkStr;
                    self.entity.companyEn.img = self.logoUrl;
                    
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
    [self.companyTxt resignFirstResponder];
    [self.teamTxt resignFirstResponder];
    [self.productTxt resignFirstResponder];
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
