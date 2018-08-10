//
//  SquarePageViewController.m
//  dianshang
//
//  Created by yunjobs on 2018/4/18.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "SquarePageViewController.h"
#import "WNavigationTabBar.h"
#import "DiscoverViewController.h"
#import "BusinessController.h"
#import "DiscoverTopicReleaseVC.h"
#import "YQNavigationController.h"
#import "YQGroupTableItem.h"
#import "EZCPersonCenterController.h"
#import "PersonalAuthController.h"

@interface SquarePageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) WNavigationTabBar *navigationTabBar;
@property (nonatomic, strong) NSArray<UIViewController *> *subViewControllers;
@property (nonatomic, strong) UIButton  *rightBut;

@end

@implementation SquarePageViewController

-(WNavigationTabBar *)navigationTabBar
{
    if (!_navigationTabBar) {
        self.navigationTabBar = [[WNavigationTabBar alloc] initWithTitles:@[@"职场",@"发现"]];
        __weak typeof(self) weakSelf = self;
        [self.navigationTabBar setDidClickAtIndex:^(NSInteger index){
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _navigationTabBar;
}

-(NSArray *)subViewControllers
{
    if (!_subViewControllers) {
        DiscoverViewController *controllerOne = [[DiscoverViewController alloc] init];
        controllerOne.view.backgroundColor = RGB(239, 239, 239);
        
        BusinessController *controllerTwo = [[BusinessController alloc] init];
        controllerTwo.view.backgroundColor = RGB(239, 239, 239);
        
        self.subViewControllers = @[controllerOne,controllerTwo];
    }
    return _subViewControllers;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.navigationTabBar;
    self.delegate = self;
    self.dataSource = self;
    
    [self setViewControllers:@[self.subViewControllers.firstObject]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    
    self.rightBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [self.rightBut setBackgroundImage:[UIImage imageNamed:@"discover_release"] forState:UIControlStateNormal];
    [self.rightBut addTarget:self action:@selector(rightBtnSelector:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBut];
    
}

#pragma mark - 点击事件
- (void)rightBtnSelector : (UIButton *)sender {
    NSLog(@"点击发布");
    
    NSInteger flag = 0;
    if ([UserEntity getIsCompany]) {
        NSInteger auth = [[UserEntity getRealAuth] integerValue];
        if (auth == 1) {
            flag = 1;
        }else if (auth == 2 || auth == 0){
            //去认证
            [self goAuth];
        }else if (auth == 3){
            // 等待审核
            [self waitExamine];
        }
    }else{
        NSInteger auth = [[UserEntity getRealAuth] integerValue];
        if (auth == 1) {
            flag = 1;
        }else if (auth == 2 || auth == 0){
            //去认证
            [self goAuth];
        }else if (auth == 3){
            // 等待审核
            [self waitExamine];
        }
    }
    
    
    if (flag == 1) {
        // 发布新话题
        DiscoverTopicReleaseVC *vc = [[DiscoverTopicReleaseVC alloc] init];
//        if (curTableIndex == 0) {
            vc.isdefault = @"2";// 职场
            vc.navigationItem.title = @"发职场动态";
            vc.placeholder = @"分享有价值的职场内容,为你的职业竞争力加分";
//        }else{
//            vc.navigationItem.title = @"发合伙人动态";
//            vc.placeholder = @"分享有价值的职场内容,为你的职业竞争力加分";
//            vc.isdefault = @"1";// 合伙人
//        }
        
        YQWeakSelf;
        vc.releaseSuccessBlock = ^(NSString *text) {
//            [weakSelf headerRereshing];;
        };
//        YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//- (void)headerRereshing
//{
//    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
//    item.pageCount = 1;
//    NSString *isdefault = @"1";// 合伙人
//    if (curTableIndex == 0) {
//        isdefault = @"2";// 职场
//    }
//    [self reqWorkplaceList:[NSString stringWithFormat:@"%li",item.pageCount] isdefault:isdefault];
//}

- (void)goAuth
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"根据国家互联网政策规定要求请先进行实名认证，方能在职场社交中发布相关话题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)waitExamine
{
    [YQToast yq_AlertText:@"您的资料正在审核中,请耐心等待"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            if ([UserEntity getIsCompany]) {
                EZCPersonCenterController *vc = [[EZCPersonCenterController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                PersonalAuthController *vc = [[PersonalAuthController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}


#pragma mark - UIPageViewControllerDelegate
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.subViewControllers indexOfObject:viewController];
    if(index == 0 || index == NSNotFound) {
        return nil;
    }
    
    return [self.subViewControllers objectAtIndex:index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.subViewControllers indexOfObject:viewController];
    if(index == NSNotFound || index == self.subViewControllers.count - 1) {
        return nil;
    }
    return [self.subViewControllers objectAtIndex:index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    UIViewController *viewController = self.viewControllers[0];
    NSUInteger index = [self.subViewControllers indexOfObject:viewController];
    [self.navigationTabBar scrollToIndex:index];
    
}


#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    [self setViewControllers:@[[self.subViewControllers objectAtIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    NSLog(@"aaaaaa%@",[NSString stringWithFormat:@"%ld",(long)index]);
    
    switch (index) {
        case 0:
            NSLog(@"第一个页面,显示发布按钮");
            self.rightBut.hidden = NO;
            break;
            case 1:
            NSLog(@"第二个页面, 不显示发布按钮");
            self.rightBut.hidden = YES;
            break;
            
        default:
            break;
    }
    
    
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
