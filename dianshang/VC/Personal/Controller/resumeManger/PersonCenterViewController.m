//
//  PersonCenterViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/9/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "KNActionSheet.h"
#import "YQBrithDayView.h"
#import "YQDataPickerView.h"
#import "NSString+YQWidthHeight.h"
#import "NSString+MyDate.h"
#import "ResumeManageEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PersonCenterViewController ()<UIAlertViewDelegate>
{
    UIView *headView;
}

@property (nonatomic, strong) NSArray *educationClassArray;// 学历分类数组
//@property (nonatomic, strong) NSArray *licenseClassArray;// 执照分类数组

//@property (nonatomic, strong) YQDataPickerView *ageView;// 出生年月
@property (nonatomic, strong) YQDataPickerView *workingView;// 工作年份

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *wechatid;
@property (nonatomic, strong) NSString *introduction;

// brithDay
@property (nonatomic, strong) YQBrithDayView *startView;

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getEducationList]];
    [array removeObjectAtIndex:0];
    self.educationClassArray = array;
    //self.licenseClassArray = [EZPublicList getEducationList];
    
//    if (![[UserEntity getRealAuth] isEqualToString:@"1"]) {
//        UIBarButtonItem *item = [UIBarButtonItem itemWithtitle:@"去认证" titleColor:[UIColor whiteColor] target:self action:@selector(goAuth)];
//        self.navigationItem.rightBarButtonItem = item;
//    }
    [self setUpdata];
    [self initView];
}

