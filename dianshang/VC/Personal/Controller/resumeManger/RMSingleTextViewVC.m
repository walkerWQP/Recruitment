//
//  RMSingleTextViewVC.m
//  dianshang
//
//  Created by yunjobs on 2017/11/13.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define zishu 2000

#import "RMSingleTextViewVC.h"
#import "UITextView+ZWPlaceHolder.h"

@interface RMSingleTextViewVC ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *wordNumLbl;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation RMSingleTextViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"完成" titleColor:[UIColor whiteColor] target:self action:@selector(saveClick:)];
    
    [self initView];
}

- (void)initView
{
    CGFloat w = APP_WIDTH;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, w, 300)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 45)];
    titlelabel.text = [self.navigationItem.title stringByAppendingString:@":"];
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:titlelabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_height-15)];
    textView.delegate = self;
    textView.backgroundColor = RGB(243, 243, 243);
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.cornerRadius = 5;
    [contentView addSubview:textView];
    _textView = textView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textView.yq_width-102, contentView.yq_height-20, 100, 20)];
    label.text = [NSString stringWithFormat:@"%ld/%d",self.text.length,zishu];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGB(102, 102, 102);
    label.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:label];
    self.wordNumLbl = label;
    
    textView.placeholder = self.placeholder;
    
    if (self.text.length > 0 || self.text != nil) {
        textView.text = self.text;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self.textView resignFirstResponder];
}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>zishu) {
        NSMutableString *a = [NSMutableString stringWithString:textView.text];
        self.textView.text = [a substringToIndex:zishu];
    }
    self.wordNumLbl.text = [NSString stringWithFormat:@"%d/%d",(int)textView.text.length,zishu];
}

- (void)saveClick:(UIButton *)sender
{
    if (!self.isSave) {
        [self reqSaveDesc];
    }else{
        NSString *desc = self.textView.text;
        
        if (desc.length == 0) {
            [YQToast yq_ToastText:@"请填写描述" bottomOffset:100];
        }else{
            if (self.textViewBlock) {
                [self.navigationController popViewControllerAnimated:YES];
                self.textViewBlock(desc);
            }
        }
    }
}

- (void)reqSaveDesc
{
    NSString *desc = self.textView.text;
    
    if (desc.length == 0) {
        [YQToast yq_ToastText:@"请填写描述" bottomOffset:100];
    }else{
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] saveDescription_uid:[UserEntity getUid] description:desc success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.textViewBlock) {
                    self.textViewBlock(desc);
                }
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}

//-(void)dealloc
//{
//    NSLog(@"%@",NSStringFromClass([self class]));
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end