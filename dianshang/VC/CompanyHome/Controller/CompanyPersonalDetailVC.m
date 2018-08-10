//
//  CompanyPersonalDetailVC.m
//  dianshang
//
//  Created by yunjobs on 2017/11/30.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyPersonalDetailVC.h"
#import "ChatViewController.h"
#import "ScoreViewController.h"
#import "BusinessDetailController.h"

#import "ResumeBrowerDetail.h"

#import "CompanyHomeEntity.h"
#import "ResumeManageEntity.h"
#import "RechargeEdouController.h"

#import "UserInfo+CoreDataClass.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YQViewController+YQShareMethod.h"

@interface CompanyPersonalDetailVC ()<UIAlertViewDelegate>

@property (nonatomic, strong) ResumeManageEntity *rmEntity;
@property (nonatomic, strong) UIScrollView *scroller;

@property (nonatomic, strong) UIView *recommendView;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *phoneButton;
@property (nonatomic, strong) NSString *phoneStr;

@property (nonatomic, strong) UIButton *scoreBtn;
@end

@implementation CompanyPersonalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.entity.name;
    
    [self setNav];
    
    [self reqResumeDetail];
}
- (void)setNav
{
    NSMutableArray *itemArr = [NSMutableArray array];
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"position_share" highImage:@"position_share" target:self action:@selector(sharePosition:)];
    [itemArr addObject:item];
    
    if ([self.entity.paymember isEqualToString:@"1"]) {
        UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"position_follow" highImage:@"position_follow" target:self action:@selector(followPosition:)];
        [itemArr addObject:item];
    }else if ([self.entity.paymember isEqualToString:@"-1"]) {
        
    }else{
        UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"position_unfollow" highImage:@"position_unfollow" target:self action:@selector(followPosition:)];
        [itemArr addObject:item];
    }
    
    self.navigationItem.rightBarButtonItems = itemArr;
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
    NSString *url = [NSString stringWithFormat:@"%@%@",ImageURL,self.entity.ravatar];
    [headImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"headImg"]];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(headImg.yq_right+10, headImg.yq_y, w-headImg.yq_right-20-90, 30)];
    titlelabel.text = self.entity.rname;
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:16];
    [headView addSubview:titlelabel];
    
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(titlelabel.yq_x, titlelabel.yq_bottom, w-headImg.yq_right-20, 20)];
    NSString *str = [NSString stringWithFormat:@"靠谱值:%@",self.entity.reliable];
    subTitle.text = str;
    subTitle.textColor = RGB(102, 102, 102);
    subTitle.font = [UIFont systemFontOfSize:14];
    [headView addSubview:subTitle];
    
    if ([UserEntity getIsCompany]) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(titlelabel.yq_right, titlelabel.yq_y, 90, titlelabel.yq_height)];
        [button setTitle:@"简历靠谱吗?" forState:UIControlStateNormal];
        [button setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(scoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
        self.scoreBtn = button;
        
        if ([self.entity.grade_status isEqualToString:@"1"]) {
            [self.scoreBtn setTitle:@"已评分" forState:UIControlStateNormal];
            self.scoreBtn.enabled = NO;
        }
    }
}

