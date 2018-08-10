//
//  InvitationInterviewController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/7.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "InvitationInterviewController.h"

#import "ResumeManageEntity.h"
#import "CompanyHomeEntity.h"

#import "HQPickerView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+MyDate.h"
#import "UITextField+YQTextField.h"
#import "UITextView+ZWPlaceHolder.h"

#import "YQPayManage.h"

@interface InvitationInterviewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate,HQPickerViewDelegate>
{
    UIScrollView *scroller;
}
// 描述字数
@property (nonatomic, strong) UILabel *wordNumLbl;
// 地址
@property (nonatomic, strong) UITextField *addressTextField;
// 面试日期
@property (nonatomic, strong) UITextField *dateTextField;
// 面试时间
@property (nonatomic, strong) UITextField *timeTextField;
// 补充说明
@property (nonatomic, strong) UITextView *textView;


@property (nonatomic, strong) HQPickerView *dateView;

@property (nonatomic, strong) HQPickerView *timeView;

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UITextField *redpacketTxt;

@property (nonatomic, assign) BOOL isRedpacket;
@end

@implementation InvitationInterviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"创建面试邀请";
    
    [self initView];
    
}
- (void)initView
{
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    scroller.backgroundColor = RGB(239, 239, 239);
    scroller.delegate = self;
    [self.view addSubview:scroller];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerClick:)];
    [scroller addGestureRecognizer:tap];
    //scroller.contentSize = CGSizeMake(APP_WIDTH, APP_HEIGHT+500);
    
    UIView *headView = [self aHeadView];
    
    UIView *detailView0 = [self storeDetailView:headView];
    
    UIView *content = [self contentTextView:detailView0];
    
    UIView *redView = [self redpacketView:content];
    self.redView = redView;
    UIView *buttonView = [self buttonView:redView];
    self.buttonView = buttonView;
    
    [scroller setContentSize:CGSizeMake(APP_WIDTH, buttonView.yq_bottom+250)];
}

- (UIView *)aHeadView
{
    CGFloat w = scroller.yq_width;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, w, 80)];
    headView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:headView];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    NSString *url = [NSString stringWithFormat:@"%@%@",ImageURL,self.entity.avatar];
    [headImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
    [headView addSubview:headImg];
    headImg.layer.cornerRadius = headImg.yq_height*0.5;
    headImg.layer.masksToBounds = YES;
    
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(headImg.yq_right+10, headImg.yq_y, w-headImg.yq_right-20-40, 30)];
    titlelabel.text = self.entity.name;
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:16];
    [headView addSubview:titlelabel];
    
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(titlelabel.yq_x, titlelabel.yq_bottom, w-headImg.yq_right-20-40, 20)];
    NSString *str = [NSString stringWithFormat:@"面试%@(%@)",self.entity.pname,self.entity.salary];
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
    
    return headView;
}

- (UIView *)contentTextView:(UIView *)storePhotoView
{
    CGFloat w = scroller.yq_width;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, 230)];
    contentView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:contentView];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 45)];
    titlelabel.text = @"补充说明:";
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:titlelabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_height-15)];
    textView.delegate = self;
    textView.backgroundColor = RGB(243, 243, 243);
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.cornerRadius = 5;
    textView.placeholder = @"补充说明(选填)";
    [contentView addSubview:textView];
    _textView = textView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textView.yq_width-52, textView.yq_height-20, 50, 20)];
    label.text = @"0/150";
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGB(102, 102, 102);
    label.font = [UIFont systemFontOfSize:12];
    [textView addSubview:label];
    self.wordNumLbl = label;
    
    return contentView;
}

