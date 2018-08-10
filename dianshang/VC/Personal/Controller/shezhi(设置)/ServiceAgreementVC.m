//
//  ServiceAgreementVC.m
//  kuainiao
//
//  Created by yunjobs on 16/4/23.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "ServiceAgreementVC.h"

@interface ServiceAgreementVC ()<UIWebViewDelegate>

@end

@implementation ServiceAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webTitle = @"服务协议";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/public/xieyi.html",H5BaseURL]];
//    NSURL *url = [NSURL URLWithString:@"http://39.106.152.66/data/upload/portal/20180201/5a7276b995a67.txt"];
//    NSURL *url = [NSURL URLWithString:@"http://39.106.152.66/data/upload/portal/20180201/test.docx"];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
