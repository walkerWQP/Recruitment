//
//  AboutViewController.m
//  kuainiao
//
//  Created by yunjobs on 16/4/2.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "AboutViewController.h"
#import "ServiceAgreementVC.h"//服务协议
#import "CommonProblemVC.h"//常见问题
#import "FeedBackVC.h"//意见反馈

#import "PersonItem.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于";
    
    [self setUpdata];
    
    [self initView];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
//    PersonItem *item1 = [PersonItem setCellItemImage:nil title:@"用户注册认证及服务合作协议"];
//    item1.pushController = [ServiceAgreementVC class];
//    [items addObject:item1];
//
//    PersonItem *item2 = [PersonItem setCellItemImage:nil title:@"常见问题"];
//    item2.pushController = [CommonProblemVC class];
//    [items addObject:item2];
//
//    PersonItem *item3 = [PersonItem setCellItemImage:nil title:@"意见反馈"];
//    item3.pushController = [FeedBackVC class];
//    [items addObject:item3];
    
    PersonItem *item4 = [PersonItem setCellItemImage:nil title:@"给我评分"];
    item4.operationBlock = ^(){
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1111762626&pageNumber=0&sortOrdering=2&mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    };
    [items addObject:item4];
    
    //获取版本号
    NSString *versonStr = nil;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    versonStr = [NSString stringWithFormat:@"当前版本号 V%@",dic[@"CFBundleShortVersionString"]];
    //或者
    versonStr = [NSString stringWithFormat:@"当前版本号 V%@",[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:versonStr];
    
    [self.groups addObject:group];
}

- (void)initView
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 15)];
    [self.view addSubview:self.tableView];
}

#pragma mark - table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

@end
