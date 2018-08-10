//
//  WithdrawalsController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "WithdrawalsController.h"
#import "AddBankcardController.h"

#import "PersonItem.h"
#import "YQSaveManage.h"

@interface WithdrawalsController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *tixianTxt;
}
@property (nonatomic, strong) NSDictionary *tixianDict;

@property (nonatomic, strong) UIButton *tixianBtn;
@end

@implementation WithdrawalsController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpdata];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现";
    
    //[self setUpdata];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.tableView.tableFooterView = [self footerView];
    self.tableView.backgroundColor = RGB(243, 243, 243);
    self.cellStyle = YQTableViewCellStyleSubtitle;
    [self.view addSubview:self.tableView];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    NSDictionary *dict = [YQSaveManage objectForKey:LTixianAccount];
    self.tixianDict = dict;
    if (dict != nil) {
        PersonItem *item0 = [PersonItem setCellItemImage:@"person_haoyou" title:dict[@"account"]];
        item0.subTitle = dict[@"account_name"];
        item0.pushController = [AddBankcardController class];
        [items addObject:item0];
    }else{
        PersonItem *item0 = [PersonItem setCellItemImage:@"person_haoyou" title:@"添加提现账户"];
        item0.subTitle = @"";
        item0.pushController = [AddBankcardController class];
        [items addObject:item0];
    }
    
    if (self.groups.count > 0) {
        [self.groups removeAllObjects];
    }
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:nil];
    [self.groups addObject:group];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (UIView *)footerView
{
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 200)];
    headV.backgroundColor = [UIColor whiteColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headV.yq_width, 20)];
    v.backgroundColor = RGB(243, 243, 243);
    [headV addSubview:v];
    
    UILabel *balancelbl = [[UILabel alloc] init];
    balancelbl.text = @"提现金额";
    balancelbl.adjustsFontSizeToFitWidth = YES;
    balancelbl.textColor = RGB(102, 102, 102);
    balancelbl.textAlignment = NSTextAlignmentLeft;
    balancelbl.font = [UIFont systemFontOfSize:16];
    balancelbl.frame = CGRectMake(20, v.yq_bottom+8, APP_WIDTH-40, 25);
    [headV addSubview:balancelbl];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"￥";
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.textColor = RGB(51, 51, 51);
    //lbl.backgroundColor = RandomColor;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:40];
    lbl.frame = CGRectMake(20, balancelbl.yq_bottom+5, 35, 40);
    [headV addSubview:lbl];
    
    UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(lbl.yq_right, lbl.yq_y, headV.yq_width-lbl.yq_right-20, 40)];
    textfiled.font = [UIFont systemFontOfSize:40];
    textfiled.delegate = self;
    tixianTxt = textfiled;
    textfiled.textColor = RGB(51, 51, 51);
