//
//  HomePositionDetailVC.m
//  dianshang
//
//  Created by yunjobs on 2017/11/17.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "HomePositionDetailVC.h"
#import "MemberDetailController.h"
#import "CompanyDetailController.h"
#import "ChatViewController.h"
#import "RecommendPositionController.h"

#import "PositionDetailView.h"
#import "PositionDetailOtherView.h"

#import "PositionDetailEntity.h"
#import "HomeJobEntity.h"

#import "UserInfo+CoreDataClass.h"
#import "NSString+YQWidthHeight.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YQViewController+YQShareMethod.h"

@interface HomePositionDetailVC ()

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) PositionDetailEntity *detailEntity;

@property (nonatomic, strong) UIButton *deliveryButton;

@property (nonatomic, strong) UIView *recommendView;
@end

@implementation HomePositionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"职位详情";
    
    [self setNav];
    
    [self reqPositionDetail];
}
- (void)setNav
{
    NSMutableArray *itemArr = [NSMutableArray array];
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"position_share" highImage:@"position_share" target:self action:@selector(sharePosition:)];
    [itemArr addObject:item];
    
    if ([self.jobEntity.payposition isEqualToString:@"1"]) {
        UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"position_follow" highImage:@"position_follow" target:self action:@selector(followPosition:)];
        [itemArr addObject:item];
    } else {
        UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"position_unfollow" highImage:@"position_unfollow" target:self action:@selector(followPosition:)];
        [itemArr addObject:item];
    }
    
    self.navigationItem.rightBarButtonItems = itemArr;
}
- (void)initView
{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    [self.view addSubview:scroller];
    self.scroller = scroller;
    
    PositionDetailEntity *en = self.detailEntity;
    
    if (self.isRecommend) {
        // 推荐人View
        [self initRecommendView:scroller];
        // 企业付费后才能沟通
//        if (![self.jobEntity.cdealwith isEqualToString:@"0"]) {
//            [self initBottomView];
//            scroller.yq_height -= 50;
//        }
    }else{
        [self initBottomView];
        scroller.yq_height -= (60+APP_BottomH);
    }
    
    PositionDetailView *detailView = [PositionDetailView detailView];
    detailView.yq_y = self.recommendView.yq_bottom+8;
    detailView.yq_width = APP_WIDTH;
    detailView.yq_height = [PositionDetailView detailViewHeight:en];
    detailView.entity = en;
    YQWeakSelf;
    detailView.companyHomePage = ^(UIButton *sender) {
        [weakSelf goCompanyHomePage];
    };
    
    detailView.addressHomeClick = ^(UIButton *sender) {
        [weakSelf goAddressHomeClick];
    };
    
    [scroller addSubview:detailView];
    //[self addSubConstraint:detailView toView:scroller];
    
#pragma mark ========职位具体要求========
    NSString *content = [@"岗位职责:\n\n" stringByAppendingString:en.pdetails];
    CGFloat h = [content yq_stringHeightWithFixedWidth:APP_WIDTH-20 font:15];
    CGFloat postionViewH = (120-46)+h;
    PositionDetailOtherView *postionView = [PositionDetailOtherView otherView];
    postionView.yq_y = detailView.yq_bottom;
    postionView.yq_width = APP_WIDTH;
    postionView.yq_height = postionViewH;
    postionView.title = @"职位详情";
    postionView.image = @"position_position";
    postionView.content = content;
    [scroller addSubview:postionView];
    
    
    PositionDetailOtherView *postionView1 = [PositionDetailOtherView otherView];
    postionView1.yq_y = postionView.yq_bottom;
    postionView1.yq_width = APP_WIDTH;
    postionView1.yq_height = 120;
    postionView1.title = @"技能要求";
    postionView1.image = @"position_skill";
    postionView1.content = [en.skill stringByReplacingOccurrencesOfString:@"," withString:@"  "];
    [scroller addSubview:postionView1];
    
    
    PositionDetailOtherTwoView *postionView2 = [PositionDetailOtherTwoView otherTwoView];
    postionView2.yq_y = postionView1.yq_bottom;
    postionView2.yq_width = APP_WIDTH;
    postionView2.yq_height = 125;
    postionView2.name = en.name;
    postionView2.position = self.jobEntity.post;
    postionView2.status = @"";
    postionView2.headImage = en.avatar;
    //YQWeakSelf;
    postionView2.homePage = ^(UIButton *sender) {
        [weakSelf goHomePage];
    };
    [scroller addSubview:postionView2];
    
    scroller.contentSize = CGSizeMake(APP_WIDTH, postionView2.yq_bottom+10);
}
- (void)initRecommendView:(UIView *)view
{
    CGFloat w = APP_WIDTH;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, w, 80)];
    headView.backgroundColor = [UIColor whiteColor];
    [view addSubview:headView];
    self.recommendView = headView;
    
    //NSDictionary *dict = @{};
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    headImg.layer.cornerRadius = headImg.yq_height*0.5;
    headImg.layer.masksToBounds = YES;
    [headView addSubview:headImg];
    NSString *url = [NSString stringWithFormat:@"%@%@",ImageURL,self.jobEntity.ravatar];
    [headImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(headImg.yq_right+10, headImg.yq_y, w-headImg.yq_right-20-90, 30)];
    titlelabel.text = self.jobEntity.rname;
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:16];
    [headView addSubview:titlelabel];
    
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(titlelabel.yq_x, titlelabel.yq_bottom, w-headImg.yq_right-20, 20)];
    NSString *str = [NSString stringWithFormat:@"靠谱值:%@",self.jobEntity.reliable];
    subTitle.text = str;
    subTitle.textColor = RGB(102, 102, 102);
    subTitle.font = [UIFont systemFontOfSize:14];
    [headView addSubview:subTitle];
    
    if ([UserEntity getIsCompany]) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(titlelabel.yq_right, titlelabel.yq_y, 90, titlelabel.yq_height)];
        [button setTitle:@"工作靠谱吗?" forState:UIControlStateNormal];
        [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [headView addSubview:button];
    }
    
}
- (void)initBottomView
{
    NSArray *array = @[@"投递简历",@"立即沟通"];
    if ([self.jobEntity.delivery isEqualToString:@"1"]) {
        array = @[@"已投递",@"立即沟通"];
    }else if ([self.jobEntity.delivery isEqualToString:@"-1"]) {
        array = @[@"立即沟通"];
    }
    
    if (self.isHome) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];
        [mArr addObject:@"推荐简历"];
        array = mArr;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT-APP_NAVH-(60+APP_BottomH), APP_WIDTH, 60+APP_BottomH)];
    bottomView.backgroundColor = RGB(243, 243, 243);
    
    CGFloat jianju = 10;
    CGFloat w = (APP_WIDTH - jianju*(array.count+1)) / 3;
    CGFloat h = 35;
    CGFloat y = (40-35)*0.5+10;
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(jianju*(i+1)+i*w, y, w, h)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [bottomView addSubview:button];
        if (array.count > 1) {
            if (i == 0) {
                [self setButton1:button];
                [button addTarget:self action:@selector(deliveryClick:) forControlEvents:UIControlEventTouchUpInside];
                self.deliveryButton = button;
            }else if (i == 1) {
                [button addTarget:self action:@selector(goChatClick:) forControlEvents:UIControlEventTouchUpInside];
                if (array.count > 2) {
                    [self setButton1:button];
                }else{
                    button.yq_width = w*2;
                    [self setButton:button];
                }
            }else if (i == 2) {
                [button addTarget:self action:@selector(recommendClick:) forControlEvents:UIControlEventTouchUpInside];
                [self setButton:button];
            }
        }else{
            button.yq_width = w*3;
            [button addTarget:self action:@selector(goChatClick:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)deliveryClick:(UIButton *)sender
{
    if (![self.jobEntity.delivery isEqualToString:@"1"]) {
        [self.hud show:YES];
        [self.hud show:YES];
        [[RequestManager sharedRequestManager] getHRRecommend_uid:[UserEntity getUid] pid:self.jobEntity.uid type:@"1" puid:self.jobEntity.puid shareid:@"" success:^(id resultDic) {
            [self.hud hide:YES];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [YQToast yq_ToastText:@"投递成功" bottomOffset:100];
                [self.deliveryButton setTitle:@"已投递" forState:UIControlStateNormal];
                self.jobEntity.delivery = @"1";
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
//        [[RequestManager sharedRequestManager] deliverRemuse_uid:[UserEntity getUid] pid:self.jobEntity.uid success:^(id resultDic) {
//            [self.hud hide:YES];
//            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
//                [YQToast yq_ToastText:@"投递成功" bottomOffset:100];
//                [self.deliveryButton setTitle:@"已投递" forState:UIControlStateNormal];
//                self.jobEntity.delivery = @"1";
//            }
//        } failure:nil];
    }
}

#pragma mark - 网络

- (void)reqPositionDetail
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] homeGetPositionDetail_uid:@"" pid:self.jobEntity.uid success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            self.detailEntity = [PositionDetailEntity PositionDetailEntityWithDict:resultDic[DATA]];
            //self.detailEntity.consultant = self.jobEntity.consultant;
            //self.detailEntity.probation = self.jobEntity.probation;
            [self initView];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark - 事件
#pragma mark ========点击公司地址========
- (void)goAddressHomeClick {
    
    double aNumberLat = [self.detailEntity.lat doubleValue];
    double aNumberLng = [self.detailEntity.lng doubleValue];
    
    NSLog(@"1   %@",self.detailEntity.lat);
    NSLog(@"2   %@",self.detailEntity.lng);
    NSLog(@"3   %f",aNumberLat);
    NSLog(@"4   %f",aNumberLng);
    
    EaseLocationViewController *locationController = [[EaseLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(aNumberLat, aNumberLng)];
    [self.navigationController pushViewController:locationController animated:YES];
    
}

- (void)goCompanyHomePage
{
    CompanyDetailController *vc = [[CompanyDetailController alloc] init];
    vc.memberId = self.detailEntity.puid;
    vc.companyId = self.detailEntity.companyid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goHomePage
{
    MemberDetailController *vc = [[MemberDetailController alloc] init];
    vc.memberId = self.detailEntity.puid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ========分享职位========
- (void)sharePosition:(UIButton *)sender
{
    [self shareView];
}

#pragma mark ========关注职位========
- (void)followPosition:(UIButton *)sender
{
    [self.hud show:YES];
    NSString *attention = [self.jobEntity.payposition isEqualToString:@"1"] ? @"2" : @"1";

    [[RequestManager sharedRequestManager] homeGetPositionFollow_uid:[UserEntity getUid] positionid:self.jobEntity.uid puid:self.jobEntity.puid attention:attention success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            //UIButton *button = self.navigationItem.rightBarButtonItem.customView;
            if ([self.jobEntity.payposition isEqualToString:@"1"]) {
                [YQToast yq_ToastText:@"已取消关注" bottomOffset:100];
                self.jobEntity.payposition = @"2";
                [sender setImage:[UIImage imageNamed:@"position_unfollow"] forState:UIControlStateNormal];
            }else{
                [YQToast yq_ToastText:@"已关注成功" bottomOffset:100];
                self.jobEntity.payposition = @"1";
                [sender setImage:[UIImage imageNamed:@"position_follow"] forState:UIControlStateNormal];
            }
            
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)recommendClick:(UIButton *)sender
{
    RecommendPositionController *vc = [[RecommendPositionController alloc] init];
    vc.puid = self.detailEntity.puid;
    vc.companyname = self.detailEntity.cname;
    vc.positionid = self.detailEntity.positionid;
    vc.pname = self.jobEntity.position_class_name;
    if (vc.pname == nil) {
        vc.pname = @"";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goChatClick:(UIButton *)sender
{
#pragma mark ========去聊天========
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.detailEntity.hx_username conversationType:EMConversationTypeChat];
    //    chatController.dataSource = self;12345
    //    chatController.showRefreshHeader = YES;
    chatController.title = self.detailEntity.name;
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
    
#pragma mark ========把对方的信息保存到数据库========
    NSString *userid = self.jobEntity.uid;
    NSString *username = self.detailEntity.name;
    NSString *userheadpath = [NSString stringWithFormat:@"%@%@",ImageURL,self.detailEntity.avatar];
    NSString *hxuserid = self.detailEntity.hx_username;
    NSDictionary *dict = @{kProfileUserID:userid,kProfileUserName:username,kProfileUserHeadPath:userheadpath,kHXUserID:hxuserid};
    [UserInfo insertDataWithData:dict];
    
#pragma mark ========保存自己的信息========
    [self saveSelfInfo];
}

- (void)saveSelfInfo
{
    NSString *userid = [UserEntity getUid];
    NSString *username = [UserEntity getNickName];
    NSString *userpath = [UserEntity getHeadImgUrl];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:userid forKey:kProfileUserID];
    [mDict setObject:username forKey:kProfileUserName];
    [mDict setObject:userpath forKey:kProfileUserHeadPath];
    [mDict setObject:[UserEntity getHXUserName] forKey:kHXUserID];
    
    [UserInfo insertDataWithData:mDict];
}

- (void)addSubConstraint:(UIView *)view toView:(UIView *)cell
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [cell addSubview:view];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.yq_height]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:APP_WIDTH]];
}

#pragma mark ========将要执行分享的时候调用========
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

#pragma mark ========设置分享参数========
- (NSMutableDictionary *)getShateParameters
{
//    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
//    YQDiscoverFrame *frame = item.tableViewArray[curIndexPath.row];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *title = [NSString stringWithFormat:@"出钱找人:%@招聘，推荐人才赚顾问费!",self.detailEntity.pname];
    
    NSString *image = [NSString stringWithFormat:@"%@%@",ImageURL,self.detailEntity.logo];
    NSString *urlStr = [NSString stringWithFormat:@"%@/index/positiondetail.html?pid=%@",H5BaseURL,self.detailEntity.positionid];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 通用参数设置
    
    [parameters SSDKSetupShareParamsByText:self.detailEntity.pdetails
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
