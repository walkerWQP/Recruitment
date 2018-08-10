//
//  EZCPersonCenterController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EZCPersonCenterController.h"
#import "CompanyAuthSelectController.h"
#import "MyCompanyController.h"
#import "CompanyMemberController.h"

#import "KNActionSheet.h"
#import "YQBrithDayView.h"
#import "YQDataPickerView.h"
#import "NSString+YQWidthHeight.h"
#import "NSString+MyDate.h"
#import "EZCPersonCenterEntity.h"
#import "ResumeManageEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EZCPersonCenterController ()<UIAlertViewDelegate>
{
    UIView *headView;
}

@property (nonatomic, strong) NSArray *educationClassArray;// 学历分类数组
//@property (nonatomic, strong) NSArray *licenseClassArray;// 执照分类数组

@property (nonatomic, strong) YQDataPickerView *ageView;// 出生年月
@property (nonatomic, strong) YQDataPickerView *workingView;// 工作年份

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *wechatid;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *postName;
// brithDay
@property (nonatomic, strong) YQBrithDayView *startView;

@property (nonatomic, strong) EZCPersonCenterEntity *detailEntity;

@end

@implementation EZCPersonCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"企业信息";
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getEducationList]];
    [array removeObjectAtIndex:0];
    self.educationClassArray = array;
    
    [self reqPersonInfo];
    
}
- (void)goCompany
{
    MyCompanyController *vc = [[MyCompanyController alloc] init];
    vc.entity = self.detailEntity;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goCompanyPerson
{
    CompanyMemberController *vc = [[CompanyMemberController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goAuth
{
    CompanyAuthSelectController *vc = [[CompanyAuthSelectController alloc] init];
    vc.entity = self.detailEntity;
    YQWeakSelf;
    vc.finishBlock = ^{
        [weakSelf setUpdata];
        [weakSelf.tableView reloadData];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpdata
{
    if (self.groups.count>0) {
        [self.groups removeAllObjects];
    }
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    YQCellItem *item2 = [YQCellItem setCellItemImage:nil title:@"手机号"];
    item2.subTitle = [UserEntity getPhone];
    [mArr addObject:item2];
    YQWeakSelf;
    YQCellItem *item0 = [YQCellItem setCellItemImage:nil title:@"姓名"];
    item0.subTitle = [UserEntity getNickName];
    item0.operationBlock = ^{
        [weakSelf changeName];
    };
    [mArr addObject:item0];
    
    YQCellItem *item6 = [YQCellItem setCellItemImage:nil title:@"微信号"];
    item6.subTitle = [UserEntity getWechatid].length > 0 ? [UserEntity getWechatid] : @"填写微信号";
    [mArr addObject:item6];
    item6.operationBlock = ^{
        [weakSelf changeWXid];
    };
    YQCellItem *item7 = [YQCellItem setCellItemImage:nil title:@"接收简历邮箱"];
    item7.subTitle = [UserEntity getEmail].length > 0 ? [UserEntity getEmail] : @"填写邮箱";
    [mArr addObject:item7];
    item7.operationBlock = ^{
        [self changeEmail];
    };
    
    YQGroupCellItem *group1 = [YQGroupCellItem setGroupItems:mArr headerTitle:@"   个人资料" footerTitle:nil];
    [self.groups addObject:group1];
    
    NSMutableArray *mArr1 = [[NSMutableArray alloc] init];
    NSInteger auth = [[UserEntity getRealAuth] integerValue];
    auth = 1;
    
    if (auth == 1) {
        YQCellItem *item5 = [YQCellItem setCellItemImage:nil title:@"我的公司"];
        item5.subTitle = self.detailEntity.companyEn.cname;
        item5.operationBlock = ^{
            [weakSelf goCompany];
        };
        [mArr1 addObject:item5];
    }
    
    YQCellItem *item8 = [YQCellItem setCellItemImage:nil title:@"我的职务"];
    item8.subTitle = [UserEntity getPostName].length > 0 ? [UserEntity getPostName] : @"填写我在公司的职务";
    [mArr1 addObject:item8];
    item8.operationBlock = ^{
        [self changePostName];
    };
    
    if ([[UserEntity getCompanyPerson] isEqualToString:@"1"] && auth == 1) {
        PersonItem *item3 = [PersonItem setCellItemImage:@"person_about" title:@"公司招聘成员管理"];
        item3.operationBlock = ^{
            [weakSelf goCompanyPerson];
        };
        [mArr1 addObject:item3];
    }
//    if ([[UserEntity getCompanyPerson] isEqualToString:@"1"] || [[UserEntity getCompanyPerson] isEqualToString:@"1"]) {
//
//    }
    YQCellItem *item3 = [YQCellItem setCellItemImage:nil title:@"认证E招身份"];
    
    if (auth == 1) {
        item3.subTitle = @"已认证";
    }else if (auth == 2){
        item3.subTitle = @"未认证";
        item3.operationBlock = ^{
            [weakSelf goAuth];
        };
    }else if (auth == 3){
        item3.subTitle = @"审核中";
    }
    [mArr1 addObject:item3];
    
    YQGroupCellItem *group2 = [YQGroupCellItem setGroupItems:mArr1 headerTitle:@" " footerTitle:nil];
    [self.groups addObject:group2];
    
}

- (void)initView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick:)];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addGestureRecognizer:tap];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.yq_bottom-3, APP_WIDTH, 3)];
    lineView.backgroundColor = RGB(243, 243, 243);
    [headView addSubview:lineView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:headView.bounds];
    label.text = @"    头像";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    [headView addSubview:label];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH-80, (80-65)/2, 65, 65)];
    NSString *avatar = [UserEntity getHeadImgUrl];
    [image sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"headImg"]];
    image.tag = -1;
    [headView addSubview:image];
    image.layer.cornerRadius = image.frame.size.height/2;
    image.layer.masksToBounds = YES;
    self.headImageView = image;
    
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:self.tableView];
}
#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    
    if (item.operationBlock != nil) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    if (item.operationBlock) {
        item.operationBlock();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 8;
    }
    return 30;
}