//    textfiled.backgroundColor = RandomColor;
    textfiled.keyboardType = UIKeyboardTypeDecimalPad;
    [textfiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    // 计算最高提现金额
    //totalBalance = [UserEntity balanceAllowAccount];
    //tixianTxt.placeholder = [NSString stringWithFormat:@"最高提现金额是%@",totalBalance];
    [headV addSubview:textfiled];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(15, textfiled.yq_bottom+5, headV.yq_width-30, 0.5)];
    v1.backgroundColor = RGB(229, 229, 229);
    [headV addSubview:v1];
    
    UILabel *allowLbl = [[UILabel alloc] init];
    allowLbl.text = [NSString stringWithFormat:@"可用余额%.2f元",[[UserEntity getBalance] floatValue]];
    allowLbl.adjustsFontSizeToFitWidth = YES;
    allowLbl.textColor = RGB(180, 180, 180);
    allowLbl.textAlignment = NSTextAlignmentLeft;
    allowLbl.font = [UIFont systemFontOfSize:15];
    allowLbl.frame = CGRectMake(20, v1.yq_bottom+5, APP_WIDTH-40, 30);
    [headV addSubview:allowLbl];
    
    UIButton *totalBtn = [[UIButton alloc] initWithFrame:CGRectMake(headV.yq_width-75, allowLbl.yq_y, 60, 30)];
    [totalBtn setTitle:@"全部提现" forState:UIControlStateNormal];
    [totalBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    [totalBtn addTarget:self action:@selector(totalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    totalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [headV addSubview:totalBtn];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, totalBtn.yq_bottom+3, headV.yq_width, 75)];
    v2.backgroundColor = RGB(243, 243, 243);
    [headV addSubview:v2];
    
    UILabel *toast = [[UILabel alloc] init];
    toast.text = @"账户满500元可提现,提现账户收款人应与实名认证用户为同一人,提现后1-3个工作日到账.";
    toast.numberOfLines = 0;
    toast.textColor = RGB(102, 102, 102);
    toast.textAlignment = NSTextAlignmentLeft;
    toast.font = [UIFont systemFontOfSize:15];
    toast.frame = CGRectMake(20, 5, APP_WIDTH-40, 45);
    [v2 addSubview:toast];
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, toast.yq_bottom+35, headV.yq_width-40, 40)];
    [quitBtn setBackgroundColor:redBtnNormal forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:redBtnHighlighted forState:UIControlStateHighlighted];
    [quitBtn setTitle:@"提  现" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(quitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [v2 addSubview:quitBtn];
    v2.yq_height = quitBtn.yq_bottom+30;
    headV.yq_height = v2.yq_bottom;
    self.tixianBtn = quitBtn;
    [self.tixianBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.tixianBtn.enabled = NO;
    
    return headV;
}
- (void)textFieldChanged:(UITextField *)textField
{
    CGFloat textbalance = [textField.text floatValue];
    if (textbalance > 0) {
        CGFloat balance = [[UserEntity getBalance] floatValue];
        if (textbalance > balance) {
            [self.tixianBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.tixianBtn.enabled = NO;
        }else{
            self.tixianBtn.enabled = YES;
            [self.tixianBtn setBackgroundColor:redBtnNormal forState:UIControlStateNormal];
        }
    }else{
        [self.tixianBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.tixianBtn.enabled = NO;
    }
}
NSInteger countaaa = 10;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == tixianTxt){
        if ([string isEqualToString:@""]) {
            return YES;
        }
        
        NSRange range = [textField.text rangeOfString:@"."];
        if (range.length>=1) {
            countaaa = range.location+2;
            if ([textField.text length] > countaaa) {
                return NO;
            }
        }
        if ([string isEqualToString:@"."]) {
            if ([textField.text length]==0) {
                return NO;
            }
            NSString *string2 = [textField.text substringWithRange:NSMakeRange([textField.text length]-1, 1)];
            if ([string isEqualToString:string2]) {
                return NO;
            }
            NSRange range = [textField.text rangeOfString:@"."];
            if (range.length>=1) {
                return NO;
            }
            countaaa = [textField.text length]+1;
        }
        if ([textField.text length] > 7) {
            return NO;
        }
        
        return YES;
    }
    //    else if (textField == payPassTxt){
    //        if ([string isEqualToString:@""]) {
    //            return YES;
    //        }
    //        if ([textField.text length] < 6) {
    //            return YES;
    //        }else{
    //            return NO;
    //        }
    //    }
    return YES;
}

- (void)totalBtnClick:(UIButton *)sender
{
    if ([[UserEntity getBalance] floatValue] > 0) {
        tixianTxt.text = [NSString stringWithFormat:@"%.2f",[[UserEntity getBalance] floatValue]];
        if ([tixianTxt.text floatValue] >= 500) {
            self.tixianBtn.enabled = YES;
            [self.tixianBtn setBackgroundColor:redBtnNormal forState:UIControlStateNormal];
        }
    }
}

- (void)quitBtnClick:(UIButton *)sender
{
    NSDictionary *dict = [YQSaveManage objectForKey:LTixianAccount];
    NSString *alipay = dict[@"account"];
    NSString *alipayname = dict[@"account_name"];
    
    CGFloat balance = [tixianTxt.text floatValue];
    
    if (balance < 500) {
        [YQToast yq_ToastText:@"最少提现500元" bottomOffset:100];
    }else if (alipay.length == 0 || alipayname.length == 0){
        [YQToast yq_ToastText:@"请填写正确的提现账户" bottomOffset:100];
    }else{
        NSString *phone = [UserEntity getPhone];
        [self sendmsgCode:phone];
//        NSString *msg = [NSString stringWithFormat:@"您的验证码已发送到%@,请注意查收.",phone];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认提现", nil];
//        alert.tag = 1000;
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [alert show];
//        UITextField *tf = [alert textFieldAtIndex:0];
//        tf.keyboardType =UIKeyboardTypeNumberPad;
//        tf.placeholder = @"填写验证码";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            [self reqWithdrawals:tf.text];
        }
    }
}

- (void)reqWithdrawals:(NSString *)code
{
    NSDictionary *dict = [YQSaveManage objectForKey:LTixianAccount];
    NSString *alipay = dict[@"account"];
    NSString *alipayname = dict[@"account_name"];
    NSString *money = tixianTxt.text;
    
    NSString *msg = @"";
    if (code.length != 4) {
        msg = @"请输入正确的验证码!";
    }else{
        // 提交提现申请
        NSString *mstatus = [UserEntity getIsCompany] ? @"2" : @"1";
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] balanceWithdrawals_uid:[UserEntity getUid] mstatus:mstatus alipay:alipay money:money code:code alipayname:alipayname success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                CGFloat a = [[UserEntity getBalance] floatValue]-[money floatValue];
                NSString *balance = [NSString stringWithFormat:@"%g",a];
                [UserEntity setBalance:balance];
                
                if (self.refreshBalance) {
                    self.refreshBalance(balance);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([resultDic[CODE] isEqualToString:@"100002"]){
                [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
    if (msg.length > 0) {
        [YQToast yq_ToastText:msg bottomOffset:100];
    }
}

- (void)sendmsgCode:(NSString *)phone
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] sendCode_phone:phone success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSString *phone = [UserEntity getPhone];
            NSString *msg = [NSString stringWithFormat:@"您的验证码已发送到%@,请注意查收.",phone];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认提现", nil];
            alert.tag = 1000;
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            UITextField *tf = [alert textFieldAtIndex:0];
            tf.keyboardType =UIKeyboardTypeNumberPad;
            tf.placeholder = @"填写验证码";
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
