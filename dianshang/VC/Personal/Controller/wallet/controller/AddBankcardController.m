//
//  AddBankcardController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "AddBankcardController.h"
#import "YQSaveManage.h"

@interface AddBankcardController ()<UITextFieldDelegate>
{
    UIView *twoView;
    
    UITextField *nameTxt;//姓名文本框
    UITextField *tixianTxt;//提现文本框
    UITextField *zhanghuTxt;//账户文本框
}
@property (strong, nonatomic) UIScrollView *scroller;

@end

@implementation AddBankcardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现账户";
    
    [self initView];
}

- (void)initView
{
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    int h = IS_IPhone4 ? 568 : self.scroller.yq_height;
    self.scroller.contentSize = CGSizeMake(APP_WIDTH, h);
    [self.view addSubview:self.scroller];
    [self scrollerPress];
    
    twoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 200)];
    twoView.backgroundColor = [UIColor whiteColor];
    [self.scroller addSubview:twoView];
    
    UILabel *tixian = [self labelEdit:CGRectMake(0, 0, APP_WIDTH, 20) fontSize:13 align:NSTextAlignmentLeft];
    tixian.text = @"";
    tixian.textColor = RGB(102, 102, 102);
    tixian.backgroundColor = RGB(243, 243, 243);
    [twoView addSubview:tixian];
    
    UILabel *label = [self labelEdit:CGRectMake(10, tixian.yq_bottom+5, 75, 40) fontSize:13 align:NSTextAlignmentLeft];
    label.text = @"支付宝账户:";
    [twoView addSubview:label];
    
    UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(label.yq_right, label.yq_y, APP_WIDTH-20-label.yq_width, 40)];
    textfiled.font = [UIFont systemFontOfSize:13];
    textfiled.delegate = self;
    zhanghuTxt = textfiled;
    zhanghuTxt.placeholder = @"请输入支付宝账户";
    [twoView addSubview:textfiled];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, textfiled.yq_bottom+5, APP_WIDTH-20, 0.5)];
    lineView.backgroundColor = RGB(180, 180, 180);
    [twoView addSubview:lineView];
    
    UILabel *label1 = [self labelEdit:CGRectMake(10, lineView.yq_bottom+5, 75, 40) fontSize:13 align:NSTextAlignmentLeft];
    label1.text = @"真实姓名:";
    [twoView addSubview:label1];
    
    UITextField *textfiled1 = [[UITextField alloc] initWithFrame:CGRectMake(label1.yq_right, label1.yq_y, APP_WIDTH-20-label1.yq_width, 40)];
    textfiled1.font = [UIFont systemFontOfSize:13];
    textfiled1.delegate = self;
    nameTxt = textfiled1;
    nameTxt.placeholder = @"请输入真实姓名";
    [twoView addSubview:textfiled1];
    
    twoView.frame = CGRectMake(0, 0, APP_WIDTH, textfiled1.yq_bottom+5);
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, textfiled1.yq_bottom+30, APP_WIDTH-40, 40)];
    [quitBtn setBackgroundColor:redBtnNormal forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:redBtnHighlighted forState:UIControlStateHighlighted];
    [quitBtn setTitle:@"保存" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scroller addSubview:quitBtn];
    //    if ([tixianLbl.text floatValue] < 50) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"您的余额不足50元,暂时不能提现!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
    
//    if ([self getCashAccount] != nil) {
//        zhanghuTxt.text = [self getAccount];
//        nameTxt.text = [self getName];
//    }
    NSDictionary *dict = [YQSaveManage objectForKey:LTixianAccount];
    if (dict != nil) {
        textfiled.text = dict[@"account"];
        textfiled1.text = dict[@"account_name"];
    }
}

- (UILabel *)labelEdit:(CGRect)frame fontSize:(int)fontSize align:(NSTextAlignment)align
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    //label.backgroundColor = RandomColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = align;
    label.textColor = RGB(51, 51, 51);
    return label;
}

#pragma mark - 按钮事件

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
    [nameTxt resignFirstResponder];
    [zhanghuTxt resignFirstResponder];
    [tixianTxt resignFirstResponder];
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}
//点击背景时执行
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nameTxt resignFirstResponder];
    [zhanghuTxt resignFirstResponder];
    [tixianTxt resignFirstResponder];
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)saveBtnClick
{
    if ([nameTxt.text isEqualToString:@""] || [zhanghuTxt.text isEqualToString:@""]) {
        [YQToast yq_ToastText:@"请输入支付宝账户或真实姓名" bottomOffset:100];
    }else{
        NSDictionary *dict = @{@"account_name":nameTxt.text, @"account":zhanghuTxt.text};
        [YQSaveManage setObject:dict forKey:LTixianAccount];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
