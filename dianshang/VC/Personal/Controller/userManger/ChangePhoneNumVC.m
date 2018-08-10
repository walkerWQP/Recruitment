//
//  ChangePhoneNumVC.m
//  kuainiao
//
//  Created by yunjobs on 16/4/18.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "ChangePhoneNumVC.h"
#import "EaseUI.h"
#import "JPushManager.h"
#import "YQSaveManage.h"
#import "YQGuideManage.h"
#import "NSString+RegularExpression.h"

@interface ChangePhoneNumVC ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIView *txtView;
    NSTimer *countDownTimer;
    
    BOOL isVer;// 验证是否通过
    int secondsCountDown;
}
@property (strong, nonatomic) UIScrollView *scroller;

@property (strong, nonatomic) NSString *coder;

@property (strong, nonatomic) UITextField *phoneTxt;
@property (strong, nonatomic) UITextField *codeTxt;
@property (strong, nonatomic) UIButton *verBtn;

@end

@implementation ChangePhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"验证旧手机号";
    secondsCountDown = SecondsCountDown;//初始化秒数
    
    [self initView];
}

- (void)initView
{
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    int h = IS_IPhone4 ? 568 : APP_HEIGHT;
    self.scroller.contentSize = CGSizeMake(APP_WIDTH, h);
    [self.view addSubview:self.scroller];
    [self scrollerPress];
    
    NSArray *arrPlace = @[@"手机号码:",@"验证码:"];
    txtView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, APP_WIDTH, arrPlace.count*50)];
    txtView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < arrPlace.count; i++)
    {
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, i*50, APP_WIDTH, 50)];
        textfield.placeholder = arrPlace[i];
        textfield.tag = i+1;
        textfield.font = [UIFont systemFontOfSize:14];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
        textfield.leftView = imgView;
        textfield.delegate = self;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        if (i == 2||i == 3) textfield.secureTextEntry = YES;
        
        if (i == 0)
        {
            textfield.yq_width = APP_WIDTH-100;
            textfield.enabled = NO;
            textfield.text = [UserEntity getPhone];
            self.phoneTxt = textfield;
            
            UIButton *vBtn = [[UIButton alloc] initWithFrame:CGRectMake(textfield.yq_right, 0, 100, textfield.yq_height)];
            [vBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [vBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
            [vBtn setBackgroundColor:BTNBACKGROUND forState:UIControlStateHighlighted];
            vBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [vBtn addTarget:self action:@selector(verificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [txtView addSubview:vBtn];
            self.verBtn = vBtn;
        }
        if (i == 1) {
            self.codeTxt = textfield;
        }
        if (i == 1 || i == 0) {
            textfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        textfield.returnKeyType = UIReturnKeyNext;
        [txtView addSubview:textfield];
        
        if (i == 0 || i == 1 || i==2){
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, textfield.yq_bottom, APP_WIDTH, 0.5)];
            lineView.backgroundColor = RGB(217, 218, 219);
            [txtView addSubview:lineView];
        }
        
    }
    [self.scroller addSubview:txtView];
    
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, txtView.yq_bottom+30, APP_WIDTH-60, 42)];
    [registBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [registBtn setBackgroundColor:BTNBACKGROUND forState:UIControlStateHighlighted];
    [registBtn.layer setMasksToBounds:YES];
    [registBtn setTitle:@"确认" forState:UIControlStateNormal];
    registBtn.layer.cornerRadius = 4;
    registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroller addSubview:registBtn];
    
}

//验证码按钮
- (void)verificationBtnClick:(UIButton *)sender
{
    //[self hideKey];
    NSString *phone = self.phoneTxt.text;
    
    if ([phone isEqualToString:@""]) {
        [YQToast yq_ToastText:@"请输入手机号码" bottomOffset:100];
    }else if (![phone checkPhoneNum]) {
        [YQToast yq_ToastText:@"手机号码不正确" bottomOffset:100];
    }else{
        if ([sender.currentTitle isEqualToString:@"获取验证码"]) {
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            [self.verBtn setTitle:[NSString stringWithFormat:@"%d秒",--secondsCountDown] forState:UIControlStateNormal];
            // 发送验证码
            [self sendmsgCode:phone];
        }
    }
}

