//
//  PersonalAuthController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/26.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "PersonalAuthController.h"
#import "BXTextField.h"
#import "UITextField+YQTextField.h"
#import "ServiceAgreementVC.h"

@interface PersonalAuthController ()<UITextFieldDelegate>
{
    UIScrollView *scroller;
    
    int imageTag;
    
    UIButton    *saveBtn;//提交按钮
    
    UITextField *nameTxt;
    UITextField *phoneTxt;
    UITextField *cardTxt;// 身份证号
    //声明是否完成填写每一项的标识
    BOOL isHeadImgFlag;//是否选择头像
    BOOL isCard1Flag;//是否选择身份证正面
    BOOL isCard2Flag;//是否选择身份证反面
    
    BOOL isProtocol;//是否同意协议
    
    //BOOL isEdit;//是否编辑在退出的时候判断
    //UIAlertView *backAlert;//退出时判断
}

@property (nonatomic, strong) NSMutableArray *uploadImageArray;

@end

@implementation PersonalAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";
    
    self.uploadImageArray = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    
    //[UserEntity setPersonAuth:@"2"];
    NSString *authStr = [UserEntity getRealAuth];   // 1、认证；2、未认证；3、审核中
    if ([authStr isEqualToString:@"2"]) {
        [self initView];
    }else if ([authStr isEqualToString:@"3"]) {
        [self ExamineView];
    }else if ([authStr isEqualToString:@"1"]){
        [self AuditCompletionView];
    }
    
}

- (void)initView
{
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH-APP_BottomH)];
    scroller.backgroundColor = RGB(239, 239, 239);
    scroller.delegate = self;
//    scroller.layer.masksToBounds = YES;
    [self.view addSubview:scroller];
    
    UIView *headView = [self selHeadImgView];
    
    UIView *detailView0 = [self storeDetailView:headView];
    
    UIView *detailView2 = [self storePhotoView:detailView0.yq_bottom+8 title:@"  身份证正面照片" image:@"card2" subTitle:@"个人身份证正面照片,要求字迹清晰可辨" tagIndex:2];
    UIView *detailView3 = [self storePhotoView:detailView2.yq_bottom+8 title:@"  身份证反面照片" image:@"card2" subTitle:@"个人身份证反面照片,要求字迹清晰可辨" tagIndex:3];
    
    
    UIView *buttonView = [self buttonView:detailView3];
    
    [scroller setContentSize:CGSizeMake(APP_WIDTH, buttonView.yq_bottom+20)];
    
}

- (UIView *)buttonView:(UIView *)storePhotoView
{
    CGFloat w = scroller.yq_width;
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, 95)];
    buttonView.backgroundColor = [UIColor clearColor];
    [scroller addSubview:buttonView];
    
    UIButton *protocolBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 60, 35)];
    [protocolBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [protocolBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 5, 8, 35)];
    [protocolBtn setTitle:@"同意" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:protocolBtn];
    
    UILabel *protocolLbl = [[UILabel alloc] initWithFrame:CGRectMake(protocolBtn.yq_right, protocolBtn.yq_y, 250, protocolBtn.yq_height)];
    protocolLbl.text = @"《E招用户注册服务协议及隐私条款》";
    protocolLbl.textColor = THEMECOLOR;
    protocolLbl.font = [UIFont systemFontOfSize:14];
    [buttonView addSubview:protocolLbl];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolLbl:)];
    protocolLbl.userInteractionEnabled = YES;
    [protocolLbl addGestureRecognizer:tap];
    
    isProtocol = YES;
    saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, protocolBtn.yq_bottom+15, APP_WIDTH - 60, 45)];
    [saveBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    saveBtn.layer.cornerRadius = 4;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setBackgroundColor:blueBtnNormal forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:saveBtn];
    
    return buttonView;
}

- (UIView *)storePhotoView:(CGFloat)frameY title:(NSString *)title image:(NSString *)image subTitle:(NSString *)subTitle tagIndex:(NSInteger)tag;
{
    CGFloat w = scroller.yq_width;
    UIView *storePhotoView = [[UIView alloc] initWithFrame:CGRectMake(0, frameY, w, 200)];
    storePhotoView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:storePhotoView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 30)];
    label.text = title;
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:14];
    [storePhotoView addSubview:label];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, label.yq_bottom, w, 150)];
    headImg.tag = tag;
    headImg.image = [UIImage imageNamed:image];
    headImg.contentMode = UIViewContentModeScaleAspectFit;
    [storePhotoView addSubview:headImg];
    UITapGestureRecognizer *headImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick:)];
    headImg.userInteractionEnabled = YES;
    [headImg addGestureRecognizer:headImgTap];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, headImg.yq_bottom, w, 20)];
    label1.text = subTitle;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB(102, 102, 102);
    label1.font = [UIFont systemFontOfSize:13];
    [storePhotoView addSubview:label1];
    
    return storePhotoView;
}