- (void)goAuth
{
//    UploadDataController *vc = [[UploadDataController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
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
    item0.subTitle = self.rmEntity.name;
    item0.operationBlock = ^{
        [weakSelf changeName];
    };
    [mArr addObject:item0];
    
    YQCellItem *item4 = [YQCellItem setCellItemImage:nil title:@"性别"];
    item4.subTitle = self.rmEntity.sex;
    [mArr addObject:item4];
    item4.operationBlock = ^{
        [weakSelf changeSex];
    };
    YQCellItem *item6 = [YQCellItem setCellItemImage:nil title:@"微信号"];
    item6.subTitle = self.rmEntity.wechatid.length > 0 ? self.rmEntity.wechatid : @"填写微信号";
    [mArr addObject:item6];
    item6.operationBlock = ^{
        [weakSelf changeWXid];
    };
    YQCellItem *item3 = [YQCellItem setCellItemImage:nil title:@"出生年月"];
    item3.subTitle = self.rmEntity.birthday;
    item3.operationBlock = ^{
        [weakSelf changeDate];
    };
    [mArr addObject:item3];
    YQCellItem *item5 = [YQCellItem setCellItemImage:nil title:@"学历"];
    if ([self.rmEntity.edu isEqualToString:@"不限"]) {
        item5.subTitle = @"选择学历";
    }else{
        item5.subTitle = self.rmEntity.edu;
    }
    [mArr addObject:item5];
    item5.operationBlock = ^{
        [weakSelf changeEducation];
    };
    YQCellItem *item7 = [YQCellItem setCellItemImage:nil title:@"参加工作年份"];
    item7.subTitle = [self.rmEntity.workyear integerValue] > 0 ? self.rmEntity.workyear : @"选择参加工作年份";
    [mArr addObject:item7];
    item7.operationBlock = ^{
        [weakSelf.workingView showAnimate];
    };
    
    YQGroupCellItem *group1 = [YQGroupCellItem setGroupItems:mArr headerTitle:@"   个人资料" footerTitle:nil];
    [self.groups addObject:group1];
    
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
    NSString *avatar = [NSString stringWithFormat:@"%@%@",ImageURL,self.rmEntity.avatar];
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

- (void)changeEducation
{
    YQWeakSelf;
    KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:self.educationClassArray  actionBlock:^(NSInteger buttonIndex) {
        NSString *edu = [NSString stringWithFormat:@"%li",buttonIndex+1];
        [weakSelf.hud show:YES];
        [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:@"" name:@"" sex:@"" birthday:@"" wechatid:@"" restatus:@"" edu:edu year:@"" workyear:@"" success:^(id resultDic) {
            [weakSelf.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                weakSelf.rmEntity.edu = edu;
                
                [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
                [UserEntity setEdu:edu];
                [weakSelf setUpdata];
                [weakSelf.tableView reloadData];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }];
    [actionSheet show];
}
- (void)changeDate
{
    self.startView = [[YQBrithDayView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH,APP_HEIGHT)];
    [self.startView showAnimate];
    
    YQWeakSelf;
    self.startView.submitBlock = ^(NSString *dateStr) {
        //NSString *sex = [NSString stringWithFormat:@"%li",buttonIndex+1];
        [weakSelf.hud show:YES];
        [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:@"" name:@"" sex:@"" birthday:dateStr wechatid:@"" restatus:@"" edu:@"" year:@"" workyear:@"" success:^(id resultDic) {
            [weakSelf.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                NSString *str = [NSString stringToTimeStamp:dateStr formatter:YYYYMMdd];
                weakSelf.rmEntity.birthday = str;
                
                [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
                [UserEntity setBrithDay:str];
                [weakSelf setUpdata];
                [weakSelf.tableView reloadData];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    };
}

- (YQDataPickerView *)workingView
{
    if (_workingView == nil) {
        _workingView = [[YQDataPickerView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH,APP_HEIGHT)];
        _workingView.isMonth = NO;
        YQWeakSelf;
        _workingView.buttonPress = ^(NSString *yearStr, NSString *monthStr) {
            if ([yearStr hasSuffix:@"年"]) {
                yearStr = [yearStr substringToIndex:yearStr.length-1];
            }
            [weakSelf changeWorking:yearStr];
        };
    }
    return _workingView;
}
- (void)changeWorking:(NSString *)year
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:@"" name:@"" sex:@"" birthday:@"" wechatid:@"" restatus:@"" edu:@"" year:@"" workyear:year success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            self.rmEntity.workyear = year;
            
            [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
//            NSString *cur = [NSString dateToString:[NSDate date] formatter:@"YYYY"];
//            NSString *y = [NSString stringWithFormat:@"%li",[cur integerValue] - [year integerValue]];
            [UserEntity setWorkyear:year];
            [self setUpdata];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)changeWXid
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"填写微信号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1002;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"填写微信号";
    tf.text = self.rmEntity.wechatid;
}
- (void)changePhone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改手机号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"修改手机号";
    tf.text = self.rmEntity.phone;
}
- (void)changeSex
{
    YQWeakSelf;
    KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:@[@"男",@"女"]  actionBlock:^(NSInteger buttonIndex) {
        
        NSString *sex = [NSString stringWithFormat:@"%li",buttonIndex+1];
        [weakSelf.hud show:YES];
        [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:@"" name:@"" sex:sex birthday:@"" wechatid:@"" restatus:@"" edu:@"" year:@"" workyear:@"" success:^(id resultDic) {
            [weakSelf.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                weakSelf.rmEntity.sex = sex;
                
                [YQToast yq_ToastText:@"修改成功" bottomOffset:100];
                [UserEntity setSex:sex];
                [weakSelf setUpdata];
                [weakSelf.tableView reloadData];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }];
    [actionSheet show];
}
- (void)changeName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1000;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"修改昵称";
    tf.text = self.rmEntity.name;
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
    }
}

- (void)changePersonInfo_nickname:(NSString *)nickname
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:@"" name:nickname sex:@"" birthday:@"" wechatid:@"" restatus:@"" edu:@"" year:@"" workyear:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            self.rmEntity.name = self.nickName;
            
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
    [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:@"" name:@"" sex:@"" birthday:@"" wechatid:wxid restatus:@"" edu:@"" year:@"" workyear:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            self.rmEntity.wechatid = wxid;
            
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
            self.rmEntity.avatar = [dict objectForKey:@"file"];
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
