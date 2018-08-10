//
//  YQNavigationController.m
//  kuainiao
//
//  Created by yunjobs on 16/5/18.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQNavigationController.h"
#import "UIImage+colorImage.h"

@interface YQNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YQNavigationController

+ (void)load
{
    // 获取当前整个应用程序下的所有导航条的外观
    //    UINavigationBar *navBar = [UINavigationBar appearance];
    // 只影响当前类下面的导航条
    // 获取当前类下面的导航条
    UINavigationBar *navbar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    [navbar setBackgroundImage:[UIImage imageWithColor:THEMECOLOR] forBarMetrics:UIBarMetricsDefault];
    
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    navbar.titleTextAttributes = mDict;
    
    //去掉黑线
    [navbar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 在iOS7之后,导航控制器自动添加了滑动返回功能,手指往右边滑动,就能回到上一个控制器
    // 注意:如果覆盖系统的返回按钮,滑动返回功能就失效.
    // 恢复滑动返回功能
    // 想回到导航控制器的根控制器的时候,恢复滑动手势代理,目的:解决假死状态
    //self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - 给push方法扩充功能
// 想在push的时候,设置下一个栈顶控制器的导航条的左边按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    if ([viewController isKindOfClass:NSClassFromString(@"SearchViewController")]||[viewController isKindOfClass:NSClassFromString(@"WhiteListQueryController")]||[viewController isKindOfClass:NSClassFromString(@"CompanySearchController")]||[viewController isKindOfClass:NSClassFromString(@"AddCompanyMemberVC")]) {
        // 有的页面不需要设置返回按钮,在这处理
        return;
    }
    // 不是导航控制器的根控制器才需要设置返回按钮
    if (self.viewControllers.count > 1) {
        
        if (IOS_VERSION_11_OR_ABOVE) {
            UIButton *rightButn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButn setImage:[UIImage imageWithOriginalImageName:@"back"] forState:UIControlStateNormal];
            [rightButn setImage:[UIImage imageWithOriginalImageName:@"back"] forState:UIControlStateHighlighted];
            [rightButn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
            rightButn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            rightButn.yq_width = 80;
            
            UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:rightButn];
            viewController.navigationItem.leftBarButtonItem = back;
        }else{
            UIBarButtonItem *back = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" target:self action:@selector(leftBtnClick)];
            viewController.navigationItem.leftBarButtonItem = back;
        }
    }
}

- (void)leftBtnClick
{
    [self popViewControllerAnimated:YES];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    UIViewController *vc = [super popViewControllerAnimated:animated];
//    if ([NSStringFromClass([vc class]) isEqualToString:@"ShouZhiViewController"]) {
//        UINavigationBar *navbar = vc.navigationController.navigationBar;
//        [navbar setBackgroundImage:[UIImage imageWithColor:THEMECOLOR] forBarMetrics:UIBarMetricsDefault];
//    }
//    return vc;
//}

#pragma mark -UIGestureRecognizerDelegate
// 触发滑动返回手势就调用
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // self.childViewControllers.count > 1 根控制器不需要使用手势返回NO
    return self.childViewControllers.count > 1;
}

@end
