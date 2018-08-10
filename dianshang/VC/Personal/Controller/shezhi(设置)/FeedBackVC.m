//
//  FeedBackVC.m
//  kuainiao
//
//  Created by yunjobs on 16/4/26.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "FeedBackVC.h"
#import "LPlaceHolderTextView.h"

@interface FeedBackVC ()<UITextViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    LPlaceHolderTextView *text;
}
@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    
    [self initTextView];
}
#pragma mark -
#pragma mark TextView视图及提交按钮
-(void)initTextView
{
    text = [[LPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 150)];
    text.placeholder = @"请输入您宝贵的意见...";
    text.placeholderImg = @"";
    text.delegate = self;
    text.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:text];
    
    // 提交按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"提交" titleColor:RGB(200, 200, 200) target:self action:@selector(SubClick)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
//触摸背景隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [text resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.barButtonItemColor = [UIColor whiteColor];
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.barButtonItemColor = RGB(200, 200, 200);
    }
}

//提交按钮点击事件
-(void)SubClick
{
    NSString *str = [NSString stringWithFormat:@"%@",text.text];
    //NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    //NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
    
    if ([str isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈意见内容不可为空,请编辑内容之后再进行提交" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        //确认无误后提交到网络
        self.hud.labelText= @"正在提交...";
        
        [[RequestManager sharedRequestManager] feedback_uid:[UserEntity getUid] phones:[UserEntity getPhone] message:str success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您提交的建议,您的支持是我们不懈努力的动力!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self.hud show:YES];
//            [NSThread sleepForTimeInterval:1];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.hud hide:YES];
////                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
////                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finish.png"]];
////
////                HUD.mode = MBProgressHUDModeCustomView;
////                HUD.labelText = @"提交成功";
////                HUD.delegate = self;
////                [HUD show:YES];
////                [HUD hide:YES afterDelay:1];
////                [self.view addSubview:HUD];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您提交的建议,您的支持是我们不懈努力的动力!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//            });
//        });
    }
    
}
//- (void)hudWasHidden:(MBProgressHUD *)hud
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
