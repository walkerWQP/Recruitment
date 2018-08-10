//
//  LoginViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
static int secondsCountDown = SecondsCountDown;//初始化秒数

#import "LoginViewController.h"
#import "ForgetViewController.h"
#import "YQRootViewController.h"
#import "ServiceAgreementVC.h"
#import "YQNavigationController.h"

#import "ChatDemoHelper.h"

#import "NSString+RegularExpression.h"
#import "NSString+Hash.h"

#import "YQGuideManage.h"
#import "UserEntity.h"

#import "JPushManager.h"
#import "YQSaveManage.h"

#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "YQShareSDKHelper.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    NSTimer *countDownTimer;
    
    UIView *loginView;
    
    BOOL isProtocol;//是否同意协议
}

@property (strong, nonatomic) UITextField *LnameTxt;
@property (strong, nonatomic) UITextField *LpassTxt;

@property (strong, nonatomic) UIButton *loginBtn;

// 验证码按钮
@property (strong, nonatomic) UIButton *codeBtn;

@property (strong, nonatomic) UIScrollView *scroller;
@property (strong, nonatomic) UIImageView *logoImg;

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UIButton *selectBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    
    [self initSelectView];
    
    NSDictionary *accountDic = [YQSaveManage objectForKey:MYACCOUNT];
    NSString *str = [accountDic objectForKey:@"username"];
    self.LnameTxt.text = str != nil ? str : @"";
    NSString *str1 = [accountDic objectForKey:@"password"];
    self.LpassTxt.text = str1 != nil ? str1 : @"";
    
    self.fd_prefersNavigationBarHidden = YES;
    
    // 测试数据
//    self.LnameTxt.text = @"15090228020";
//    self.LpassTxt.text = @"123456";
}

- (void)initSelectView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    self.selectView = view;
    
    CGFloat y = (APP_HEIGHT)/4;
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.yq_width, 120)];
    imageV1.center = CGPointMake(view.yq_width*0.5, y);
    imageV1.image = [UIImage imageNamed:@"login_icon1"];
    imageV1.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageV1];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 45)];
    button.center = CGPointMake(view.yq_width*0.5, imageV1.yq_bottom+40);
    [button setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [button setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"我是人才" forState:UIControlStateNormal];
    button.layer.cornerRadius = button.yq_height*0.5;
    button.layer.masksToBounds = YES;
    button.tag = 1;
    [view addSubview:button];
    
    UILabel *subLbl = [[UILabel alloc] initWithFrame:CGRectMake(button.yq_width-80, 10, 80, 25)];
    subLbl.text = @"共享招聘顾问";
    subLbl.textAlignment = NSTextAlignmentCenter;
    subLbl.textColor = [UIColor whiteColor];
    subLbl.font = [UIFont systemFontOfSize:12];
    subLbl.layer.cornerRadius = 10;
    subLbl.layer.masksToBounds = YES;
    subLbl.backgroundColor = redBtnNormal;
    [button addSubview:subLbl];
    
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.yq_width, 120)];
    imageV2.center = CGPointMake(view.yq_width*0.5, y*2.5);
    imageV2.image = [UIImage imageNamed:@"login_icon2"];
    imageV2.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageV2];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 45)];
    button1.center = CGPointMake(view.yq_width*0.5, imageV2.yq_bottom+40);
    [button1 setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [button1 setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    [button1 addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"我是企业" forState:UIControlStateNormal];
    button1.layer.cornerRadius = button.yq_height*0.5;
    button1.layer.masksToBounds = YES;
    button1.tag = 2;
    [view addSubview:button1];
}

- (void)initView
{
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    //int h = IS_IPhone4 ? 568 : APP_HEIGHT;
    //self.scroller.contentSize = CGSizeMake(APP_WIDTH, h);
    [self.view addSubview:self.scroller];
    [self scrollerPress];
    
    CGFloat navY = IS_IPhoneX ? 44 : 20;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(APP_WIDTH-80, navY, 80, 44)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = -1;
    [button setTitle:@"选择身份" forState:UIControlStateNormal];
    [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [self.scroller addSubview:button];
    self.selectBtn = button;
    
    self.logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70+navY, APP_WIDTH, APP_HEIGHT*0.15)];
    self.logoImg.image = [UIImage imageNamed:@"logo"];
    //self.logoImg.backgroundColor = [UIColor grayColor];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.scroller addSubview:self.logoImg];
    
    UIView *txtView = [[UIView alloc] initWithFrame:CGRectMake(0, self.logoImg.yq_bottom+30, APP_WIDTH, APP_HEIGHT-APP_NAVH-self.logoImg.yq_bottom-60)];
    txtView.layer.cornerRadius = 4;
    //txtView.backgroundColor = [UIColor redColor];
    [self.scroller addSubview:txtView];
    loginView = txtView;
    
    self.LnameTxt = [self setTextField:CGRectMake(30, 0, txtView.yq_width-60, 40) leftImage:@"login_shouji" placeholder:@"请输入手机号"];
    [txtView addSubview:self.LnameTxt];
    
    self.LpassTxt = [self setTextField:CGRectMake(30, self.LnameTxt.yq_height+10, txtView.yq_width-60, 40) leftImage:@"login_yzm" placeholder:@"请输入验证码"];
    //self.LpassTxt.secureTextEntry = YES;
    [txtView addSubview:self.LpassTxt];
    
    UIButton *vCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.LpassTxt.yq_right-85, self.LpassTxt.yq_y, 80, self.LpassTxt.yq_height)];
    vCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [vCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [vCodeBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [vCodeBtn addTarget:self action:@selector(vcodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [txtView addSubview:vCodeBtn];
    self.codeBtn = vCodeBtn;
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, self.LpassTxt.yq_bottom+60, APP_WIDTH-60, 42)];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:BTNBACKGROUND forState:UIControlStateHighlighted];
    [self.loginBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [self.loginBtn.layer setMasksToBounds:YES];
    self.loginBtn.layer.cornerRadius = _loginBtn.yq_height*0.5;
    [self.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [txtView addSubview:self.loginBtn];
    txtView.yq_height = self.loginBtn.yq_bottom+60;
    
    UIButton *protocolBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, self.loginBtn.yq_bottom+25, 60, 35)];
    [protocolBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [protocolBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 5, 8, 35)];
    [protocolBtn setTitle:@"同意" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [txtView addSubview:protocolBtn];
    isProtocol = YES;
    UILabel *protocolLbl = [[UILabel alloc] initWithFrame:CGRectMake(protocolBtn.yq_right, protocolBtn.yq_y, 250, protocolBtn.yq_height)];
    protocolLbl.text = @"《E招用户注册服务协议及隐私条款》";
    protocolLbl.textColor = THEMECOLOR;
    protocolLbl.font = [UIFont systemFontOfSize:14];
    [txtView addSubview:protocolLbl];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(severBtnClick:)];
    protocolLbl.userInteractionEnabled = YES;
    [protocolLbl addGestureRecognizer:tap];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30*2, txtView.yq_bottom+30, txtView.yq_width-60*2, 1)];
