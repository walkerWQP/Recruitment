//
//  WhiteListQueryController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/1.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "WhiteListQueryController.h"
#import "WhiteListCell.h"
#import "WhiteListEntity.h"

#import "NSString+RegularExpression.h"
@interface WhiteListQueryController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSString *wid;
@property (nonatomic, strong) UITextField *searchTF;
@end

@implementation WhiteListQueryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 在YQNavigationController中隐藏返回按钮
    [self.navigationItem setHidesBackButton:YES];
    self.fd_interactivePopDisabled = YES;
    
    [self initTitleView];
    [self initView];
    
}
- (void)initTitleView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH-10, 44)];
    self.navigationItem.titleView = view;
    
    UITextField *textfield = [[UITextField alloc] init];
    textfield.frame = CGRectMake(0, (view.yq_height-32)*0.5, view.yq_width-50-8, 32);
    textfield.backgroundColor = RGB(241, 241, 241);
    textfield.layer.cornerRadius = textfield.yq_height*0.5;
    textfield.layer.masksToBounds = YES;
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
    UIImageView *leftV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 15, 15)];
    leftV.image = [UIImage imageNamed:@"search"];
    [View addSubview:leftV];
    textfield.leftView = View;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    //textfield.keyboardType = UIKeyboardTypeNumberPad;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.placeholder = @"请输入推荐人注册手机号";
    textfield.font = [UIFont systemFontOfSize:14];
    textfield.returnKeyType = UIReturnKeySearch;
    textfield.delegate = self;
    [view addSubview:textfield];
    self.searchTF = textfield;
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(textfield.yq_right+4, 0, 50, view.yq_height)];
    [queryBtn setTitle:@"取消" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [queryBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    queryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:queryBtn];
}

- (void)initView
{
    UINib *nib = [UINib nibWithNibName:@"WhiteListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WhiteListCell"];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhiteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhiteListCell"];
    cell.entity = [self.tableArr objectAtIndex:indexPath.row];
    cell.isAddBtn = YES;
    YQWeakSelf;
    cell.addBtnBlock = ^(NSIndexPath *indexPath, WhiteListEntity *entity) {
        [weakSelf addWhiteList:indexPath entity:entity];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text checkPhoneNum]) {
        [self reqWhiteListQuery:textField.text];
        //[textField resignFirstResponder];
    }else{
        [YQToast yq_ToastText:@"请输入正确的手机号码" bottomOffset:100];
    }
    return YES;
}
- (void)addWhiteList:(NSIndexPath *)path entity:(WhiteListEntity *)entity
{
    self.wid = entity.itemId;
    NSString *str = [NSString stringWithFormat:@"确定添加 %@ 为你的招聘顾问?\n添加成功后 %@ 就可以为您推荐工作了",entity.name,entity.name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self reqWhiteListAdd:self.wid];
    }
}

- (void)reqWhiteListAdd:(NSString *)wid
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] whiteListAdd_uid:[UserEntity getUid] wid:wid success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"添加成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.refreshTableBlock) {
                self.refreshTableBlock();
            }
            
        } else if ([resultDic[CODE] isEqualToString:@"100002"]){
            [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)reqWhiteListQuery:(NSString *)phone
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] whiteListQuery_uid:[UserEntity getUid] phone:phone success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSDictionary *dict = resultDic[DATA];
            
            [self.tableArr removeAllObjects];
            
            WhiteListEntity *en = [WhiteListEntity WhiteListEntityWithDict:dict];
            
            [self.tableArr addObject:en];
            [self.tableView reloadData];
            
            [self.searchTF resignFirstResponder];
            
        }else if ([resultDic[CODE] isEqualToString:@"100003"]) {
            [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)cancelClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
