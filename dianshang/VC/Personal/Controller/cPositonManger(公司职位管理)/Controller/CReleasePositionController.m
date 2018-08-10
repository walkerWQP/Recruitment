//
//  CReleasePositionController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CReleasePositionController.h"
#import "RMJobPosition.h"
#import "RMSingleTextViewVC.h"
#import "CompanyLabelController.h"

#import "KNActionSheet.h"
#import "YQCityListView.h"
#import "RMSalarySelectView.h"

#import "CPositionMangerEntity.h"
#import "RMExpectindustryEntity.h"
#import "YQViewController+YQShareMethod.h"

@interface CReleasePositionController ()<UIAlertViewDelegate>
{
    NSIndexPath *currentIndexPath;
}
// 职位名
@property (nonatomic, strong) NSString *positionType;
// 职位描述
@property (nonatomic, strong) NSString *positionDetail;
// 职位名
@property (nonatomic, strong) NSString *pName;
// 试用期
@property (nonatomic, strong) NSString *tryoutStr;

/// 选择城市视图
@property (nonatomic, strong) YQCityListView *cityView;
@property (nonatomic, strong) NSString *provStr;// 省
@property (nonatomic, strong) NSString *cityStr;// 市
@property (nonatomic, strong) NSString *areaStr;// 区

@property (nonatomic, strong) NSArray *educationClassArray;// 学历分类数组
@property (nonatomic, strong) NSString *eduStr;// 学历id
@property (nonatomic, strong) NSArray *experienceClassArray;// 学历分类数组
@property (nonatomic, strong) NSString *experienceStr;// 经验id
/// 选择薪资视图
@property (nonatomic, strong) RMSalarySelectView *salarySelectView;
@property (nonatomic, strong) NSString *salaryStr;
// 技能
@property (nonatomic, strong) NSArray *skillLabelArr;
// 顾问费
@property (nonatomic, strong) NSString *costStr;