- (void)initBottomView
{
    NSArray *array = @[@"查看联系方式(30个E豆)"];
    if (self.isRecommend) {
        if ([self.entity.phone_status isEqualToString:@"1"]) {
            self.phoneStr = self.entity.phone;
            array = @[self.phoneStr,@"立即沟通"];
        }
    }else{
        array = @[@"立即沟通"];
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT-APP_NAVH-(60+APP_BottomH), APP_WIDTH, 60+APP_BottomH)];
    bottomView.backgroundColor = RGB(243, 243, 243);
    
    CGFloat jianju = 10;
    CGFloat w = (APP_WIDTH - jianju*(array.count+1)) / array.count;
    CGFloat h = 35;
    CGFloat y = (40-35)*0.5+10;
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(jianju*(i+1)+i*w, y, w, h)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [bottomView addSubview:button];
        if (array.count > 1) {
            if (i == 0) {
                [self setButton1:button];
                [button addTarget:self action:@selector(goPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
                self.phoneButton = button;
            }else{
                [button addTarget:self action:@selector(goChatClick:) forControlEvents:UIControlEventTouchUpInside];
                [self setButton:button];
                self.chatButton = button;
            }
        }else{
            if (i == 0) {
                if ([array[i] isEqualToString:@"立即沟通"]) {
                    [button addTarget:self action:@selector(goChatClick:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [button addTarget:self action:@selector(goPayClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self setButton:button];
                self.chatButton = button;
            }
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
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    [self.view addSubview:scroller];
    self.scroller = scroller;
    
    if (self.isRecommend) {
        [self initRecommendView:scroller];
    }
    
    if (!self.isChat) {
        [self initBottomView];
        scroller.yq_height -= (60+APP_BottomH);
    }
    
    ResumeManageEntity *en = self.rmEntity;
    
    ResumeBrowerDetail *detailView = [ResumeBrowerDetail ResumeBrowerDetailView];
    detailView.yq_y = self.recommendView.yq_bottom+8;
    detailView.yq_width = APP_WIDTH;
    detailView.yq_height = [ResumeBrowerDetail detailViewHeight:en];
    detailView.entity = en;
    YQWeakSelf;
    detailView.previewClick = ^(ResumeManageEntity *entity) {
        [weakSelf previewResume:entity];
    };
    // 如果是推荐就不显示附件简历
    if (self.isRecommend) {
        detailView.isPreviewBtn = YES;
    }
    [scroller addSubview:detailView];
    
    // 工作经历
    CGFloat workBottom = detailView.yq_bottom;
    NSMutableArray *workArray = en.work;
    if (workArray.count > 0) {
        UIView *workView = [[UIView alloc] initWithFrame:CGRectMake(0, detailView.yq_bottom, APP_WIDTH, 200)];
        workView.backgroundColor = [UIColor whiteColor];
        [scroller addSubview:workView];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
        image.image = [UIImage imageNamed:@"personal_work"];
        [workView addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(image.yq_right+8, image.yq_y, 200, 25)];
        label.text = @"工作经历";
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14];
        [workView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, label.yq_bottom+8, workView.yq_width-30, 0.5)];
        lineView.backgroundColor = RGB(180, 180, 180);
        [workView addSubview:lineView];
        
        CGFloat bottom = lineView.yq_bottom+8;
        for (ResumeManageSubEntity *entity in workArray) {
            RBDetailSubView *subView = [RBDetailSubView RBDetailView];
            subView.flag = 1;
            subView.entity = entity;
            subView.yq_height = [RBDetailSubView detailViewHeight:entity.content]+50;
            subView.yq_width = workView.yq_width;
            subView.yq_y = bottom;
            [workView addSubview:subView];
            bottom = subView.yq_bottom;
        }
        
        workView.yq_height = bottom;
        workBottom = workView.yq_bottom;
        scroller.contentSize = CGSizeMake(APP_WIDTH, workBottom+50);
    }
    
#pragma mark ========项目经验========
    CGFloat projectBottom = detailView.yq_bottom;
    NSMutableArray *projectArray = en.project;
    if (projectArray.count > 0) {
        UIView *workView = [[UIView alloc] initWithFrame:CGRectMake(0, workBottom+8, APP_WIDTH, 200)];
        workView.backgroundColor = [UIColor whiteColor];
        [scroller addSubview:workView];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
        image.image = [UIImage imageNamed:@"personal_project"];
        [workView addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(image.yq_right+8, image.yq_y, 200, 25)];
        label.text = @"项目经验";
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14];
        [workView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, label.yq_bottom+8, workView.yq_width-30, 0.5)];
        lineView.backgroundColor = RGB(180, 180, 180);
        [workView addSubview:lineView];
        
        CGFloat bottom = lineView.yq_bottom+8;
        for (ResumeManageSubEntity *entity in projectArray) {
            RBDetailSubView *subView = [RBDetailSubView RBDetailView];
            subView.flag = 2;
            subView.entity = entity;
            subView.yq_height = [RBDetailSubView detailViewHeight:entity.describetion]+50;
            subView.yq_width = workView.yq_width;
            subView.yq_y = bottom;
            [workView addSubview:subView];
            bottom = subView.yq_bottom;
        }
        
        workView.yq_height = bottom;
        projectBottom = workView.yq_bottom;
        scroller.contentSize = CGSizeMake(APP_WIDTH, projectBottom+50);
    }
    
#pragma mark ========教育经历========
    
    CGFloat eduBottom = detailView.yq_bottom;
    NSMutableArray *eduArray = en.edus;
    if (eduArray.count > 0) {
        UIView *workView = [[UIView alloc] initWithFrame:CGRectMake(0, projectBottom+8, APP_WIDTH, 200)];
        workView.backgroundColor = [UIColor whiteColor];
        [scroller addSubview:workView];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
        image.image = [UIImage imageNamed:@"personal_edu"];
        [workView addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(image.yq_right+8, image.yq_y, 200, 25)];
        label.text = @"教育经历";
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14];
        [workView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, label.yq_bottom+8, workView.yq_width-30, 0.5)];
        lineView.backgroundColor = RGB(180, 180, 180);
        [workView addSubview:lineView];
        
        CGFloat bottom = lineView.yq_bottom+8;
        for (ResumeManageSubEntity *entity in eduArray) {
            RBDetailSubView *subView = [RBDetailSubView RBDetailView];
            subView.flag = 3;
            subView.entity = entity;
            subView.yq_height = [RBDetailSubView detailViewHeight:entity.describetion]+50;
            subView.yq_width = workView.yq_width;
            subView.yq_y = bottom;
            [workView addSubview:subView];
            bottom = subView.yq_bottom;
        }
        
        workView.yq_height = bottom;
        eduBottom = workView.yq_bottom;
        scroller.contentSize = CGSizeMake(APP_WIDTH, eduBottom+50);
    }
}
- (void)goPayClick:(UIButton *)sender
{
    CGFloat edou = [[UserEntity getEdou] floatValue];
    
    if (edou > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"需支付30个E豆查看人才的联系方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认支付", nil];
        alert.tag = 1000;
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先充值E豆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去充值", nil];
        alert.tag = 1001;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self.hud show:YES];
            [[RequestManager sharedRequestManager] payEdou_uid:[UserEntity getUid] positionid:self.entity.posid type:@"1" sid:self.entity.itemId success:^(id resultDic) {
                [self.hud hide:YES];
                if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                    self.entity.phone_status = @"1";
                    [self.chatButton.superview removeFromSuperview];
                    [self initBottomView];
                }
            } failure:^(NSError *error) {
                [self.hud hide:YES];
                NSLog(@"网络连接错误");
            }];
        }
    }else if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            RechargeEdouController *vc = [[RechargeEdouController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneStr]]];
        }
    }
}

