//
//  CSelectPositionController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CSelectPositionController.h"
#import "CPositionMangerEntity.h"
#import "CSelectPositionCell.h"

@interface CSelectPositionController ()

@end

@implementation CSelectPositionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择职位";
    
    
    [self initView];
    
    [self reqPositionList];
}

- (void)initView
{
    UINib *nib1 = [UINib nibWithNibName:@"CSelectPositionCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"CSelectPositionCell"];
    //self.tableView.yq_height = 50;
    [self.view addSubview:self.tableView];
    
//    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.tableView.yq_bottom+5, APP_WIDTH-40, 40)];
//    [quitBtn setBackgroundColor:THEMECOLOR forState:UIControlStateNormal];
//    [quitBtn setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
//    [quitBtn setTitle:@"发布职位" forState:UIControlStateNormal];
//    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    quitBtn.layer.cornerRadius = 4;
//    quitBtn.layer.masksToBounds = YES;
//    [quitBtn addTarget:self action:@selector(releaseClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:quitBtn];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSelectPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSelectPositionCell"];
    cell.indexx = indexPath.row;
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectBlock) {
        
        CPositionMangerEntity *en = [self.tableArr objectAtIndex:indexPath.row];
        if ([en.position_class_name isEqualToString:self.pName]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.selectBlock(en.position_class_name);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//- (void)releaseClick:(UIButton *)sender
//{
//    CReleasePositionController *vc = [[CReleasePositionController alloc] init];
//    YQWeakSelf;
//    vc.addEditBlock = ^(BOOL isAdd, CPositionMangerEntity *entity) {
//        if (isAdd) {
//            [weakSelf reqPositionList];
//        }
//    };
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - 网络请求

- (void)reqPositionList
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getCPositionList_uid:[UserEntity getUid] success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA];
            [self.tableArr removeAllObjects];
            
            for (NSDictionary *dict in list) {
                CPositionMangerEntity *en = [CPositionMangerEntity CPositionEntityWithDict:dict];
                if ([en.issue isEqualToString:@"1"]) {
                    if (self.pName.length > 0) {
                        if ([en.position_class_name isEqualToString:self.pName]) {
                            en.isSelect = YES;
                        }else{
                            en.isSelect = NO;
                        }
                    }else{
                        en.isSelect = NO;
                    }
                    [self.tableArr addObject:en];
                }
            }
            CPositionMangerEntity *en = [[CPositionMangerEntity alloc] init];
            en.isSelect = [self.pName isEqualToString:@"全部"];
            en.pname = @"全部";
            en.position_class_name = @"全部";
            //en.pname = @"全部";
            [self.tableArr insertObject:en atIndex:0];
            
            if (self.tableArr.count > 0) {
                [self.tableView reloadData];
            }
        }else if ([resultDic[CODE] isEqualToString:@"100003"]) {
            [self.tableArr removeAllObjects];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
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