- (UIView *)storeDetailView:(UIView *)storePhotoView
{
    NSArray *arr = @[@"真实姓名",@"身份证号"];
    
    CGFloat w = scroller.yq_width;
    CGFloat h = 45;
    UIView *storeDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, h*arr.count)];
    storeDetailView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:storeDetailView];
    
    for (int i = 0; i < arr.count; i++) {
        
        CGFloat y = h * i;
        
        UITextField *textfield = [[UITextField alloc] init];
        textfield.frame = CGRectMake(0, y, w, h);
        textfield.textColor = RGB(51, 51, 51);
        textfield.font = [UIFont systemFontOfSize:14];
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.delegate = self;
        textfield.adjustsFontSizeToFitWidth = YES;
        
        
        if (i == 0) {
            nameTxt = textfield;
            [storeDetailView addSubview:textfield];
            textfield.placeholder = [NSString stringWithFormat:@"请输入%@",arr[i]];
            [textfield yq_setTitle:[arr[i] stringByAppendingString:@":"] titleColor:RGB(51, 51, 51)];
        }else if (i == 1) {
            BXTextField *textfield = [[BXTextField alloc] init];
            textfield.frame = CGRectMake(0, y, w, h);
            textfield.textColor = RGB(51, 51, 51);
            textfield.font = [UIFont systemFontOfSize:14];
            textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
            textfield.delegate = self;
            textfield.adjustsFontSizeToFitWidth = YES;
            [storeDetailView addSubview:textfield];
            cardTxt = textfield;
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            textfield.placeholder = [NSString stringWithFormat:@"请输入%@",arr[i]];
            [textfield yq_setTitle:[arr[i] stringByAppendingString:@":"] titleColor:RGB(51, 51, 51)];
        }
        
        if (i != arr.count-1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, y+h-1, APP_WIDTH-20, 0.5)];
            lineView.backgroundColor = RGB(239, 239, 239);
            [storeDetailView addSubview:lineView];
        }
        
    }
    
    return storeDetailView;
}

- (UIView *)selHeadImgView
{
    CGFloat w = scroller.yq_width;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, w, 95)];
    headView.backgroundColor = [UIColor clearColor];
    [scroller addSubview:headView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headView.yq_width, headView.yq_height)];
    label.text = @"   请上传真实头像";
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = RGB(51, 51, 51);
    [headView addSubview:label];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(headView.yq_width- label.yq_height-10-20, 5, label.yq_height-10, label.yq_height-10)];
    headImg.layer.cornerRadius = headImg.yq_height/2;
    headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    headImg.layer.borderWidth = 2;
    headImg.layer.masksToBounds = YES;
    headImg.tag = 1;
    headImg.image = [UIImage imageNamed:@"headImg"];
    [headView addSubview:headImg];
    UITapGestureRecognizer *headImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick:)];
    headImg.userInteractionEnabled = YES;
    [headImg addGestureRecognizer:headImgTap];
    
    return headView;
}

#pragma mark ========滑动隐藏键盘========

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyboard];
    
}

#pragma mark ========按钮事件========