- (void)sendmsgCode:(NSString *)phone
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] sendCode_phone:phone success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSString *msg = [NSString stringWithFormat:@"验证码已发送"];
            [YQToast yq_ToastText:msg bottomOffset:100];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

-(void)timeFireMethod{
    secondsCountDown--;
    if(secondsCountDown==0){
        self.verBtn.enabled = YES;
        secondsCountDown = SecondsCountDown;//初始化秒数
        [countDownTimer invalidate];
        [self.verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        self.verBtn.enabled = NO;
        [self.verBtn setTitle:[NSString stringWithFormat:@"%d秒",secondsCountDown] forState:UIControlStateNormal];
    }
}
- (void)registBtnClick:(UIButton *)sender
{
    [self hideKey];
    
    if ([self.phoneTxt.text isEqualToString:@""] || [self.codeTxt.text isEqualToString:@""])
    {
        [YQToast yq_ToastText:@"请输入验证码" bottomOffset:100];
        return;
    }
    //请求接口
    if (isVer) {
        [self reqChangePhone:self.phoneTxt.text code:self.codeTxt.text];
    }else{
        [self reqVerificationPhone:self.phoneTxt.text code:self.codeTxt.text];
    }
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
    [self hideKey];
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}
//点击背景时执行
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKey];
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}

//隐藏键盘
- (void)hideKey
{
    [self.phoneTxt resignFirstResponder];
    [self.codeTxt resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTxt) {
        [self.codeTxt becomeFirstResponder];
    }
    else if (textField == self.codeTxt)
    {
        [self registBtnClick:nil];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int offset =  txtView.yq_bottom+64 - (APP_HEIGHT - 216.0);
    if(offset > 0)
    {
        [self.scroller setContentOffset:CGPointMake(0, offset+20) animated:YES];
    }
}
#pragma mark - 网络访问回调

- (void)reqVerificationPhone:(NSString *)phone code:(NSString *)code
{
    self.coder = code;
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] vChangePhone_uid:[UserEntity getUid] mobile:phone code:code success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            isVer = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"设置新手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag = 2000;
        }else if ([resultDic[CODE] isEqualToString:@"100002"]) {
            [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)reqChangePhone:(NSString *)phone code:(NSString *)code
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] changePhone_uid:[UserEntity getUid] mobile:phone code:code success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag = 1000;
        }else if ([resultDic[CODE] isEqualToString:@"100002"]) {
            [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)outLogin
{
    // 退出登录
    // 把密码清除
    NSDictionary *accountDic = [YQSaveManage objectForKey:MYACCOUNT];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:accountDic];
    [dict removeObjectForKey:@"password"];
    [dict setObject:self.phoneTxt.text forKey:@"username"];
    [YQSaveManage setObject:dict forKey:MYACCOUNT];
    // 清除用户信息
    [YQSaveManage removeObjectForKey:USERINFO];
    // 修改登录状态
    [YQSaveManage setObject:@"0" forKey:LOGINSTATUS];
    // 清除推送别名
    [[JPushManager shareJPushManager] setAlias:@"" resBlock:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    }];
    // 删除分享图片
    //[self deleteShareImage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 退出环信登录
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        [[EMClient sharedClient] logout:YES];
    });
    
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    keyWindow.rootViewController = [YQGuideManage chooseRootController];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        [self outLogin];
    }else if (alertView.tag == 2000){
        self.navigationItem.title = @"设置新手机号";
        self.phoneTxt.text = @"";
        self.codeTxt.text = @"";
        self.phoneTxt.enabled = YES;
        
        self.verBtn.enabled = YES;
        [countDownTimer invalidate];
        [self.verBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        secondsCountDown = SecondsCountDown;//初始化秒数
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [countDownTimer invalidate];
}

@end