@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation CReleasePositionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.entity == nil) {
        self.navigationItem.title = @"发布职位";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"发布" titleColor:[UIColor whiteColor] target:self action:@selector(reqReleasePosition)];
    }else{
        self.navigationItem.title = @"编辑职位";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"保存" titleColor:[UIColor whiteColor] target:self action:@selector(reqSavePosition)];
        [self initDeleteView];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getEducationList]];
    //[array removeObjectAtIndex:0];
    self.educationClassArray = array;
    
    NSMutableArray *array0 = [NSMutableArray arrayWithArray:[EZPublicList getExperienceList]];
    //[array0 removeObjectAtIndex:0];
    self.experienceClassArray = array0;
    
    
    [self setUpdata];
    [self initView];
    
    
}
- (void)initDeleteView
{
    NSArray *array = @[@"关闭职位",@"删除职位",@"分享职位"];
    if (![self.entity.issue isEqualToString:@"1"]) {
        array = @[@"开放职位",@"删除职位",@"分享职位"];
    }
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT-APP_NAVH-60-APP_BottomH, APP_WIDTH, 60)];
    bottomView.backgroundColor = RGB(243, 243, 243);
    
    CGFloat jianju = 10;
    CGFloat w = (APP_WIDTH - jianju*(array.count+1))/array.count;
    CGFloat h = 35;
    CGFloat y = (40-35)*0.5+10;
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(jianju*(i+1)+i*w, y, w, h)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [bottomView addSubview:button];
        if (i == 0) {
            [self setButton1:button];
            [button addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
            self.closeButton = button;
        }else if (i == 1) {
            [button addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
            [self setButton1:button];
        }else{
            [button addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
            [self setButton:button];
        }
    }
    [self.view addSubview:bottomView];
}

- (void)setButton1:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    sender.layer.cornerRadius = 3;
    sender.layer.borderColor = RGB(120, 120, 120).CGColor;
    sender.layer.borderWidth = 1;
    sender.layer.masksToBounds = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    [sender setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
    [sender setBackgroundColor:RGB(243, 243, 243) forState:UIControlStateHighlighted];
}
- (void)setButton:(UIButton *)sender
{
    sender.backgroundColor = THEMECOLOR;
    sender.layer.cornerRadius = 3;
    sender.layer.masksToBounds = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:BTNBACKGROUND forState:UIControlStateHighlighted];
}
- (void)initView
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 8)];
    [self.view addSubview:self.tableView];
    if (self.entity != nil) {
        self.tableView.yq_height -= (60+APP_BottomH);
    }
}
- (void)setUpdata
{
    if (self.groups.count>0) {
        [self.groups removeAllObjects];
    }
    YQWeakSelf;
    NSMutableArray *mArr = [NSMutableArray array];
    YQCellItem *item2 = [YQCellItem setCellItemImage:nil title:@"职位类型"];
    item2.subTitle = @"请选择";
    item2.operationBlock = ^{
        [weakSelf selectPositionType];
    };
    [mArr addObject:item2];
    
    YQCellItem *item0 = [YQCellItem setCellItemImage:nil title:@"职位名称"];
    item0.subTitle = @"请填写";
    item0.operationBlock = ^{
        [weakSelf fillInName];
    };
    [mArr addObject:item0];
    
    YQCellItem *item6 = [YQCellItem setCellItemImage:nil title:@"工作地点"];
    item6.subTitle = @"请选择";
    [mArr addObject:item6];
    item6.operationBlock = ^{
        [weakSelf selectCity];
    };
    //NSString *footerStr = @"职类信息,职类名称和工作城市发布后不可修改";
    YQGroupCellItem *group0 = [YQGroupCellItem setGroupItems:mArr headerTitle:nil footerTitle:nil];
    [self.groups addObject:group0];
    
    mArr = [NSMutableArray array];
    YQCellItem *item7 = [YQCellItem setCellItemImage:nil title:@"薪资范围"];
    item7.subTitle = @"请选择";
    [mArr addObject:item7];
    item7.operationBlock = ^{
        [weakSelf selectSalary];
    };
    
    YQCellItem *item9 = [YQCellItem setCellItemImage:nil title:@"技能要求"];
    item9.subTitle = @"选择技能要求";
    item9.operationBlock = ^{
        [weakSelf goSkill];
    };
    [mArr addObject:item9];
    
    YQCellItem *item3 = [YQCellItem setCellItemImage:nil title:@"经验要求"];
    item3.subTitle = @"请选择";
    item3.operationBlock = ^{
        [weakSelf changeExperience];
    };
    [mArr addObject:item3];
    
    YQCellItem *item5 = [YQCellItem setCellItemImage:nil title:@"最低学历"];
    item5.subTitle = @"请选择";
    item5.operationBlock = ^{
        [weakSelf changeEducation];
    };
    [mArr addObject:item5];
    YQCellItem *item1 = [YQCellItem setCellItemImage:nil title:@"职位描述"];
    item1.subTitle = @"请填写";
    item1.operationBlock = ^{
        [weakSelf fillInPositionDetail];
    };
    [mArr addObject:item1];
    
    YQGroupCellItem *group1 = [YQGroupCellItem setGroupItems:mArr headerTitle:nil footerTitle:nil];
    [self.groups addObject:group1];
    
    mArr = [NSMutableArray array];
    YQCellItem *item4 = [YQCellItem setCellItemImage:nil title:@"HR顾问费"];
    item4.subTitle = @"请填写";
    item4.operationBlock = ^{
        [weakSelf fillInCost];
    };
    [mArr addObject:item4];
    
    YQCellItem *item8 = [YQCellItem setCellItemImage:nil title:@"试用期"];
    item8.subTitle = @"请选择";
    item8.operationBlock = ^{
        [weakSelf selectTryOut];
    };
    [mArr addObject:item8];
    YQGroupCellItem *group2 = [YQGroupCellItem setGroupItems:mArr headerTitle:@"   设置顾问费" footerTitle:nil];
    [self.groups addObject:group2];
    
    if (self.entity != nil) {
        // 职位类型
        item2.subTitle = self.entity.position_class_name;
        item2.operationBlock = nil;
        self.positionType = self.entity.position_class_id;
        
        item0.subTitle = self.entity.pname;
        item0.operationBlock = nil;
        self.pName = item0.subTitle;
        
        item6.subTitle = self.entity.city;
        item6.operationBlock = nil;
        self.cityStr = self.entity.city;
        
        if ([self.entity.paytop integerValue] == 0) {
            item7.subTitle = @"面议";
            self.salaryStr = @"0-0";
        }else{
            item7.subTitle = self.entity.pay;
            self.salaryStr = item7.subTitle;
        }
        
        item3.subTitle = [self.experienceClassArray objectAtIndex:[self.entity.exprience integerValue]];
        self.experienceStr = self.entity.exprience;
        
        item5.subTitle = [self.educationClassArray objectAtIndex:[self.entity.edu integerValue]];
        self.eduStr = self.entity.edu;
        
        item1.subTitle = self.entity.pdetails;
        self.positionDetail = item1.subTitle;
        
        item4.subTitle = self.entity.consultant;
        self.costStr = self.entity.consultant;
        
        NSArray *array = @[@"无试用期",@"一个月",@"两个月",@"三个月"];
        item8.subTitle = [array objectAtIndex:[self.entity.probation integerValue]];
        self.tryoutStr = self.entity.probation;
        
        if (self.entity.skill.length > 0) {
            NSArray *arr = [self.entity.skill componentsSeparatedByString:@","];
            if (arr.count > 0) {
                item9.subTitle = [NSString stringWithFormat:@"%li个标签",arr.count];
            }
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSString *str in arr) {
                RMExpectindustryEntity *en = [[RMExpectindustryEntity alloc] init];
                en.tname = str;
                [mArr addObject:en];
            }
            self.skillLabelArr = mArr;
        }else{
            item9.subTitle = @"选择技能要求";
        }
    }
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
    currentIndexPath = indexPath;
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    if (item.operationBlock) {
        item.operationBlock();
    }
}

