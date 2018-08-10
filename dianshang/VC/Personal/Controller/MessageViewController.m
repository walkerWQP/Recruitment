//
//  MessageViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"

#import "MessageEntity.h"

@interface MessageViewController ()<UIAlertViewDelegate>
{
    int pageCount;//分页数
    
    UIAlertView *allAlert;
    
    NSIndexPath *currentIndexPath;
}


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationItem.title = @"消息中心";
    
    //清空按钮
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"清空" titleColor:RGB(200, 200, 200) target:self action:@selector(rightPressed:)];
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self initView];
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}

#pragma mark - table

- (void)headerRereshing
{
    pageCount = 0;
    //访问网络
    [self messageList];
    
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing
{
    //上啦加载
    [self messageList];
    
    [self.tableView.mj_footer endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.mj_footer.hidden = self.tableArr.count == 0;
    //self.isShowNoMoreData = self.tableArr.count == 0;
    self.hintLabel.text = @"暂时没有相关消息";
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    
    //cell不能点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MessageEntity *en = [self.tableArr objectAtIndex:indexPath.row];
    cell.item = en;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageEntity *en = [self.tableArr objectAtIndex:indexPath.row];
    int h = [self yq_textHeight:en.message size:CGSizeMake(APP_WIDTH-20, MAXFLOAT) font:14].height;
    h = h < 25 ? 25 : h;
    return 41+h;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"确定要删除这一条消息吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        currentIndexPath = indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark ========清空按钮事件========

- (void)rightPressed:(UIButton *)sender
{
    allAlert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"确定要清空所有消息吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [allAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == allAlert) {
        //清空所有数据
        if (buttonIndex == 1) {
            //清空消息列表
            [self cleanList];
        }
    }else{
        //删除一条数据
        if (buttonIndex == 1) {
            
            [self deleteOneRow];
        }
    }
}

#pragma mark - 网络访问方法

#pragma mark ========获取网络数据(消息列表)========
- (void)messageList
{
    NSString *str = [NSString stringWithFormat:@"%d",++pageCount];
    [[RequestManager sharedRequestManager] getSitemsg_uid:[UserEntity getUid] page:str pagesize:KPageSize success:^(id resultDic) {
        [self endRereshingCustom];
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            //如果有消息就显示清空按钮
            //self.navigationItem.rightBarButtonItem.barButtonItemColor = [UIColor whiteColor];
            //self.navigationItem.rightBarButtonItem.enabled = YES;
            
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            NSArray *array = resultDic[DATA];
            //[EZPublicList printPropertyWithDict:array.firstObject];
            for (NSDictionary *dic in array) {
                MessageEntity *obj = [MessageEntity messageEntityWithDict:dic];
                [tempArr addObject:obj];
            }
            if (self.isPullDown) {
                self.tableArr = tempArr;
            }else{
                [self.tableArr addObjectsFromArray:tempArr];
            }
            if (tempArr.count<[KPageSize intValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }else if ([resultDic[CODE] isEqualToString:@"100003"]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)cleanList
{
//    [[RequestManager sharedRequestManager] truncateMsgUserid:[UserEntity uid] success:^(id resultDic) {
//        NSNumber *status = resultDic[STATUS];
//        if (![status isEqualToNumber:@-1]) {
//            [self.tableArr removeAllObjects];
//            [self.tableView reloadData];
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            [LToast showWithText:resultDic[INFO] bottomOffset:100];
//            //清空完之后隐藏清空按钮
//            self.navigationItem.rightBarButtonItem.barButtonItemColor = RGB(200, 200, 200);
//            self.navigationItem.rightBarButtonItem.enabled = NO;
//        }else{
//            [LToast showWithText:resultDic[INFO] bottomOffset:100];
//        }
//    } failure:^(NSError *error) {
//        [LToast showWithText:error.domain bottomOffset:100];
//    }];
}

- (void)deleteOneRow
{
//    MessageEntity *obj = [self.tableArr objectAtIndex:currentIndexPath.row];
//    NSArray *ids = @[obj.mesid];
    
//    [[RequestManager sharedRequestManager] delMsgUserid:[UserEntity uid] ids:ids success:^(id resultDic) {
//        NSNumber *status = resultDic[STATUS];
//        if (![status isEqualToNumber:@-1]) {
//            [self.tableArr removeObjectAtIndex:currentIndexPath.row];
//            
//            [self.tableView deleteRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            
//            [LToast showWithText:resultDic[INFO] bottomOffset:100];
//            if (self.tableArr.count==0) {
//                //清空完之后隐藏清空按钮
//                self.navigationItem.rightBarButtonItem.barButtonItemColor = RGB(200, 200, 200);
//                self.navigationItem.rightBarButtonItem.enabled = NO;
//            }
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }else{
//            [LToast showWithText:resultDic[INFO] bottomOffset:100];
//        }
//    } failure:^(NSError *error) {
//        [LToast showWithText:error.domain bottomOffset:100];
//    }];
}

- (CGSize)yq_textHeight:(NSString *)text size:(CGSize)size font:(NSInteger)font
{
    CGSize stringSize = CGSizeZero;
    if (text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringSize =[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                     context:nil].size;
#else
        
        stringSize = [text sizeWithFont:[UIFont systemFontOfSize:font]
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByCharWrapping];
#endif
    }
    return stringSize;
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
