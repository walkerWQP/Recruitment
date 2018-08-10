//
//  WWebViewController.m
//  dianshang
//
//  Created by yunjobs on 2018/4/19.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "WWebViewController.h"
#import "WWebProgressLayer.h"
#import <WebKit/WebKit.h>

@interface WWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *WWebView;

@property (nonatomic, strong)WWebProgressLayer *webProgressLayer;

@end

@implementation WWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.webTitle;
    [self setUpUI];
}

- (void)setUpUI {
    
    self.WWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.WWebView.backgroundColor = RGB(239, 239, 239);
    self.WWebView.navigationDelegate =self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.WWebView loadRequest:request];
    [self.view addSubview:self.WWebView];
    
    
    self.webProgressLayer = [[WWebProgressLayer alloc] init];
    self.webProgressLayer.frame = CGRectMake(0, 42, APP_WIDTH, 2);
    self.webProgressLayer.strokeColor = self.progressColor.CGColor;
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
    
    
}



#pragma mark - UIWebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer w_startLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webProgressLayer w_finishedLoadWithError:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.webProgressLayer w_finishedLoadWithError:error];
    
}

- (void)dealloc {
    [self.webProgressLayer w_closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}



@end
