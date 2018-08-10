//
//  EnclosureViewController.m
//  dianshang
//
//  Created by yunjobs on 2018/2/1.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "EnclosureViewController.h"
#import "NSString+MyDate.h"
#import "ResumeManageEntity.h"
#import "BusinessDetailController.h"

@interface EnclosureViewController ()

@end

@implementation EnclosureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"上传附件简历";
   
    if ([self.rmEntity.is_asset isEqualToString:@"1"]) {
        [self alreadyUpload];
    }else{
        [self notUpload];
    }
}
- (void)notUpload
{
    UIView *notView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_BottomH-APP_NAVH)];
    [self.view addSubview:notView];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    iconImg.center = CGPointMake(APP_WIDTH*0.5, 100);
    iconImg.image = [UIImage imageNamed:@"uploadresume"];
    iconImg.contentMode = UIViewContentModeScaleAspectFit;
    [notView addSubview:iconImg];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, iconImg.yq_bottom+15, APP_WIDTH-30, 25)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"用电脑浏览器打开网址:";
    titleLbl.textColor = RGB(51, 51, 51);
    titleLbl.font = [UIFont systemFontOfSize:15];
    [notView addSubview:titleLbl];
    
    UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLbl.yq_bottom, APP_WIDTH-30, 45)];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    timeLbl.text = [NSString stringWithFormat:@"http://hr-ez.com/index/r"];
    timeLbl.textColor = RGB(51, 51, 51);
    timeLbl.font = [UIFont systemFontOfSize:20];
    [notView addSubview:timeLbl];
    
    UIButton *rebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH-30, 40)];
    rebutton.center = CGPointMake(APP_WIDTH*0.5, APP_HEIGHT-APP_NAVH-APP_BottomH-80);
    [rebutton addTarget:self action:@selector(alreadyUploadClick:) forControlEvents:UIControlEventTouchUpInside];
    [rebutton setTitle:@"已上传" forState:UIControlStateNormal];
    [rebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rebutton setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [rebutton setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    rebutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [notView addSubview:rebutton];
}
- (void)alreadyUpload
{
    UIView *alreadyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_BottomH-APP_NAVH)];
    [self.view addSubview:alreadyView];
    
    NSDictionary *assetDict = self.rmEntity.asset;
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    iconImg.center = CGPointMake(APP_WIDTH*0.5, 100);
    iconImg.image = [UIImage imageNamed:@"uploadresume"];
    [alreadyView addSubview:iconImg];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, iconImg.yq_bottom+15, APP_WIDTH-30, 25)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = [assetDict objectForKey:@"filename"];
    titleLbl.textColor = RGB(51, 51, 51);
    titleLbl.font = [UIFont systemFontOfSize:15];
    [alreadyView addSubview:titleLbl];
    
    NSString *timestr = [assetDict objectForKey:@"uploadtime"];
    UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLbl.yq_bottom, APP_WIDTH-30, 25)];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    timeLbl.text = [NSString timeStampToString:timestr formatter:YYYYMMddHHmmss];
    timeLbl.textColor = RGB(51, 51, 51);
    timeLbl.font = [UIFont systemFontOfSize:13];
    [alreadyView addSubview:timeLbl];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    button.center = CGPointMake(APP_WIDTH*0.5, timeLbl.yq_bottom+40);
    [button addTarget:self action:@selector(previewClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"在线预览" forState:UIControlStateNormal];
    [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [alreadyView addSubview:button];
    
    UIButton *rebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH-30, 40)];
    rebutton.center = CGPointMake(APP_WIDTH*0.5, APP_HEIGHT-APP_NAVH-APP_BottomH-80);
    [rebutton addTarget:self action:@selector(reUploadClick:) forControlEvents:UIControlEventTouchUpInside];
    [rebutton setTitle:@"重新上传" forState:UIControlStateNormal];
    [rebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rebutton setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
    [rebutton setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    rebutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [alreadyView addSubview:rebutton];
}
- (void)reUploadClick:(UIButton *)sender
{
    [[sender superview] removeFromSuperview];
    
    [self notUpload];
    
}
- (void)alreadyUploadClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.refreshUI) {
        self.refreshUI();
    }
}
- (void)previewClick
{
    NSDictionary *assetDict = self.rmEntity.asset;
    
    BusinessDetailController *detail = [[BusinessDetailController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.urlStr = [NSString stringWithFormat:@"%@%@",ImageURL,[assetDict objectForKey:@"filepath"]];
    detail.webTitle = @"预览";
    [self.navigationController pushViewController:detail animated:YES];
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