#pragma mark - 事件
//点击头像选择图库还是拍照
- (void)headTapClick:(UIGestureRecognizer *)sender
{
    self.isClip = YES;//表示需要裁剪
    [self openActionSheet:YQClipTypeSquare];
}

- (void)uploadImage:(UIImage *)originImage filePath:(NSString *)filePath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 显示
    self.headImageView.image = originImage;
    
    // 保存图片到数组
    NSData *imageData = UIImagePNGRepresentation(originImage);
    [self changePersonInfo_headImg:imageData];
}

- (void)changeEmail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"填写邮箱" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1003;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"填写邮箱";
    tf.text = [UserEntity getEmail];
}
- (void)changeWXid
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"填写微信号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1002;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"填写微信号";
    tf.text = [UserEntity getWechatid];
}
- (void)changePhone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改手机号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"修改手机号";
    tf.text = [UserEntity getPhone];
}
- (void)changePostName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改我的职务" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1004;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"修改我的职务";
    tf.text = [UserEntity getPostName];
}
- (void)changeName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1000;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"修改昵称";
    tf.text = [UserEntity getNickName];
}
- (void)changeBriefIntroduction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"编辑简介" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1001;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"填写简介";
    NSString *s = @"";//[UserEntity getSynopsis];
    tf.text = [s isEqualToString:@""]||s==nil ? @"一句话描述自己" : s;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        // 昵称
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            self.nickName = tf.text;
            if (tf.text.length>0) {
                [self changePersonInfo_nickname:tf.text];
            }
        }
    }else if (alertView.tag == 1001){
        // 简介
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            self.introduction = tf.text;
            if (tf.text.length>0) {
                [self changePersonInfo_Desc:tf.text];
            }
        }
    }else if (alertView.tag == 1002){
        // 微信号
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            self.wechatid = tf.text;
            if (tf.text.length>0) {
                [self changePersonInfo_Wechatid:tf.text];
            }
        }
    }else if (alertView.tag == 1003){
        // 邮箱
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            self.email = tf.text;
            if (tf.text.length>0) {
                [self changePersonInfo_Email:tf.text];
            }
        }
    }else if (alertView.tag == 1004){
        // 邮箱
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            self.postName = tf.text;
            if (tf.text.length>0) {
                [self changePersonInfo_PostName:tf.text];
            }
        }
    }
}
- (void)changePersonInfo_PostName:(NSString *)postname
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] changeCPersonInfo_uid:[UserEntity getUid] name:@"" post:postname wechatid:@"" team:@"" email:@"" avatar:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
            [UserEntity setPostName:self.postName];
            [self setUpdata];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)changePersonInfo_nickname:(NSString *)nickname
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] changeCPersonInfo_uid:[UserEntity getUid] name:nickname post:@"" wechatid:@"" team:@"" email:@"" avatar:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
            [UserEntity setNickName:self.nickName];
            [self setUpdata];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)changePersonInfo_Desc:(NSString *)desc
{
    //    [self.hud show:YES];
    //    [[RequestManager sharedRequestManager] changePersonalInfo_uid:[UserEntity getUid] nickName:[UserEntity getNickName] introduction:desc headimg:nil progressBlock:nil success:^(id resultDic) {
    //        [self.hud hide:YES];
    //        if ([resultDic[STATUS] isEqualToString:SUCCESS]) {
    //            [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
    //            [UserEntity setSynopsis:self.introduction];
    //            [self setUpdata];
    //            [self.tableView reloadData];
    //        }
    //    } failure:nil];
}
- (void)changePersonInfo_Wechatid:(NSString *)wxid
{
    [[RequestManager sharedRequestManager] changeCPersonInfo_uid:[UserEntity getUid] name:@"" post:@"" wechatid:wxid team:@"" email:@"" avatar:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
            [UserEntity setWechatid:wxid];
            [self setUpdata];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)changePersonInfo_Email:(NSString *)email
{
    [[RequestManager sharedRequestManager] changeCPersonInfo_uid:[UserEntity getUid] name:@"" post:@"" wechatid:@"" team:@"" email:email avatar:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
            [UserEntity setEmail:email];
            [self setUpdata];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
// 修改头像
- (void)changePersonInfo_headImg:(NSData *)headImg
{
    [self.slideView show:YES];
    [[RequestManager sharedRequestManager] uploadImage_uid:[UserEntity getUid] headimg:headImg progressBlock:^(CGFloat f) {
        self.slideView.progress = f;
    } success:^(id resultDic) {
        [self.slideView hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSDictionary *dict = resultDic[DATA];
            [UserEntity setHeadImgUrl:[dict objectForKey:@"file"]];
            //self.rmEntity.avatar = [dict objectForKey:@"file"];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
    
    //[self.slideView show:YES];//self.slideView.progress = f;
    //    NSString *avatar = @"";
    //    [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:avatar name:@"" sex:@"" birthday:@"" wechatid:@"" restatus:@"" success:^(id resultDic) {
    //
    //    } failure:nil];
}
//-(void)dealloc
//{
//    NSLog(@"%@",NSStringFromClass([self class]));
//}

#pragma mark - 网络请求

- (void)reqPersonInfo
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getCPersonCenter_uid:[UserEntity getUid] success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            EZCPersonCenterEntity *en = [EZCPersonCenterEntity entityWithDict:resultDic[@"data"]];
            self.detailEntity = en;
            
            [UserEntity setPhone:en.phone];
            [UserEntity setNickName:en.name];
            [UserEntity setPostName:en.post];
            [UserEntity setWechatid:en.wechatid];
            [UserEntity setEmail:en.email];
            [UserEntity setHeadImgUrl:en.avatar];
            [UserEntity setRapidAuth:en.isfast];
            [UserEntity setRealAuth:en.companyEn.approve];
            //[UserEntity setRealAuth:@"2"];
            
            [self setUpdata];
            [self initView];
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
