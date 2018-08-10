//
//  SharedViewController.m
//  dianshang
//
//  Created by yunjobs on 2018/4/13.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "SharedViewController.h"
#import "WebViewJavascriptBridge.h"

#import "UserInfo+CoreDataClass.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YQViewController+YQShareMethod.h"

@interface SharedViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIWebView   *webView;
@property (nonatomic, strong) NSString   *shareURL;
@property (nonatomic, strong) NSString   *shareTitle;
@property (nonatomic, strong) NSString   *shareMessage;
@property (nonatomic, strong) NSString   *shareImgurl;

@end

@implementation SharedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self prepareViews];
}

- (void)prepareViews {
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",H5BaseURL,EZNewRecrui,[UserEntity getUid]];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    // 3.开启日志
    [WebViewJavascriptBridge enableLogging];
    
    // 4.给webView建立JS和OC的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    
    /* JS调用OC的API:打开分享 */
    [self.bridge registerHandler:@"share" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        self.shareURL = data[@"url"];
        self.shareTitle = data[@"title"];
        self.shareMessage = data[@"message"];
        self.shareImgurl = data[@"imgurl"];
        
        [self shareView];
    }];
    
    [self.bridge registerHandler:@"close" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

- (NSMutableDictionary *)getShateParameters
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *shareUrlStr = [NSString stringWithFormat:@"%@",self.shareURL];
   
    NSURL    *ShareUrl = [NSURL URLWithString:shareUrlStr];
    
    // 通用参数设置
    
    NSLog(@"1     %@",self.shareTitle);
    NSLog(@"2     %@",self.shareImgurl);
    NSLog(@"3     %@",ShareUrl);
    NSLog(@"4     %@",self.shareMessage);
    
    [parameters SSDKSetupShareParamsByText:self.shareMessage
                                    images:self.shareImgurl
                                       url:ShareUrl
                                     title:self.shareTitle
                                      type:SSDKContentTypeAuto];
    return parameters;
}


- (void)viewWillAppear:(BOOL)animated {
    //    [SVProgressHUD show];
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //    [SVProgressHUD dismiss];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    self.hidesBottomBarWhenPushed = YES;
    NSString *urlString = request.URL.absoluteString;
    
    if ([urlString containsString:@"weixin://"]) {
        [[UIApplication sharedApplication]openURL:request.URL options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
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
