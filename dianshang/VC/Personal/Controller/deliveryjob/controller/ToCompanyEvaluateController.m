//
//  ToCompanyEvaluateController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/24.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ToCompanyEvaluateController.h"

#import "DeliveryJobEntity.h"

#import "YQEvaluateView.h"
#import "UITextView+ZWPlaceHolder.h"

@interface ToCompanyEvaluateController ()<UITextViewDelegate>
{
    CGFloat contentViewY;
}
@property (nonatomic, strong) UILabel *wordNumLbl;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray<YQEvaluateView *> *evaluateViews;

@end

@implementation ToCompanyEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[];
    if (self.type == EvaluateTypeFirstImpression) {
        self.navigationItem.title = @"第一印象";
        array = @[@"第一印象"];
    }else if (self.type == EvaluateTypeEntryImpression){
        self.navigationItem.title = @"入职后";
        array = @[@"办公环境",@"企业文化",@"员工关怀",@"福利待遇",@"企业前景",];
    }else if (self.type == EvaluateTypeworkerImpression){
        self.navigationItem.title = @"离职后";
        array = @[@"离职印象"];
    }
    
    self.evaluateViews = [NSMutableArray array];
    
    if (array.count > 0) {
        [self impressionView:array];
        
        UIBarButtonItem *item = [UIBarButtonItem itemWithtitle:@"提交" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
}

- (void)impressionView:(NSArray *)array
{
    
    CGFloat height = 45;
    CGFloat jianju = 3;
    NSInteger count = array.count;
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, APP_WIDTH, (jianju*count+1)+height*count)];
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    for (int i = 0; i < count; i++) {
        YQEvaluateView *view = [[YQEvaluateView alloc] initWithFrame:CGRectMake(0, jianju*(i+1)+height*i, firstView.yq_width, height)];
        view.title = array[i];
        [firstView addSubview:view];
        [self.evaluateViews addObject:view];
    }
    
    CGFloat w = APP_WIDTH;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, firstView.yq_bottom + 8, w, 300)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
//    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 45)];
//    titlelabel.text = [self.navigationItem.title stringByAppendingString:@":"];
//    titlelabel.textColor = RGB(51, 51, 51);
//    titlelabel.font = [UIFont systemFontOfSize:14];
//    [contentView addSubview:titlelabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 8, contentView.yq_width-30, contentView.yq_height-15)];
    textView.delegate = self;
    textView.backgroundColor = RGB(243, 243, 243);
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.cornerRadius = 5;
    [contentView addSubview:textView];
    _textView = textView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textView.yq_width-52, textView.yq_height-20, 50, 20)];
    label.text = @"0/150";
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGB(102, 102, 102);
    label.font = [UIFont systemFontOfSize:12];
    [textView addSubview:label];
    self.wordNumLbl = label;
    
    if (self.type == EvaluateTypeFirstImpression) {
        textView.placeholder = @"说说第一印象吧...";
    }else if (self.type == EvaluateTypeEntryImpression){
        textView.placeholder = @"说说入职印象吧...";
    }else if (self.type == EvaluateTypeworkerImpression){
        textView.placeholder = @"吐槽一下离职印象吧...";
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    contentViewY = self.contentView.yq_y;
    
    [UIView animateWithDuration:.3f animations:^{
        self.contentView.yq_y = 0;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:.3f animations:^{
        self.contentView.yq_y = contentViewY;
    }];
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

- (void)rightClick
{
    NSString *textStr = self.textView.text;
    if (textStr.length == 0) {
        [YQToast yq_ToastText:@"请输入内容" bottomOffset:100];
        return;
    }
    [self.textView resignFirstResponder];
    // 第一印象
    NSString *firstgradeStr = @"";
    NSString *firstinfoStr = @"";
    // 入职印象
    NSString *officeStr = @"";
    NSString *cultureStr = @"";
    NSString *careStr = @"";
    NSString *benefitsStr = @"";
    NSString *prospectsStr = @"";
    // 离职印象
    NSString *leavegradeStr = @"";
    NSString *leaveinfoStr = @"";
    
    if (self.type == EvaluateTypeFirstImpression) {
        YQEvaluateView *view = self.evaluateViews.firstObject;
        firstgradeStr = view.resultStr;
        firstinfoStr = self.textView.text;
    }else if (self.type == EvaluateTypeEntryImpression) {
        YQEvaluateView *view0 = self.evaluateViews[0];
        YQEvaluateView *view1 = self.evaluateViews[1];
        YQEvaluateView *view2 = self.evaluateViews[2];
        YQEvaluateView *view3 = self.evaluateViews[3];
        YQEvaluateView *view4 = self.evaluateViews[4];
        officeStr = view0.resultStr;
        cultureStr = view1.resultStr;
        careStr = view2.resultStr;
        benefitsStr = view3.resultStr;
        prospectsStr = view4.resultStr;
        //firstinfoStr = self.textView.text;
    }else if (self.type == EvaluateTypeworkerImpression) {
        YQEvaluateView *view = self.evaluateViews.firstObject;
        leavegradeStr = view.resultStr;
        leaveinfoStr = self.textView.text;
    }
    
    NSString *type = [NSString stringWithFormat:@"%li",self.type];
    
    [[RequestManager sharedRequestManager] impressionEvaluate_uid:[UserEntity getUid] posid:self.entity.positionid puid:self.entity.puid type:type firstgrade:firstgradeStr firstinfo:firstinfoStr office:officeStr culture:cultureStr care:careStr benefits:benefitsStr prospects:prospectsStr leavegrade:leavegradeStr leaveinfo:leaveinfoStr success:^(id resultDic) {
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"提交成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
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
