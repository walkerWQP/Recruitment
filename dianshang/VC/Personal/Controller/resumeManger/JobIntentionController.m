//
//  JobIntentionController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "JobIntentionController.h"
#import "ResumeManageController.h"

#import "JobIntentionCell.h"

#import "RMAddEditJobIntention.h"
#import "RMExpectindustryEntity.h"

#import "KNActionSheet.h"

#import "WAlertView.h"

@interface JobIntentionController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, assign) NSInteger status;//当前的求职状态
@property (nonatomic, strong) NSArray *stateArray;
@property (nonatomic, strong) WAlertView *WalertView;

@end

@implementation JobIntentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"管理求职意向";
    NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getJobIntentionStateList]];
    [array removeObjectAtIndex:0];
    self.stateArray = array;
    
    self.tableView.tableHeaderView = [self headView];
    UINib *nib1 = [UINib nibWithNibName:@"JobIntentionCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"JobIntentionCell"];
    [self.view addSubview:self.tableView];
    
    if (self.hopworkList) {
        self.tableArr = self.hopworkList;
        [self.tableView reloadData];
        
        [self setNav];
    }else{
        [self reqHopwork];
    }
}

- (void)setNav
{
    if (self.tableArr.count < 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"添加求职意向" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    }
}

- (UIView *)headView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.yq_height-1, APP_WIDTH, 1)];
    lineView.backgroundColor = RGB(239, 239, 239);
    [view addSubview:lineView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headviewTapClick:)];
    [view addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"back_right"];
    [view addSubview:imageView];
    imageView.center = CGPointMake(view.yq_width-20, view.yq_height*0.5);
    
    UILabel *footView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, view.yq_height)];
    footView.textColor = [UIColor colorWithWhite:0.508 alpha:1.000];
    footView.textAlignment = NSTextAlignmentLeft;
    footView.font = [UIFont systemFontOfSize:14];
    footView.text = @"求职状态";
    [view addSubview:footView];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.yq_width-30-100, 0, 100, view.yq_height)];
    stateLabel.textColor = THEMECOLOR;
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:stateLabel];
    self.stateLabel = stateLabel;
    self.stateLabel.text = [self.stateArray objectAtIndex:0];
    
    NSString *state = [UserEntity getJobStatus];
    self.status = [state integerValue];
    self.stateLabel.text = [self.stateArray objectAtIndex:self.status-1];
    
    return view;
}
- (void)headviewTapClick:(UIGestureRecognizer *)sender
{
    YQWeakSelf;
    KNActionSheet *actionsSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:self.stateArray actionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex != -1) {
            [weakSelf changeStatus:buttonIndex];
        }
    }];
    [actionsSheet show];
}
- (void)changeStatus:(NSInteger)buttonIndex
{
    if (self.status != buttonIndex+1) {
        [self.hud show:YES];
        NSString *status = [NSString stringWithFormat:@"%li",buttonIndex+1];
        [[RequestManager sharedRequestManager] saveRestatus_uid:[UserEntity getUid] restatus:status success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                self.stateLabel.text = self.stateArray[buttonIndex];
                self.status = buttonIndex+1;
                [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
                // 保存到本地
                [UserEntity setJobStatus:status];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}
- (void)rightClick:(UIButton *)sender
{
    if ([[UserEntity getEdu] isEqualToString:@""] || [[UserEntity getBrithDay] isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请先去完善简历" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去完善", nil];
        alert.tag = 1000;
        [alert show];
        
    }else{
        
        RMAddEditJobIntention *vc = [[RMAddEditJobIntention alloc] init];
        YQWeakSelf;
        vc.addEditBlock = ^(BOOL isAdd, RMJobIntentionEntity *entity) {
            if (isAdd) {
                self.navigationItem.rightBarButtonItem.customView.hidden = YES;
            }
            [weakSelf reqHopwork];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            if (self.isback) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                ResumeManageController *vc = [[ResumeManageController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobIntentionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JobIntentionCell"];
    
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RMJobIntentionEntity *entity = [self.tableArr objectAtIndex:indexPath.row];
    RMAddEditJobIntention *vc = [[RMAddEditJobIntention alloc] init];
    vc.entity = entity;
    vc.isDelBtn = self.tableArr.count > 1;
    YQWeakSelf;
    vc.addEditBlock = ^(BOOL isAdd, RMJobIntentionEntity *entity) {
        [weakSelf reqHopwork];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络请求

- (void)reqHopwork
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] gethopwork_uid:[UserEntity getUid] success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            // 设置求职状态
            NSString *state = resultDic[@"restatus"];
            self.status = [state integerValue];
            self.stateLabel.text = [self.stateArray objectAtIndex:self.status-1];
            // 保存到本地
            [UserEntity setJobStatus:state];
            
            if (self.tableArr.count > 0) {
                [self.tableArr removeAllObjects];
            }
            
            for (NSDictionary *dict in resultDic[DATA]) {
                
                RMJobIntentionEntity *en = [RMJobIntentionEntity JobIntentionEntity:dict];
                
                [self.tableArr addObject:en];
            }
            
            [self.tableView reloadData];
            [self setNav];
            
            if (self.hopworkList) {
                self.hopworkList = self.tableArr;
                if (self.jobIntentionBlock) {
                    self.jobIntentionBlock();
                }
            }
            
        }else if ([resultDic[CODE] isEqualToString:@"100003"]){
            [self.tableArr removeAllObjects];
            [self.tableView reloadData];
            [self setNav];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}


//-(void)dealloc
//{
//    NSLog(@"%@",NSStringFromClass([self class]));
//}



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
