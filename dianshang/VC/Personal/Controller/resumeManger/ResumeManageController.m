//
//  ResumeManageController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/8.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ResumeManageController.h"
#import "PersonCenterViewController.h"
#import "JobIntentionController.h"
#import "RMSingleTextViewVC.h"
#import "CompanyPersonalDetailVC.h"
#import "EnclosureViewController.h"

#import "RMAddEditResume.h"
#import "ResumeManageEntity.h"
#import "CompanyHomeEntity.h"

#import "RMHeadView.h"
#import "ResumeManageCell.h"
#import "HomeJobCell.h"

static NSInteger paddingTop = 10;
static NSInteger paddingRight = 10;
static NSInteger paddingBottom = 10;
static NSInteger paddingLeft = 10;

@interface ResumeManageController ()

@property (nonatomic, strong) RMHeadView *rmheadView;
@property (nonatomic, strong) ResumeManageEntity *rmEntity;

@property (nonatomic, strong) UILabel *subTitleLbl;

@end

@implementation ResumeManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"简历";
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"预览" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    
    [self initView];
    
    
    [self reqResumeDetail];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.rmEntity) {
        self.rmheadView.entity = self.rmEntity;
    }
}

- (void)setUpdata
{
    YQGroupCellItem *group0 = [YQGroupCellItem setGroupItems:nil headerTitle:@"   自我描述" footerTitle:nil];
    YQGroupCellItem *group1 = [YQGroupCellItem setGroupItems:nil headerTitle:@"   求职意向" footerTitle:nil];
    [self.groups addObject:group0];
    [self.groups addObject:group1];
//    YQGroupCellItem *group2 = [YQGroupCellItem setGroupItems:nil headerTitle:@"   简历附件" footerTitle:nil];
//    [self.groups addObject:group2];
}


- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [self headView];
    if (IOS_VERSION_11_OR_ABOVE) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YQGroupCellItem *group = [self.groups objectAtIndex:section];
    return group.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib1 = [UINib nibWithNibName:@"ResumeManageCell" bundle:nil];
    [tableView registerNib:nib1 forCellReuseIdentifier:@"ResumeManageCell"];
    ResumeManageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ResumeManageCell"];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    [cell setItem:group.items[indexPath.row] indexPath:indexPath totalCount:group.items.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    // 添加简历信息
    RMAddEditResume *vc = [[RMAddEditResume alloc] init];
    vc.type = indexPath.section;
    vc.editEntity = [group.items objectAtIndex:indexPath.row];
    YQWeakSelf;
    vc.addEditBlock = ^(BOOL isAdd, ResumeManageSubEntity *en) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:group.items];
        if (isAdd) {
            [array replaceObjectAtIndex:indexPath.row withObject:en];
        }else{
            [array removeObjectAtIndex:indexPath.row];
        }
        group.items = array;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        return group.headerTitle;
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        return group.footerTitle;
    }
    return @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == RMSectionTypeEducational ||section == RMSectionTypeWorking ||section == RMSectionTypeExperience ) {
        return 45;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == RMSectionTypeEducational ||section == RMSectionTypeWorking ||section == RMSectionTypeExperience ) {
        return 30;
    }
    return 45;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YQGroupCellItem *group = [self.groups objectAtIndex:section];
    if (section == RMSectionTypeEducational ||section == RMSectionTypeWorking ||section == RMSectionTypeExperience ) {
        if (![group.headerTitle isEqualToString:@""] && group.headerTitle != nil) {
            UILabel *footView = [[UILabel alloc] init];
            footView.textColor = [UIColor colorWithWhite:0.508 alpha:1.000];
            footView.textAlignment = NSTextAlignmentLeft;
            footView.font = [UIFont systemFontOfSize:13];
            footView.text = group.headerTitle;
            return footView;
        }
    }else{
        if (![group.headerTitle isEqualToString:@""] && group.headerTitle != nil) {
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft, 0, APP_WIDTH-paddingLeft-paddingRight, 40)];
            button.tag = section;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:group.headerTitle forState:UIControlStateNormal];
            // 设置背景图片
            UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
            NSString *imageStr = @"rm_bg_all";
            UIImage *image = [UIImage imageNamed:imageStr];
            image = [image resizableImageWithCapInsets:insets];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:@"back_right"];
            [button addSubview:imageView];
            imageView.center = CGPointMake(button.yq_width-10, button.yq_height*0.5);
            
            switch (section) {
                case 0:
                    [button addTarget:self action:@selector(describeClick:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 1:
                    [button addTarget:self action:@selector(intentionClick:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 2:{
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.yq_x-80, 0, 80, 40)];
                        label.textColor = RGB(102, 102, 102);
                        label.font = [UIFont systemFontOfSize:14];
                        label.textAlignment = NSTextAlignmentRight;
                        label.text = group.ext;
                        [button addSubview:label];
                        [button addTarget:self action:@selector(assetClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    break;
                default:
                    break;
            }
            
            [view addSubview:button];
            return view;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == RMSectionTypeEducational ||section == RMSectionTypeWorking ||section == RMSectionTypeExperience ) {
        
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(paddingLeft, 0, APP_WIDTH-paddingLeft-paddingRight, 40)];
        button.tag = section;
        [button addTarget:self action:@selector(fotterClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        // 设置背景图片
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        NSString *imageStr = group.items.count > 0 ? @"rm_bg_bottom" : @"rm_bg_all";
        UIImage *image = [UIImage imageNamed:imageStr];
        image = [image resizableImageWithCapInsets:insets];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        switch (section) {
            case RMSectionTypeWorking:
                [button setTitle:@"+ 添加工作经历" forState:UIControlStateNormal];
                break;
            case RMSectionTypeExperience:
                [button setTitle:@"+ 添加项目经验" forState:UIControlStateNormal];
                break;
            case RMSectionTypeEducational:
                [button setTitle:@"+ 添加教育经历" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
        [view addSubview:button];
        return view;
    }
    return nil;
}

- (UIView *)headView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80+paddingTop+paddingBottom)];
    view.backgroundColor = self.view.backgroundColor;
    
    RMHeadView *bgView = [RMHeadView headView];
    [self addSubConstraint:bgView toView:view];
    self.rmheadView = bgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headviewTapClick:)];
    [bgView addGestureRecognizer:tap];
    return view;
}

#pragma mark - 事件处理

- (void)rightClick:(UIButton *)sender
{
    if ([[UserEntity getEdu] isEqualToString:@""] || [[UserEntity getBrithDay] isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请先去完善简历" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"去完善", nil];
        [alert show];
    }else{
        // 点击后跳转
        CompanyHomeEntity *en = [[CompanyHomeEntity alloc] init];
        en.itemId = [UserEntity getUid];
        en.name = [UserEntity getNickName];
        en.paymember = @"-1";
        
        CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
        vc.entity = en;
        vc.isRecommend = NO;
        vc.isChat = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
// 附件信息
- (void)assetClick:(UIButton *)sender
{
    EnclosureViewController *vc = [[EnclosureViewController alloc] init];
    vc.rmEntity = self.rmEntity;
    YQWeakSelf;
    vc.refreshUI = ^{
        [weakSelf refreshUI];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshUI
{
    [self reqResumeDetail];
}

// 个人描述
- (void)describeClick:(UIButton *)sender
{
    RMSingleTextViewVC *vc = [[RMSingleTextViewVC alloc] init];
    vc.navigationItem.title = @"自我描述";
    vc.placeholder = @"两年UI设计经验,\n熟悉iOS和Android的界面设计规范,\n对产品本色用独特见解,有一定手绘的基础.";
    vc.text = self.rmEntity.desc;
    YQWeakSelf;
    vc.textViewBlock = ^(NSString *text) {
        weakSelf.rmEntity.desc = text;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
// 求职意向
- (void)intentionClick:(UIButton *)sender
{
    JobIntentionController *vc = [[JobIntentionController alloc] init];
    vc.isback = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)fotterClick:(UIButton *)sender
{
    YQGroupCellItem *group = [self.groups objectAtIndex:sender.tag];
    // 添加简历信息
    RMAddEditResume *vc = [[RMAddEditResume alloc] init];
    vc.type = sender.tag;
    YQWeakSelf;
    vc.addEditBlock = ^(BOOL isAdd, ResumeManageSubEntity *en) {
        NSMutableArray *array = [NSMutableArray arrayWithArray: group.items];
        [array addObject:en];
        group.items = array;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headviewTapClick:(UIGestureRecognizer *)sender
{
    PersonCenterViewController *vc = [[PersonCenterViewController alloc] init];
    vc.rmEntity = self.rmEntity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addSubConstraint:(UIView *)view toView:(UIView *)cell
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.layer.cornerRadius = 8;
    [cell addSubview:view];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:paddingLeft]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:-paddingRight]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:paddingTop]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-paddingBottom]];
}


#pragma mark - 网络请求

- (void)reqResumeDetail
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getResumeDetail_uid:[UserEntity getUid] puid:@"" type:@"1" hx_username:@"" success:^(id resultDic) {
        [self.hud hide:YES];
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            if (self.groups.count > 0) {
                [self.groups removeAllObjects];
            }
            [self setUpdata];
            ResumeManageEntity *en = [ResumeManageEntity ResumeManageEntityWithDict:resultDic[DATA]];
            self.rmEntity = en;
            // 简历附件信息
            NSString *tempstr = @"";
            if ([en.is_asset isEqualToString:@"1"]) {
                tempstr = @"已上传";
            }else{
                tempstr = @"未上传";
            }
            YQGroupCellItem *group1 = [YQGroupCellItem setGroupItems:nil headerTitle:@"   简历附件" footerTitle:nil];
            group1.ext = tempstr;
            [self.groups addObject:group1];
            
            YQGroupCellItem *group2 = [YQGroupCellItem setGroupItems:en.work headerTitle:@"   工作经历" footerTitle:nil];
            YQGroupCellItem *group3 = [YQGroupCellItem setGroupItems:en.project headerTitle:@"   项目经验" footerTitle:nil];
            YQGroupCellItem *group4 = [YQGroupCellItem setGroupItems:en.edus headerTitle:@"   教育经历" footerTitle:nil];
            [self.groups addObject:group2];
            [self.groups addObject:group3];
            [self.groups addObject:group4];
            
            self.rmheadView.entity = en;
            [self.tableView reloadData];
            
            // 刷新个人信息
            [UserEntity setNickName:en.name];
            [UserEntity setHeadImgUrl:en.avatar];
            
            
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