- (UIView *)redpacketView:(UIView *)storePhotoView
{
    CGFloat w = scroller.yq_width;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, 50)];
    contentView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:contentView];
    contentView.layer.masksToBounds = YES;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 80, 45)];
    titlelabel.text = @"面试红包";
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:titlelabel];
    
    UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(titlelabel.yq_right+10, 0, 100, 45)];
    switchView.on = NO;//设置初始为ON的一边
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    switchView.center = CGPointMake(switchView.center.x, titlelabel.center.y);
    [contentView addSubview:switchView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, titlelabel.yq_bottom+5, 75, 35)];
    label.text = @"红包金额";
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.yq_right, label.yq_y, 50, 35)];
    //tf.placeholder = @"请填入红包金额";
    //tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.font = [UIFont systemFontOfSize:14];
    tf.delegate = self;
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    [contentView addSubview:tf];
    self.redpacketTxt = tf;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(tf.yq_x-5, tf.yq_bottom+0, tf.yq_width+5, 1)];
    lineView.backgroundColor = THEMECOLOR;
    [contentView addSubview:lineView];
    
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(tf.yq_right+8, tf.yq_y, 50, 35)];
    cellLabel.text = @"元";
    cellLabel.textColor = RGB(51, 51, 51);
    cellLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:cellLabel];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, label.yq_bottom+5, contentView.yq_width-16, 65)];
    tipLabel.text = @"添加面试红包后,只有人才真实面试后,您在对应职位已面试列表点击是否通过,红包才会发放给人才哦.如果人才没有来面试请点击未面试,红包金额会返回到您的余额.";
    tipLabel.textColor = RGB(51, 51, 51);
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.numberOfLines = 0;
    [contentView addSubview:tipLabel];
    
    return contentView;
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    self.isRedpacket = isButtonOn;
    if (isButtonOn) {
        [UIView animateWithDuration:.3 animations:^{
            self.redView.yq_height = 165;
            self.buttonView.yq_y = self.redView.yq_bottom+8;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        [self.redpacketTxt resignFirstResponder];
        [UIView animateWithDuration:.3 animations:^{
            self.redView.yq_height = 50;
            self.buttonView.yq_y = self.redView.yq_bottom+8;
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (UIView *)buttonView:(UIView *)storePhotoView
{
    CGFloat w = scroller.yq_width;
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, 95)];
    buttonView.backgroundColor = [UIColor clearColor];
    [scroller addSubview:buttonView];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, APP_WIDTH - 60, 45)];
    [saveBtn setTitle:@"发送面试邀请" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    saveBtn.layer.cornerRadius = 4;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setBackgroundColor:blueBtnNormal forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:saveBtn];
    
    return buttonView;
}
- (UIView *)storeDetailView:(UIView *)storePhotoView
{
    NSArray *arr = @[@"面试日期",@"面试时间",@"公司地址"];
    
    CGFloat w = scroller.yq_width;
    CGFloat h = 45;
    UIView *storeDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom, w, h*arr.count)];
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
        [storeDetailView addSubview:textfield];
        
        if (i == 0) {
            _dateTextField = textfield;
        }else if (i == 1) {
            _timeTextField = textfield;
        }else if (i == 2) {
            _addressTextField = textfield;
        }
        
        if (i == 2) {
            textfield.placeholder = [NSString stringWithFormat:@"请输入%@",arr[i]];
            [textfield yq_setTitle:[arr[i] stringByAppendingString:@":"] titleColor:RGB(51, 51, 51)];
            //textfield.enabled = NO;
            textfield.text = [NSString stringWithFormat:@"%@%@",self.entity.pcity,self.entity.address];
        }else{
            textfield.placeholder = [NSString stringWithFormat:@"请选择%@",arr[i]];
            [textfield yq_setTitle:[arr[i] stringByAppendingString:@":"] titleColor:RGB(51, 51, 51) rightImage:@"back_right"];
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.enabled = NO;
            
            UIButton *button = [[UIButton alloc] initWithFrame:textfield.frame];
            [storeDetailView addSubview:button];
            
            if (i == 0){
                // 选择日期
                [button addTarget:self action:@selector(DateClick:) forControlEvents:UIControlEventTouchUpInside];
            }if (i == 1){
                // 选择时间
                [button addTarget:self action:@selector(TimeClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        if (i != arr.count-1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, y+h-1, APP_WIDTH-20, 0.5)];
            lineView.backgroundColor = RGB(239, 239, 239);
            [storeDetailView addSubview:lineView];
        }
        
    }
    
    return storeDetailView;
}

#pragma mark - textViewDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.redpacketTxt == textField) {
        [scroller setContentOffset:CGPointMake(0, 200) animated:YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.redpacketTxt == textField) {
        //[scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [scroller setContentOffset:CGPointMake(0, 200) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //[scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>150) {
        NSMutableString *a = [NSMutableString stringWithString:textView.text];
        self.textView.text = [a substringToIndex:150];
    }
    self.wordNumLbl.text = [NSString stringWithFormat:@"%d/150",(int)textView.text.length];
}

#pragma mark - 事件