#pragma mark - 事件

- (void)selectTryOut
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择试用期" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"无试用期",@"一个月",@"两个月",@"三个月", nil];
    alert.tag = 1002;
    [alert show];
}

// 职位详情
- (void)fillInPositionDetail
{
    RMSingleTextViewVC *vc = [[RMSingleTextViewVC alloc] init];
    vc.isSave = YES;
    vc.navigationItem.title = @"职位描述";
    vc.placeholder = @"请填写详细、清晰的职位描述，有助于您更准确地展开招聘需求（不能填写QQ、微信、电话等联系方式，以及特殊符号）\n\n例如：\n1.工作内容…\n2.任务要求…\n3.特别说明…";
    vc.text = self.entity.pdetails;
    YQWeakSelf;
    vc.textViewBlock = ^(NSString *text) {
        weakSelf.positionDetail = text;
        [weakSelf refreshTable:@[text] tag:6];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 职位名
- (void)fillInName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"填写职位名称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1000;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"填写职位名称";
    tf.text = self.pName;
}
// 顾问费
- (void)fillInCost
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH*0.71, 70)];
    //v.backgroundColor = RandomColor;
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, v.yq_width, 30)];
    titleLbl.text = @"填写顾问费";
    [titleLbl sizeToFit];
    titleLbl.yq_height = 30;
    titleLbl.yq_centerX = v.yq_centerX;
    [v addSubview:titleLbl];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(titleLbl.yq_right, 3, 35, 35)];
    [button setImage:[UIImage imageNamed:@"atoast"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toastClick:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:button];
    UILabel *subTLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, v.yq_width, 30)];
    subTLbl.text = @"(单位:元)";
    subTLbl.font = [UIFont systemFontOfSize:15];
    [subTLbl sizeToFit];
    subTLbl.yq_height = 30;
    subTLbl.yq_centerX = v.yq_centerX;
    [v addSubview:subTLbl];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1001;
    [alert show];
    [alert setValue:v forKey:@"accessoryView"];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"填写顾问费";
    tf.text = self.costStr;
}
- (void)toastClick:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"共享招聘顾问费介绍" message:@"E招基于直招全程免费，共享招聘效果付费的理念，为了获取更好的招聘效果，我们建议顾问费设置金额：\n普通岗位：500～2000元\n中端岗位：1000～5000元\n高端岗位：3000元以上\n顾问费支付流程：\n人才转正后第一次支付订单金额40%，转正后稳定第一个月支付订单金额30%，转正后稳定第二个月支付订单金额30%。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        // 昵称
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            if (tf.text.length>0) {
                [self setPositionName:tf.text];
            }
        }
    }else if (alertView.tag == 1001) {
        // 顾问费
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            if (tf.text.length>0) {
                [self setCost:tf.text];
            }
        }
    }else if (alertView.tag == 1002) {
        // 试用期
        NSArray *array = @[@"无试用期",@"一个月",@"两个月",@"三个月"];
        NSString *str = [NSString stringWithFormat:@"%li",buttonIndex];
        self.tryoutStr = str;
        [self refreshTable:@[[array objectAtIndex:buttonIndex]] tag:7];
    }else if (alertView.tag == 1003) {
        NSString *skillStr = @"";
        for (RMExpectindustryEntity *en in self.skillLabelArr) {
            skillStr = [skillStr stringByAppendingString:en.tname];
            if (![en isEqual:self.skillLabelArr.lastObject]) {
                skillStr = [skillStr stringByAppendingString:@","];
            }
        }
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] releasePosition_uid:[UserEntity getUid] cid:[UserEntity getCompanyId] position_class_id:self.positionType pname:self.pName pay:self.salaryStr skill:skillStr experience:self.experienceStr edu:self.eduStr pdetails:self.positionDetail consultant:self.costStr probation:self.tryoutStr city:self.cityStr success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [YQToast yq_ToastText:@"发布成功" bottomOffset:100];
                if (self.addEditBlock) {
                    self.addEditBlock(YES, nil);
                }
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"companyHomeRefresh" object:nil userInfo:nil];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}
- (void)setCost:(NSString *)nickname
{
    self.costStr = nickname;
    [self refreshTable:@[nickname] tag:5];
}
- (void)setPositionName:(NSString *)nickname
{
    self.pName = nickname;
    [self refreshTable:@[nickname] tag:1];
}