- (void)scoreBtnClick
{
    ScoreViewController *vc = [[ScoreViewController alloc] init];
    vc.rid = self.entity.rid;
    vc.shareid = self.entity.itemId;
    YQWeakSelf;
    vc.backBlock = ^{
        [weakSelf.scoreBtn setTitle:@"已评分" forState:UIControlStateNormal];
        weakSelf.scoreBtn.enabled = NO;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goPhoneClick:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.phoneStr message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    alert.tag = 1002;
    [alert show];
}
- (void)goChatClick:(UIButton *)sender
{
#pragma mark ========去聊天========
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.rmEntity.hx_username conversationType:EMConversationTypeChat];
    //    chatController.dataSource = self;
    //    chatController.showRefreshHeader = YES;
    chatController.title = self.rmEntity.name;
    chatController.hidesBottomBarWhenPushed = YES;
    
    
    chatController.isFastStr = self.entity.isfast;
    chatController.talentHx_username = self.rmEntity.hx_username;
    
    [self.navigationController pushViewController:chatController animated:YES];
    
#pragma mark ========把对方的信息保存到数据库========
    NSString *userid = self.entity.itemId;
    NSString *username = self.rmEntity.name;
    NSString *userheadpath = [NSString stringWithFormat:@"%@%@",ImageURL,self.rmEntity.avatar];
    NSString *hxuserid = self.rmEntity.hx_username;
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
- (void)previewResume:(ResumeManageEntity *)entity
{
    NSDictionary *dict = entity.asset;
    
    BusinessDetailController *detail = [[BusinessDetailController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.urlStr = [NSString stringWithFormat:@"%@%@",ImageURL,[dict objectForKey:@"filepath"]];
    detail.webTitle = @"预览";
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ========分享简历========
- (void)sharePosition:(UIButton *)sender
{
    [self shareView];
}


#pragma mark ========关注职位========
- (void)followPosition:(UIButton *)sender
{
    [self.hud show:YES];
    //NSString *attention = [self.entity.paymember isEqualToString:@"1"] ? @"2" : @"1";
    
    [[RequestManager sharedRequestManager] followPersonList_uid:[UserEntity getUid] mid:self.entity.itemId success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            //UIButton *button = self.navigationItem.rightBarButtonItem.customView;
            if ([self.entity.paymember isEqualToString:@"1"]) {
                [YQToast yq_ToastText:@"已取消关注" bottomOffset:100];
                self.entity.paymember = @"2";
                [sender setImage:[UIImage imageNamed:@"position_unfollow"] forState:UIControlStateNormal];
            }else{
                [YQToast yq_ToastText:@"已关注成功" bottomOffset:100];
                self.entity.paymember = @"1";
                [sender setImage:[UIImage imageNamed:@"position_follow"] forState:UIControlStateNormal];
            }
            
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)reqResumeDetail
{
    [self.hud show:YES];
    if (self.isChat && self.hx_username != nil) { ///从聊天界面来的
        [[RequestManager sharedRequestManager] getResumeDetail_uid:self.entity.itemId puid:[UserEntity getUid] type:@"2" hx_username:self.hx_username success:^(id resultDic) {
            [self.hud hide:YES];
            
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                
                ResumeManageEntity *en = [ResumeManageEntity ResumeManageEntityWithDict:resultDic[DATA]];
                self.rmEntity = en;
                
                [self initView];
            }
            
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    } else {
       
        [[RequestManager sharedRequestManager] getResumeDetail_uid:self.entity.itemId puid:[UserEntity getUid] type:@"2" hx_username:@"" success:^(id resultDic) {
            [self.hud hide:YES];
            
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                
                ResumeManageEntity *en = [ResumeManageEntity ResumeManageEntityWithDict:resultDic[DATA]];
                self.rmEntity = en;
               
                [self initView];
            }
            
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
    
    
    
}

#pragma mark - 分享视图
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
    
    NSDictionary *dict = self.rmEntity.working.firstObject;
    NSString *title = [NSString stringWithFormat:@"出钱找人:%@招聘，推荐人才赚顾问费!",dict[@"pname"]];
   
    NSString *image = [NSString stringWithFormat:@"%@%@",ImageURL,self.rmEntity.avatar];
    NSString *urlStr = [NSString stringWithFormat:@"%@/index/userinfo.html?pid=%@",H5BaseURL,self.rmEntity.uid];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 通用参数设置
    [parameters SSDKSetupShareParamsByText:self.rmEntity.desc
                                    images:image
                                       url:url
                                     title:title
                                      type:SSDKContentTypeAuto];
    return parameters;
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