- (HQPickerView *)dateView
{
    if (_dateView == nil) {
        
        HQPickerView *startView = [[HQPickerView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH,APP_HEIGHT)];
        startView.customArr = [self getDateStr];
        startView.delegate = self;
        startView.tag = 1;
        _dateView = startView;
    }
    return _dateView;
}
- (HQPickerView *)timeView
{
    if (_timeView == nil) {
        HQPickerView *startView = [[HQPickerView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH,APP_HEIGHT)];
        startView.customArr = [self getTimeStr];
        startView.delegate = self;
        startView.tag = 2;
        _timeView = startView;
    }
    return _timeView;
}
- (void)pickerView:(HQPickerView *)view didSelectText:(NSString *)text
{
    if (view.tag == 1) {
        // 日期
        self.dateTextField.text = text;
    }else if (view.tag == 2){
        // 时间
        self.timeTextField.text = text;
    }
}
- (void)DateClick:(UIButton *)sender
{
    [self hideKeyBoard];
    
    [self.dateView showAnimate];
    
}
- (void)TimeClick:(UIButton *)sender
{
    [self hideKeyBoard];
    
    [self.timeView showAnimate];
}
- (void)sendBtnClick:(UIButton *)sender
{
    NSString *date = self.dateTextField.text;
    NSString *time = self.timeTextField.text;
    NSString *address = self.addressTextField.text;
    NSString *desc = self.textView.text;
    
    NSString *redStr = self.redpacketTxt.text;
    
    NSString *msg = @"";
    if (date.length == 0) {
        msg = @"请选择面试日期";
    }else if (time.length == 0){
        msg = @"请选择面试时间";
    }else if (address.length == 0){
        msg = @"请填写面试地址";
    }else{
        date = [date substringToIndex:date.length-1];
        NSString *aaa = [date stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        NSString *dateStr = [NSString stringWithFormat:@"%@ %@",aaa,time];
        NSString *rid = self.entity.rid;
        if (rid == nil || [rid isEqualToString:@""]) {
            rid = @"";
        }
        if (self.isRedpacket) {
            if (redStr.length == 0){
                msg = @"请填写面试红包金额";
            }else if ([redStr floatValue] <= 0){
                msg = @"请填写面试红包金额";
            }else{
                [self sendRedPacketInterview:rid date:dateStr address:address desc:desc];
            }
        }else{
            [self sendInterview:rid date:dateStr address:address desc:desc];
        }
    }
    if (msg.length>0) {
        [YQToast yq_ToastText:msg bottomOffset:100];
    }
}
- (void)sendRedPacketInterview:(NSString *)rid date:(NSString *)dateStr address:(NSString *)address desc:(NSString *)desc
{
    YQPayManage *pay = [[YQPayManage alloc] init];
    
    YQPayMode model = YQPayModeAli;
    NSString *orderId = @"";
    NSString *money = self.redpacketTxt.text;
    
    //NSString *uid = [UserEntity getUid];
    NSString *pid = self.entity.posid;
    NSString *mid = self.entity.itemId;
    NSString *orderid = self.entity.orderid;
    
    NSDictionary *dict = @{@"orderid":orderid,@"rid":rid,@"pid":pid,@"mid":mid,@"date":dateStr,@"address":address,@"describe":desc};
    
    [pay handlePayMode:model orderType:YQPayOrderRedpacketType orderid:orderId money:money ext:dict handleBlock:^(NSInteger code,YQPayMode model, NSString *codeMsg, NSString *errorStr) {
        if (code == 1000) {
            [YQToast yq_ToastText:@"支付成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (code == 2000){
            [YQToast yq_AlertText:@"支付失败"];
        }else if (code == 3000){
            [YQToast yq_AlertText:@"支付取消"];
        }
    }];
}
- (void)sendInterview:(NSString *)rid date:(NSString *)dateStr address:(NSString *)address desc:(NSString *)desc
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] sendInterview_uid:[UserEntity getUid] rid:rid  pid:self.entity.posid mid:self.entity.itemId orderid:self.entity.orderid date:dateStr address:address describe:desc success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"邀请成功" bottomOffset:100];
            self.entity.cdealwith = @"3";
            [self.navigationController popViewControllerAnimated:YES];
            if (self.backBlock) {
                self.backBlock(self.entity);
            }
        }else if ([resultDic[CODE] isEqualToString:@"100002"]){
            [YQToast yq_AlertText:resultDic[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)scrollerClick:(UIGestureRecognizer *)sender
{
    // 隐藏键盘
    [self hideKeyBoard];
}

- (void)hideKeyBoard
{
    [_textView resignFirstResponder];
    [_redpacketTxt resignFirstResponder];
    [_addressTextField resignFirstResponder];
}


- (NSArray *)getDateStr
{
    NSMutableArray *arr = [NSMutableArray array];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    for (int i = 0; i < 30; i++) {
        NSTimeInterval a = interval + i * 86400;
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:a];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM月dd日"];
        NSString *str = [format stringFromDate:confromTimesp];
        [arr addObject:str];
    }
    return arr;
}

- (NSArray *)getTimeStr
{
//    NSMutableArray *arr = [NSMutableArray array];
//    NSTimeInterval interval = 28800;
//    for (int i = 0; i < 26; i++) {
//        NSTimeInterval a = interval + i * 1800;
//        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:a];
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        [format setDateFormat:@"HH:mm"];
//        NSString *str = [format stringFromDate:confromTimesp];
//        [arr addObject:str];
//    }
    NSArray *arr = @[@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00"];
    return arr;
}

NSInteger redcount = 4;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.redpacketTxt){
        if ([string isEqualToString:@""]) {
            return YES;
        }
        
        NSRange range = [textField.text rangeOfString:@"."];
        if (range.length>=1) {
            redcount = range.location+2;
            if ([textField.text length] > redcount) {
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
            redcount = [textField.text length]+1;
        }
        if ([textField.text length] >= 4) {
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
