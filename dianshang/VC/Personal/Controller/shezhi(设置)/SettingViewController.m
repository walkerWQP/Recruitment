//
//  SettingViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "FeedBackVC.h"
#import "CommonProblemVC.h"

#import "JPushManager.h"
#import "PromptViewController.h"
#import "YQGuideManage.h"
#import "YQSaveManage.h"
#import "PersonItem.h"
#import "EaseUI.h"
#import <SDWebImage/SDImageCache.h>

@interface SettingViewController ()<UIActionSheetDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    [self setUpdata];
    
    [self initView];
}

- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    //    PersonItem *item1 = [PersonItem setCellItemImage:nil title:@"账户安全"];
    //    item1.pushController = [AccountViewController class];
    //    [items addObject:item1];
    
//    PersonItem *item2 = [PersonItem setCellItemImage:nil title:@"消息提醒"];
//    item2.pushController = [PromptViewController class];
//    [items addObject:item2];
    
//    PersonItem *item3 = [PersonItem setCellItemImage:@"person_about" title:@"关于我们"];
//    item3.pushController = [AboutViewController class];
//    [items addObject:item3];
    
//    PersonItem *item4 = [PersonItem setCellItemImage:nil title:@"常见问题"];
//    item4.pushController = [CommonProblemVC class];
//    [items addObject:item4];
    
    PersonItem *item5 = [PersonItem setCellItemImage:@"yijian" title:@"意见反馈"];
    item5.pushController = [FeedBackVC class];
    [items addObject:item5];
    
    PersonItem *item6 = [PersonItem setCellItemImage:@"person_cache" title:@"清除缓存"];
    YQWeakSelf;
    item6.operationBlock = ^{
        [weakSelf.hud show:YES];
        NSString * cachePath = [NSString stringWithFormat:@"%@/Library/Caches/com.hackemist.SDWebImageCache.default",NSHomeDirectory()];
        [weakSelf clearCache:cachePath];
    };
    item6.subTitle = [self getSize];
    [items addObject:item6];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:nil footerTitle:nil];
    
    if (self.groups.count>0) {
        [self.groups removeAllObjects];
    }
    
    [self.groups addObject:group];
}
- (NSString *)getSize
{
    //获取缓存图片的大小(字节)
    NSString * cachePath = [NSString stringWithFormat:@"%@/Library/Caches/com.hackemist.SDWebImageCache.default",NSHomeDirectory()];
    float bytesCache = [self folderSizeAtPath:cachePath];
    
    return [NSString stringWithFormat:@"%.1fM",bytesCache];
}
-(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1000.0/1000.0;
    }
    return 0;
}
-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        
        return folderSize;
    }
    return 0;
}
-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [self.hud hide:YES];
        [self setUpdata];
        [self.tableView reloadData];
    }];
}
- (void)initView
{
//        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"如有其他疑问,欢迎致电快鸟 400-5544 6655"];
//        [AttributedStr addAttribute:NSForegroundColorAttributeName value:THEMECOLOR range:NSMakeRange(14, 13)];
//        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.508 alpha:1.000] range:NSMakeRange(0, 14)];
//        [AttributedStr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://www.baidu.com"] range:NSMakeRange(14, 13)];
//    
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 35)];
//        label.attributedText = AttributedStr;
//        label.text = @"如有其他疑问,欢迎致电快鸟 400-5544 6655";
//        label.textColor = [UIColor colorWithWhite:0.508 alpha:1.000];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:13];
//        self.tableView.tableFooterView = label;
    
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, APP_HEIGHT-50-APP_NAVH-APP_BottomH, APP_WIDTH-40, 40)];
    [quitBtn setBackgroundColor:redBtnNormal forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:redBtnHighlighted forState:UIControlStateHighlighted];
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(quitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:quitBtn];
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YQTableViewCell *cell = [YQTableViewCell cellWithTableView:tableView tableViewCellStyle:YQTableViewCellStyleBgImage];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = item;
    
    return cell;
}

#pragma mark - 按钮事件

- (void)quitBtnClick:(UIButton *)sender
{
    //退出登录访问网络
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"退出" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 退出登录
        // 把密码清除
        NSDictionary *accountDic = [YQSaveManage objectForKey:MYACCOUNT];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:accountDic];
        [dict removeObjectForKey:@"password"];
        [YQSaveManage setObject:dict forKey:MYACCOUNT];
        // 清除用户信息
        [YQSaveManage removeObjectForKey:USERINFO];
        // 修改登录状态
        [YQSaveManage setObject:@"0" forKey:LOGINSTATUS];
        // 清除推送别名
        [[JPushManager shareJPushManager] setAlias:@"" resBlock:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        }];
        // 删除分享图片
        //[self deleteShareImage];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{            
            // 退出环信登录
            [[EMClient sharedClient].options setIsAutoLogin:NO];
            [[EMClient sharedClient] logout:YES];
        });
        

        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        keyWindow.rootViewController = [YQGuideManage chooseRootController];
    }
}


// 删除存在沙盒里的模糊头像
-(void)deleteShareImage
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"shareImage.png"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        CLog(@"no  have");
        return ;
    }else {
        CLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            CLog(@"dele success");
        }else {
            CLog(@"dele fail");
        }
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
