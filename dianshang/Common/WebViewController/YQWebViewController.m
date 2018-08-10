//
//  YQWebViewController.m
//  kuainiao
//
//  Created by yunjobs on 16/9/22.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQWebViewController.h"


@interface YQWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIView *titleView;
@end

@implementation YQWebViewController

- (UILabel *)titleLable
{
    if (_titleLable == nil) {
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.font = [UIFont boldSystemFontOfSize:17];
        _titleLable = titleLbl;
    }
    return _titleLable;
}

- (UIView *)titleView
{
    if (_titleView == nil) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _titleView = titleView;
    }
    return _titleView;
}

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        _activityView.center = CGPointMake(self.titleView.yq_width*0.5, self.titleView.yq_height*0.5);
        [_activityView startAnimating];
    }
    return _activityView;
}

- (UIWebView *)myWebView
{
    if (_myWebView == nil) {
        _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
        _myWebView.delegate = self;
        [self.view addSubview:_myWebView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _myWebView.frame.size.width, 30)];
        //label.text = [NSString stringWithFormat:@"网页由http://www.kbird.top提供"];
        label.textColor = RGB(111, 116, 117);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [_myWebView insertSubview:label atIndex:0];
    }
    return _myWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
}

- (void)setNav
{
    self.navigationItem.titleView = self.titleView;
    
    [self.titleView addSubview:self.titleLable];
    
    [self.titleView addSubview:self.activityView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityView stopAnimating];
}

- (void)setWebTitle:(NSString *)webTitle
{
    _webTitle = webTitle;
    
    self.titleLable.text = webTitle;
    [self.titleLable sizeToFit];
    
    self.titleLable.center = CGPointMake(self.titleView.yq_width*0.5, self.titleView.yq_height*0.5);
    self.activityView.center = CGPointMake(self.titleLable.yq_x-self.activityView.yq_width*0.5-5, self.titleView.yq_height*0.5);
}

@end