//    lineView.backgroundColor = RGB(180, 180, 180);
//    [self.scroller addSubview:lineView];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
//    label.text = @"其他方式登录";
//    label.textColor = RGB(102, 102, 102);
//    label.font = [UIFont systemFontOfSize:12];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor whiteColor];
//    label.center = lineView.center;
//    [self.scroller addSubview:label];
//
//    NSArray *array = @[@"login_qq",@"login_wx",@"login_wb"];
//    CGFloat wh = 60;
//    CGFloat jianju = (lineView.yq_width - array.count*wh) / (array.count+1);
//    CGFloat y = lineView.yq_bottom+30;
//    for (int i = 0; i < array.count; i++) {
//        CGFloat x = lineView.yq_x + jianju*(i+1)+i*wh;
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
//        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(thirdpartyLogin:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag = i;
//        [self.scroller addSubview:button];
//    }
    CGFloat y = txtView.yq_bottom+30;
    int h = (y+100)>APP_HEIGHT? (y+100) : APP_HEIGHT;
    //self.scroller.backgroundColor = RandomColor;
    self.scroller.contentSize = CGSizeMake(APP_WIDTH, h);
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
    textField.keyboardType = UIKeyboardTypeNumberPad;
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
    [self hideKeyBoard];
}
//点击背景时执行
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyBoard];
}
- (void)protocolBtnClick:(UIButton *)sender
{
    if (isProtocol) {
        isProtocol = NO;
        [sender setImage:[UIImage imageNamed:@"select_un"] forState:UIControlStateNormal];
        self.loginBtn.enabled = NO;
        [self.loginBtn setBackgroundColor:[UIColor colorWithWhite:0.624 alpha:1.000] forState:UIControlStateNormal];
    }else{
        isProtocol = YES;
        [sender setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        self.loginBtn.enabled = YES;
        [self.loginBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    }
    
}
/*!
 *  @author 15-06-09 09:06:55
 *
 *  @brief  登录
 *
 *  @param sender sender
 */
#pragma mark - 登录按钮点击
- (void)loginBtnClick:(UIButton *)sender
{
    if ([self.LnameTxt.text isEqualToString:@""] || [self.LpassTxt.text isEqualToString:@""])
    {
        [YQToast yq_ToastText:@"请输入验证码" bottomOffset:100];
        return;
    }
    //请求登录接口
    [self reqLogin];
}
- (void)selectBtnClick:(UIButton *)sender
{
    [self hideKeyBoard];
    
    if (sender.tag == -1) {
        [UIView animateWithDuration:.3f animations:^{
            self.selectView.yq_y = 0;
        }];
    }else{
        self.type = [NSString stringWithFormat:@"%li",sender.tag];
        
        if (sender.tag == 1) {
            [self.selectBtn setTitle:@"个人登录" forState:UIControlStateNormal];
            self.logoImg.image = [UIImage imageNamed:@"login_icon1"];
        }else if (sender.tag == 2){
            [self.selectBtn setTitle:@"企业登录" forState:UIControlStateNormal];
            self.logoImg.image = [UIImage imageNamed:@"login_icon2"];
        }
        
        [UIView animateWithDuration:.3f animations:^{
            self.selectView.yq_y = APP_HEIGHT;
        }];
    }
}

- (void)vcodeBtnClick:(UIButton *)sender
{
    NSString *phone = self.LnameTxt.text;
    if ([phone isEqualToString:@""]) {
        [YQToast yq_ToastText:@"请输入手机号码" bottomOffset:100];
    }else if (![phone checkPhoneNum]) {
        [YQToast yq_ToastText:@"手机号码不正确" bottomOffset:100];
    }else{
        if ([self.codeBtn.currentTitle isEqualToString:@"获取验证码"]) {
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒",--secondsCountDown] forState:UIControlStateNormal];
            // 发送验证码
            [self sendmsgCode:phone];
        }
    }
}
- (void)sendmsgCode:(NSString *)phone
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] sendCode_mobile:phone success:^(id resultDic) {
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

- (void)severBtnClick:(UIButton *)sender
{
    ServiceAgreementVC *vc = [[ServiceAgreementVC alloc] init];
    YQNavigationController *navvc = [[YQNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navvc animated:YES completion:nil];
}

-(void)forgetpwd:(UIButton *)sender
{
//    ForgetViewController *registVC = [[ForgetViewController alloc] init];
//    registVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:registVC animated:YES];
}

-(void)thirdpartyLogin:(UIButton *)sender
{
    
}

#pragma mark - textfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.LnameTxt) {
        [self.LpassTxt becomeFirstResponder];
    }else{
        [self loginBtnClick:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    int offset = txtView.yq_bottom - (APP_HEIGHT - 216.0);
//    if(offset > 0)
//    {
//        [self.scroller setContentOffset:CGPointMake(0, offset+20) animated:YES];
//    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //改变状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 网络访问回调
/// 请求登录接口
- (void)reqLogin
{
    [self.hud show:YES];
    NSLog(@"1    %@",self.LnameTxt.text);
    NSLog(@"2    %@",self.LpassTxt.text);
    [[RequestManager sharedRequestManager] login_uPhone:self.LnameTxt.text smsCode:self.LpassTxt.text type:self.type success:^(id responseObject) {
        [self.hud hide:YES];
        [self reqLoginResult:responseObject];
        NSLog(@"aaaaaa%@",responseObject);
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)reqLoginResult:(NSDictionary *)resultDic
{
    if ([resultDic[CODE] isEqualToString:SUCCESS]) {
        //保存返回的用户信息
        [UserEntity setUserInfo:resultDic[DATA][@"userinfo"]];
        
        //[UserEntity setToken:resultDic[@"token"]];
        //保存余额
        //[UserEntity setBalance:[UserEntity userEntity][@"account"]];
        
        //保存用户名密码
        NSDictionary *accountDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.LnameTxt.text,@"username",self.LpassTxt.text,@"password", nil];
        [YQSaveManage setObject:accountDic forKey:MYACCOUNT];
        
        //根据ID设置别名
        NSString *alias = [NSString stringWithFormat:@"kezhao_%@",[UserEntity getUid]];
        [[JPushManager shareJPushManager] setAlias:alias resBlock:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        }];
        // 设置登录状态
        [YQSaveManage setObject:@"1" forKey:LOGINSTATUS];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootVC = [YQGuideManage chooseRootController];
        window.rootViewController = rootVC;
        
        if ([rootVC isKindOfClass:[YQRootViewController class]]) {
            
            //self.mainController = (YQRootViewController *)rootVC;
            
            [ChatDemoHelper shareHelper].mainVC = (YQRootViewController *)rootVC;
            //NSLog(@"%@",self.mainController.chatListVC);
            //[ChatDemoHelper shareHelper].conversationListVC = self.mainController.chatListVC;
            //        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
            //        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
            //        [[ChatDemoHelper shareHelper] asyncPushOptions];
            
            NSString *hxname = [UserEntity getHXUserName];
            NSString *hxpass = @"123456".md5String;
            [[EMClient sharedClient] loginWithUsername:hxname password:hxpass completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    CLog(@"环信->登录成功");
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                } else {
                    CLog(@"环信->登录失败");
                }
            }];
        }
        
    }else{
        [YQToast yq_ToastText:resultDic[MSG] bottomOffset:100];
    }
}

#pragma mark - other

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

- (void)hideKeyBoard
{
    [self.LnameTxt resignFirstResponder];
    [self.LpassTxt resignFirstResponder];
//    [self.RvCodeTxt resignFirstResponder];
//    [self.RphoneTxt resignFirstResponder];
//    [self.RpassTxt resignFirstResponder];
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)dealloc
{
    [countDownTimer invalidate];
}

#pragma mark - sharesdk


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
