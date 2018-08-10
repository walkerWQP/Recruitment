//
//  RegisterViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

static int secondsCountDown = SecondsCountDown;//初始化秒数


#import "ForgetViewController.h"

#import "NSString+RegularExpression.h"

//#import <SMS_SDK/SMSSDK.h>

@interface ForgetViewController ()<UITextFieldDelegate>
{
    NSTimer *countDownTimer;
    
    UIView *registView;
}

@property (strong, nonatomic) UITextField *RphoneTxt;
@property (strong, nonatomic) UITextField *RvCodeTxt;
@property (strong, nonatomic) UITextField *RpassTxt;

@property (strong, nonatomic) UIButton *codeBtn;

@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIScrollView *scroller;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"忘记密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self registView];
}

- (void)registView
{
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    int h = IS_IPhone4 ? 568 : APP_HEIGHT;
    self.scroller.contentSize = CGSizeMake(APP_WIDTH, h);
    [self.view addSubview:self.scroller];
    [self scrollerPress];
    
    UIView *txtView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, APP_WIDTH, 400)];
    txtView.layer.cornerRadius = 4;
    //txtView.backgroundColor = [UIColor redColor];
    //txtView.backgroundColor = [UIColor clearColor];
    [self.scroller addSubview:txtView];
    registView = txtView;
    
    self.RphoneTxt = [self setTextField:CGRectMake(30, 0, txtView.yq_width-60, 40) leftImage:@"login_shouji" placeholder:@"请输入手机号"];
    [txtView addSubview:self.RphoneTxt];
    
    self.RvCodeTxt = [self setTextField:CGRectMake(30, self.RphoneTxt.yq_bottom+10, txtView.yq_width-60, 40) leftImage:@"login_yzm" placeholder:@"请输入验证码"];
    self.RvCodeTxt.keyboardType = UIKeyboardTypeNumberPad;
    [txtView addSubview:self.RvCodeTxt];
    
    UIButton *vCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.RvCodeTxt.yq_width-85, 0, 80, 40)];
    vCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [vCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [vCodeBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [vCodeBtn addTarget:self action:@selector(vcodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.RvCodeTxt addSubview:vCodeBtn];
    self.codeBtn = vCodeBtn;
    
    self.RpassTxt = [self setTextField:CGRectMake(30, self.RvCodeTxt.yq_bottom+10, txtView.yq_width-60, 40) leftImage:@"login_mima" placeholder:@"请输入密码"];
    self.RpassTxt.secureTextEntry = YES;
    [txtView addSubview:self.RpassTxt];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, self.RpassTxt.yq_bottom+30, APP_WIDTH-60, 42)];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.loginBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:BTNBACKGROUND forState:UIControlStateHighlighted];
    [self.loginBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [self.loginBtn.layer setMasksToBounds:YES];
    self.loginBtn.layer.cornerRadius = _loginBtn.yq_height*0.5;
    [self.loginBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [txtView addSubview:self.loginBtn];
    
}

- (UITextField *)setTextField:(CGRect)frame leftImage:(NSString *)imageStr placeholder:(NSString *)placeholder
{
    CGFloat h = frame.size.height;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    imgView1.image = [UIImage imageNamed:imageStr];
    textField.leftView = imgView1;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyGo;
    textField.font = [UIFont systemFontOfSize:14];
    textField.leftViewMode = UITextFieldViewModeAlways;
    //textField.secureTextEntry = YES;
    textField.layer.cornerRadius = h * 0.5;
    textField.layer.borderColor = RGB(180, 180, 180).CGColor;
    textField.layer.borderWidth = 1;
    
    return textField;
}

/*!
 *  @author 15-06-09 09:06:27
 *
 *  @brief  给 scroller 添加单击手势
 */
- (void)scrollerPress
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.scroller addGestureRecognizer:tap];
}
//单击手势执行方法
- (void)tapClick
{
    [self.RvCodeTxt resignFirstResponder];
    [self.RphoneTxt resignFirstResponder];
    [self.RpassTxt resignFirstResponder];
    //[self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)registBtnClick:(UIButton *)sender
{
    
    if ([self.RphoneTxt.text isEqualToString:@""] || [self.RpassTxt.text isEqualToString:@""]) {
        [YQToast yq_ToastText:@"请输入账户名或密码" bottomOffset:100];
    }
    else if ([self.RvCodeTxt.text isEqualToString:@""])
    {
        [YQToast yq_ToastText:@"请输入验证码" bottomOffset:100];
    }
    else{
//        [SMSSDK commitVerificationCode:self.RvCodeTxt.text phoneNumber:self.RphoneTxt.text zone:@"86" result:^(NSError *error) {
//            if (error == nil) {
//                [[RequestManager sharedRequestManager] forget_phone:self.RphoneTxt.text password:self.RpassTxt.text success:^(id resultDic) {
//                    if ([resultDic[STATUS] isEqualToString:SUCCESS]) {
//                        [YQToast yq_ToastText:@"修改成功,请重新登录" bottomOffset:100];
//                        [self.navigationController popViewControllerAnimated:YES];
//                        //self.LnameTxt.text = self.RphoneTxt.text;
//                        self.RphoneTxt.text = @"";
//                        self.RpassTxt.text = @"";
//                        self.RvCodeTxt.text = @"";
//                    }else{
//                        [YQToast yq_ToastText:resultDic[MSG] bottomOffset:100];
//                    }
//                } failure:nil];
//            }else{
//                NSLog(@"SMSSDK错误信息:%@",error);
//                [YQToast yq_ToastText:@"提交验证码错误!" bottomOffset:100];
//            }
//        }];
        
        
    }
}
- (void)vcodeBtnClick:(UIButton *)sender
{
    NSString *phone = self.RphoneTxt.text;
    if ([phone isEqualToString:@""]) {
        [YQToast yq_ToastText:@"请输入手机号码" bottomOffset:100];
    }else if (![phone checkPhoneNum]) {
        [YQToast yq_ToastText:@"手机号码不正确" bottomOffset:100];
    }else{
        if ([self.codeBtn.currentTitle isEqualToString:@"获取验证码"]) {
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒",--secondsCountDown] forState:UIControlStateNormal];
//            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" result:^(NSError *error) {
//                if (error.code == -1009) {
//                    [YQToast yq_ToastText:@"已断开与互联网的连接!" bottomOffset:100];
//                }else{
//                    [YQToast yq_ToastText:@"请重新发送" bottomOffset:100];
//                }
//                secondsCountDown = SecondsCountDown;//初始化秒数
//                [countDownTimer invalidate];
//                [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                // 错误码对照
//                // http://wiki.mob.com/%E9%94%99%E8%AF%AF%E7%A0%81%E8%AF%B4%E6%98%8E-2/
//            }];
        }
    }
}

-(void)timeFireMethod{
    secondsCountDown--;
    if(secondsCountDown==0){
        secondsCountDown = SecondsCountDown;//初始化秒数
        [countDownTimer invalidate];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒",secondsCountDown] forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [countDownTimer invalidate];
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