- (void)selectCity
{
    [self.cityView showAnimate];
}

// 城市view
- (YQCityListView *)cityView
{
    if (_cityView == nil) {
        YQCityListView *cityView = [[YQCityListView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT) column:2];
        //YQGroupCellItem *items = [self.groups objectAtIndex:0];
        //YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
        cityView.defultCityStr = self.cityStr;
        cityView.titleStr = @"工作地点";
        YQWeakSelf;
        [cityView buttonPress:^(NSString *provStr, NSString *cityStr, NSString *areaStr) {
            CLog(@"%@->%@->%@",provStr,cityStr,areaStr);
            weakSelf.provStr = provStr;
            weakSelf.cityStr = cityStr;
            weakSelf.areaStr = areaStr;
            if ([provStr isEqualToString:cityStr]) {
                [weakSelf refreshTable:@[[NSString stringWithFormat:@"%@",cityStr]] tag:4];
            }else{
                [weakSelf refreshTable:@[[NSString stringWithFormat:@"%@ %@",provStr,cityStr]] tag:4];
            }
            
        }];
        _cityView = cityView;
    }
    return _cityView;
}

- (void)refreshTable:(NSArray *)array tag:(NSInteger)tag
{
    YQGroupCellItem *items = [self.groups objectAtIndex:currentIndexPath.section];
    YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
    if (tag == 9) {
        self.skillLabelArr = array;
        if (array.count > 0) {
            item.subTitle = [NSString stringWithFormat:@"%li个标签",array.count];
        }else{
            item.subTitle = @"选择技能要求";
        }
    }else{
        if (array.count > 0) {
            item.subTitle = array.firstObject;
        }
    }
    [self.tableView reloadData];
}

/// 职位类型
- (void)selectPositionType
{
    YQWeakSelf;
    RMJobPosition *vc = [[RMJobPosition alloc] init];
    vc.JobPositionBlock = ^(RMJobPositionEntity *entity) {
        weakSelf.positionType = entity.uid;
        [weakSelf refreshTable:@[entity.name] tag:0];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
/// 学历
- (void)changeExperience
{
    YQWeakSelf;
    KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:self.experienceClassArray  actionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex != -1) {
            weakSelf.experienceStr = [NSString stringWithFormat:@"%li",buttonIndex];
            [weakSelf refreshTable:@[[weakSelf.experienceClassArray objectAtIndex:buttonIndex]] tag:2];
        }
    }];
    [actionSheet show];
}
/// 学历
- (void)changeEducation
{
    YQWeakSelf;
    KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:self.educationClassArray  actionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex != -1) {
            weakSelf.eduStr = [NSString stringWithFormat:@"%li",buttonIndex];
            [weakSelf refreshTable:@[[weakSelf.educationClassArray objectAtIndex:buttonIndex]] tag:2];
        }
    }];
    [actionSheet show];
}