- (void)protocolLbl:(UIGestureRecognizer *)sender
{
    ServiceAgreementVC *vc = [[ServiceAgreementVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)protocolBtnClick:(UIButton *)sender
{
    if (isProtocol) {
        isProtocol = NO;
        [sender setImage:[UIImage imageNamed:@"select_un"] forState:UIControlStateNormal];
        saveBtn.enabled = NO;
        [saveBtn setBackgroundColor:[UIColor colorWithWhite:0.624 alpha:1.000] forState:UIControlStateNormal];
    }else{
        isProtocol = YES;
        [sender setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        saveBtn.enabled = YES;
        [saveBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    }
    
}


- (void)buttonClick:(UIGestureRecognizer *)sender
{
    [self hideKeyboard];
    imageTag = (int)sender.view.tag;
    if (sender.view.tag == 1) {
        self.isClip = YES;
    }else{
        self.isClip = NO;
    }
#pragma mark ========这里是快递员认证头像需要裁剪成正方形========
    [self openActionSheet:YQClipTypeSquare];
}

- (void)uploadImage:(UIImage *)originImage filePath:(NSString *)aa
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (imageTag == 1) {
        isHeadImgFlag = YES;
    }
    if (imageTag == 2) {
        isCard1Flag = YES;
    }
    if (imageTag == 3) {
        isCard2Flag = YES;
    }
    
    //[self saveImage:originImage WithName:[NSString stringWithFormat:@"%dheadimg.png",imageTag]];
    
#pragma mark ========显示========
    UIImageView *img = [scroller viewWithTag:imageTag];
    img.image = originImage;
    
#pragma mark ========保存图片到数组========
    NSData *imageData = UIImagePNGRepresentation(originImage);
    [self uploadImage:imageData];
}
- (void)uploadImage:(NSData *)headImg
{
    [self.slideView show:YES];
    [[RequestManager sharedRequestManager] uploadImage_uid:[UserEntity getUid] imageArr:@[headImg] progressBlock:^(CGFloat f) {
        self.slideView.progress = f;
    } success:^(id resultDic) {
        [self.slideView hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSDictionary *dict = resultDic[DATA];
            [self.uploadImageArray replaceObjectAtIndex:imageTag-1 withObject:[dict objectForKey:@"file"]];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark ========隐藏键盘========
- (void)hideKeyboard
{
    [nameTxt resignFirstResponder];
    [phoneTxt resignFirstResponder];
    [cardTxt resignFirstResponder];
}

- (void)saveBtnClick:(UIButton *)sender
{
    if ([nameTxt.text isEqualToString:@""]) {
        [YQToast yq_ToastText:@"请输入姓名" bottomOffset:100];
    }else if ([cardTxt.text isEqualToString:@""]) {
        [YQToast yq_ToastText:@"请输入身份证号" bottomOffset:100];
    }else if (!isHeadImgFlag) {
        [YQToast yq_ToastText:@"请选择头像" bottomOffset:100];
    }else{
        if (!isCard1Flag) {
            [YQToast yq_ToastText:@"请选择身份证正面照片" bottomOffset:100];
        }else if (!isCard2Flag) {
            [YQToast yq_ToastText:@"请选择身份证反面照片" bottomOffset:100];
        }else{
            // 上传认证资料
            [self uploadAuthData];
        }
    }
    // 上传认证资料
    //    [self uploadAuthData];
}

- (void)uploadAuthData
{
    NSString *photo = self.uploadImageArray[0];
    NSString *idcardFace = self.uploadImageArray[1];
    NSString *idcardBack = self.uploadImageArray[2];
    
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] personalAuth_uid:[UserEntity getUid] truename:nameTxt.text number:cardTxt.text number_top:idcardFace number_bottom:idcardBack trueavatar:photo success:^(id resultDic) {
        
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [UserEntity setRealAuth:@"3"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ========正在审核========
- (void)ExamineView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-64)];
    bgView.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:bgView];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, APP_WIDTH, APP_HEIGHT/4)];
    bgImage.image = [UIImage imageNamed:@"bgImage"];
    bgImage.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:bgImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, bgImage.yq_bottom+10, APP_WIDTH, 50)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您的资料正在审核中,请耐心等待";
    [bgView addSubview:label];
    
}

#pragma mark ========审核成功========
- (void)AuditCompletionView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-64)];
    bgView.backgroundColor = RGB(239, 239, 239);
    [self.view addSubview:bgView];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, APP_WIDTH, APP_HEIGHT/4)];
    bgImage.image = [UIImage imageNamed:@"bgImage"];
    bgImage.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:bgImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, bgImage.yq_bottom+10, APP_WIDTH, 50)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"恭喜您!您的资料审核已通过!";
    [bgView addSubview:label];
    
    //保证金状态为 0 或 3 的时候标识还没有缴纳
    //    if ([[UserEntity is_deposit] isEqualToString:@"3"]||[[UserEntity is_deposit] isEqualToString:@"0"]) {
    //        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.yq_bottom+10, APP_WIDTH, 50)];
    //        label1.font = [UIFont systemFontOfSize:14];
    //        label1.textAlignment = NSTextAlignmentCenter;
    //        label1.text = @"您还未缴纳保证金,目前还不具备集中代派权!";
    //        [self.view addSubview:label1];
    //
    //        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, label1.yq_bottom+30, APP_WIDTH-60, 42)];
    //        loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //        [loginBtn setTitle:@"现在去缴纳" forState:UIControlStateNormal];
    //        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [loginBtn setBackgroundColor:BTNBACKGROUND forState:UIControlStateHighlighted];
    //        [loginBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    //        [loginBtn.layer setMasksToBounds:YES];
    //        loginBtn.layer.cornerRadius = 4;
    //        [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //        [self.view addSubview:loginBtn];
    //    }
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