- (void)selectSalary
{
    [self.salarySelectView showAnimate];
}

// 薪资view
- (RMSalarySelectView *)salarySelectView
{
    if (_salarySelectView == nil) {
        RMSalarySelectView *cityView = [[RMSalarySelectView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
        YQGroupCellItem *items = [self.groups objectAtIndex:0];
        YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
        if (item.subTitle.length > 0) {
            NSString *temp = [item.subTitle substringToIndex:item.subTitle.length-1];
            NSArray *array = [temp componentsSeparatedByString:@"-"];
            [cityView setMinStr:array.firstObject MaxStr:array.lastObject];
        }
        
        YQWeakSelf;
        cityView.selectSalaryBlock = ^(NSString *minStr, NSString *maxStr) {
            [weakSelf setSalarySelect:minStr maxStr:maxStr];
        };
        _salarySelectView = cityView;
    }
    return _salarySelectView;
}
// 选择薪资刷新
- (void)setSalarySelect:(NSString *)minStr maxStr:(NSString *)maxStr
{
    if ([minStr isEqualToString:@"面议"]) {
        [self refreshTable:@[minStr] tag:3];
        self.salaryStr = @"0-0";
    }else{
        NSString *str = [NSString stringWithFormat:@"%@-%@",minStr,maxStr];
        [self refreshTable:@[[str stringByAppendingString:@"k"]] tag:3];
        self.salaryStr = str;
    }
}
- (void)goSkill
{
    CompanyLabelController *vc = [[CompanyLabelController alloc] init];
    vc.navigationItem.title = @"技能要求";
    NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getSkillList]];
    [array removeObjectAtIndex:0];
    vc.allArray = array;
    vc.expectArray = self.skillLabelArr;
    vc.titleStr = @"选择技能要求,最多6个";
    vc.selectCount = 6;
    vc.isAdd = YES;
    // 根据数据刷新
    YQWeakSelf;
    vc.expectIndustryBlock = ^(NSArray *array) {
        [weakSelf refreshTable:array tag:9];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)reqReleasePosition
{
    NSString *skillStr = @"";
    for (RMExpectindustryEntity *en in self.skillLabelArr) {
        skillStr = [skillStr stringByAppendingString:en.tname];
        if (![en isEqual:self.skillLabelArr.lastObject]) {
            skillStr = [skillStr stringByAppendingString:@","];
        }
    }
    
    NSString *msg = @"";
    if (self.positionType.length == 0) {
        msg = @"请选择职位类型";
    }else if (self.pName.length == 0) {
        msg = @"请填写职位名";
    }else if (self.cityStr.length == 0) {
        msg = @"请选择工作地点";
    }else if (self.salaryStr.length == 0) {
        msg = @"请选择薪资范围";
    }else if (skillStr.length == 0) {
        msg = @"请选择技能要求";
    }else if (self.costStr.length == 0) {
        msg = @"请填写HR顾问费";
    }else if (self.experienceStr.length == 0) {
        msg = @"请选择经验要求";
    }else if (self.tryoutStr.length == 0) {
        msg = @"请选择试用期";
    }else if (self.eduStr.length == 0) {
        msg = @"请选择最低学历";
    }else if (self.positionDetail.length == 0) {
        msg = @"请填写职位描述";
    }else{
        NSArray *array = @[@"无试用期",@"一个月",@"两个月",@"三个月"];
        NSString *str = [array objectAtIndex:[self.tryoutStr integerValue]];
        NSString *msg = [NSString stringWithFormat:@"确定设置%@元顾问费,试用期%@并发布该职位吗?",self.costStr,str];
        if ([self.tryoutStr integerValue] == 0) {
            msg = [NSString stringWithFormat:@"确定设置%@元顾问费,无试用期并发布该职位吗?",self.costStr];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 1003;
        [alert show];
    }
    if (msg.length >0) {
        [YQToast yq_ToastText:msg bottomOffset:100];
    }
}

- (void)closeClick
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] changePosition_uid:[UserEntity getUid] pid:self.entity.itemId success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            if ([self.entity.issue isEqualToString:@"1"]) {
                [YQToast yq_ToastText:@"已关闭职位" bottomOffset:100];
                self.entity.issue = @"2";
                [self.closeButton setTitle:@"开放职位" forState:UIControlStateNormal];
            }else{
                [YQToast yq_ToastText:@"已开放职位" bottomOffset:100];
                self.entity.issue = @"1";
                [self.closeButton setTitle:@"关闭职位" forState:UIControlStateNormal];
            }
            if (self.addEditBlock) {
                self.addEditBlock(NO, nil);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"companyHomeRefresh" object:nil userInfo:nil];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)deleteClick
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] deletePosition_uid:[UserEntity getUid] pid:self.entity.itemId success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"删除成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addEditBlock) {
                self.addEditBlock(YES, nil);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"companyHomeRefresh" object:nil userInfo:nil];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)shareClick
{
    [self shareView];
}
- (void)reqSavePosition
{
    NSString *skillStr = @"";
    for (RMExpectindustryEntity *en in self.skillLabelArr) {
        skillStr = [skillStr stringByAppendingString:en.tname];
        if (![en isEqual:self.skillLabelArr.lastObject]) {
            skillStr = [skillStr stringByAppendingString:@","];
        }
    }
    
    NSString *msg = @"";
    if (self.positionType.length == 0) {
        msg = @"请选择职位类型";
    }else if (self.pName.length == 0) {
        msg = @"请填写职位名";
    }else if (self.cityStr.length == 0) {
        msg = @"请选择工作地点";
    }else if (self.salaryStr.length == 0) {
        msg = @"请选择薪资范围";
    }else if (skillStr.length == 0) {
        msg = @"请选择技能要求";
    }else if (self.costStr.length == 0) {
        msg = @"请填写HR顾问费";
    }else if (self.experienceStr.length == 0) {
        msg = @"请选择经验要求";
    }else if (self.tryoutStr.length == 0) {
        msg = @"请选择试用期";
    }else if (self.eduStr.length == 0) {
        msg = @"请选择最低学历";
    }else if (self.positionDetail.length == 0) {
        msg = @"请填写职位描述";
    }else{
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] saveEditPosition_uid:[UserEntity getUid] pid:self.entity.itemId detailAddress:@"" position_class_id:self.positionType pname:self.pName pay:self.salaryStr skill:skillStr experience:self.experienceStr edu:self.eduStr pdetails:self.positionDetail consultant:self.costStr probation:self.tryoutStr city:self.cityStr success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                if (self.addEditBlock) {
                    self.addEditBlock(YES, nil);
                }
                [self.navigationController popViewControllerAnimated:YES];
                [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"companyHomeRefresh" object:nil userInfo:nil];
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
    if (msg.length >0) {
        [YQToast yq_ToastText:msg bottomOffset:100];
    }
}
#pragma mark - 分享视图
// 将要执行分享的时候调用
- (void)shreViewWillAppear
{
    // 调用分享话题接口(分享次数+1 无论分享是否成功都+1)
    //    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    //    YQDiscoverFrame *frame = item.tableViewArray[curIndexPath.row];
    //    [[RequestManager sharedRequestManager] discoverShareTopic_uid:@"" tid:frame.status.idstr success:^(id resultDic) {
    //        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
    //            YQDiscover *en = frame.status;
    //            if (en.isPraise) {
    //                en.reposts_count -= 1;
    //            }else{
    //                en.reposts_count += 1;
    //            }
    //
    //            [item.tableViewArray replaceObjectAtIndex:curIndexPath.row withObject:frame];
    //
    //            [item.tableView reloadRowsAtIndexPaths:@[curIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    //        }
    //    } failure:nil];
    
}
// 设置分享参数
- (NSMutableDictionary *)getShateParameters
{
    //    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    //    YQDiscoverFrame *frame = item.tableViewArray[curIndexPath.row];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *title = [NSString stringWithFormat:@"出钱找人:%@招聘，推荐人才赚顾问费!",self.entity.pname];
    NSLog(@"5     %@",self.entity.itemId);
    NSString *image = [UserEntity getHeadImgUrl];
    NSString *urlStr = [NSString stringWithFormat:@"%@/index/positiondetail.html?pid=%@",H5BaseURL,self.entity.itemId];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 通用参数设置
    [parameters SSDKSetupShareParamsByText:self.entity.pdetails
                                    images:image
                                       url:url
                                     title:title
                                      type:SSDKContentTypeAuto];
    return parameters;
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
