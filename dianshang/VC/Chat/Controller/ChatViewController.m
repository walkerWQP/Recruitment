//
//  ChatViewController.m
//  huanxin
//
//  Created by yunjobs on 2017/10/11.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatDemoHelper.h"
#import "NSString+MyDate.h"
#import "YQCustomButton.h"

#import "CompanyPersonalDetailVC.h"
#import "CompanyHomeEntity.h"

#import "PositionDetailEntity.h"
#import "MemberDetailController.h"
#import "RechargeEdouController.h"

#import "NSString+RegularExpression.h"
#import "NSString+Hash.h"

@interface ChatViewController ()<UIAlertViewDelegate>

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, strong) PositionDetailEntity *detailEntity;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *hxname = [UserEntity getHXUserName];
    NSString *hxpass = @"123456".md5String;
    [[EMClient sharedClient] loginWithUsername:hxname password:hxpass completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            CLog(@"环信->登录成功");
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        } else {
            CLog(@"环信->登录失败");
        }
    }];
    
    [[ChatDemoHelper shareHelper] setChatVC:nil];
    //self.view.backgroundColor = [UIColor whiteColor];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self initTopView];
    
    
    // 添加视频回调通知,
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessage:) name:KNOTIFICATION_CHAT_RELOADMESSAGE object:nil];
}

- (void)initTopView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSArray *array = @[@"交换微信",@"交换电话",@"发送简历",@"举报"];
    NSArray *imgArray = @[@"chat_wx",@"chat_phone",@"chat_remuse",@"chat_report"];
    
    
    
    if ([UserEntity getIsCompany] && [self.isFastStr isEqualToString:@"2"]) {
        array = @[@"交换微信",@"交换电话",@"急速联系",@"举报"];
        imgArray = @[@"chat_wx",@"chat_phone",@"contact",@"chat_report"];
    } else {
        array = @[@"交换微信",@"交换电话",@"发送简历",@"举报"];
        imgArray = @[@"chat_wx",@"chat_phone",@"chat_remuse",@"chat_report"];
    }
    
    CGFloat w = view.yq_width/ array.count;
    CGFloat h = view.yq_height;
    
    CGFloat indexX = 0;
    CGFloat indexY = 0;
    for (int i = 1; i <= array.count; i++) {
        CGFloat x = indexX * w;
        CGFloat y = indexY * h;
        
        //PersonItem *item = array[i-1];
        
        YQCustomButton *button = [[YQCustomButton alloc] init];
        button.frame = CGRectMake(x, y, w, h);
        [button setImage:[UIImage imageNamed:imgArray[i-1]] forState:UIControlStateNormal];
        [button setTitle:array[i-1] forState:UIControlStateNormal];
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.type = CustomButtonTypeScale;
        button.scale = 0.5;
        if (array.count == 3) {
            button.tag = i-1;
        } else {
            
            if (i == 1) {
                button.tag = 0;
            }else if (i == 2){
                button.tag = 1;
            }else if (i == 3){
                button.tag = 3;
            }else if (i == 4){
                button.tag = 2;
            }
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        //button.backgroundColor = RandomColor;
        
        if (i != array.count) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.yq_right, 10, 0.5, 40)];
            lineView.backgroundColor = RGB(180, 180, 180);
            [view addSubview:lineView];
        }
        
        indexX++;
    }
}
- (void)buttonClick:(UIButton *)sender
{
    // 发送一条简历消息
    //[self sendImageMessage:[UIImage imageNamed:@"jianli"] withExt:@{@"lyqKeyResume":@"resume"}];
    
    if (sender.tag == 0) {//交换微信
        NSString *str = [UserEntity getWechatid];
        if (str.length != 0) {
            NSDictionary *ext = @{kKeyFlag:kWXFlag,kSendTextFlag:@"请求交换微信",kRecvTextFlag:@"我想要和您交换微信,您是否同意",kReplyFlag:@"-1",kNumberFlag:str};
            [self sendTextMessage:@"[交换微信]" withExt:ext];
        }else{
            [self changeWXid];
        }
        
    }else if (sender.tag == 1) {//交换电话
        
        NSDictionary *ext = @{kKeyFlag:kTelFlag,kSendTextFlag:@"请求交换电话",kRecvTextFlag:@"我想要和您交换电话,您是否同意",kReplyFlag:@"-1",kNumberFlag:[UserEntity getPhone]};
        [self sendTextMessage:@"[交换电话]" withExt:ext];
    }else if (sender.tag == 3) {//发送简历   添加急速联系判断
        if ([UserEntity getIsCompany] && [self.isFastStr isEqualToString:@"2"]) {
            
            if (self.talentHx_username != nil && [UserEntity getUid] != nil) {
                [self getPhoneNumber];
            }
            
        } else {
            NSDictionary *ext = @{kKeyFlag:kResumeFlag,kResumeTitleFlag:[UserEntity getNickName],kResumeDesFlag:@"点击查看微简历",kResumeImgFlag:[UserEntity getHeadImgUrl],kResumeLinkFlag:@"http://www.baidu.com"};
            [self sendTextMessage:@"[简历]" withExt:ext];
        }
        
    }else if (sender.tag == 2) {//举报
        NSString *s = self.conversation.conversationId;
        [self showHudInView:self.view hint:@""];
        [[RequestManager sharedRequestManager] chatReportUser_uid:[UserEntity getUid] ruid:s success:^(id resultDic) {
            [self hideHud];
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
            }else if ([resultDic[CODE] isEqualToString:@"100002"]){
                [YQToast yq_ToastText:resultDic[@"msg"] bottomOffset:100];
            }
        } failure:^(NSError *error) {
            
            NSLog(@"网络连接错误");
        }];
    }
}

#pragma mark ========企业获取急速求职者联系方式========
- (void)getPhoneNumber {
    
    [[RequestManager sharedRequestManager] getPersonalPhone_uid:[UserEntity getUid] hx_username:self.talentHx_username success:^(id resultDic) {
        
        NSLog(@"%@",resultDic[MSG]);
        
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) { //网络请求成功
            
            NSMutableDictionary *dic = [resultDic objectForKey:@"data"];
            
            NSLog(@"%@",[dic objectForKey:@"ishave"]);
            
            if ([[dic objectForKey:@"ishave"] isEqualToString:@"2"]) { //已经支付过e豆，直接获取
                UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"联系方式" message:[dic objectForKey:@"phone"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了拨打电话");
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[dic objectForKey:@"phone"]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    
                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = [dic objectForKey:@"phone"];
                    
                }];
                
                [actionSheet addAction:action1];
                [actionSheet addAction:action2];
                
                [self presentViewController:actionSheet animated:YES completion:nil];
                
            } else if ([[dic objectForKey:@"ishave"] isEqualToString:@"1"]) {
                UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"将消耗30e豆, 获取人才急速联系方式" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (self.talentHx_username != nil && [UserEntity getUid] != nil) {
                        [self getRapidPhoneNumber];
                    }
                    
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [actionSheet addAction:action1];
                [actionSheet addAction:action2];
                
                [self presentViewController:actionSheet animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {
        
        NSLog(@"网络连接错误");
    }];
    
}

#pragma mark ========消耗30e豆获取人才联系方式========
- (void)getRapidPhoneNumber {
    
    [[RequestManager sharedRequestManager] setDecEDou_uid:[UserEntity getUid] hx_username:self.talentHx_username success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
           
            NSMutableDictionary *dic = [resultDic objectForKey:@"data"];
            
            if ([[dic objectForKey:@"ishave"] isEqualToString:@"2"]) {
                
                UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"联系方式" message:[dic objectForKey:@"phone"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了拨打电话");
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[dic objectForKey:@"phone"]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    
                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = [dic objectForKey:@"phone"];
                    
                }];
                
                [actionSheet addAction:action1];
                [actionSheet addAction:action2];
                
                [self presentViewController:actionSheet animated:YES completion:nil];
                
            } else if ([[dic objectForKey:@"ishave"] isEqualToString:@"1"]) {
                UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了确定");
                    
                    RechargeEdouController *vc = [[RechargeEdouController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了取消");
                }];
                
                [actionSheet addAction:action1];
                [actionSheet addAction:action2];
                
                [self presentViewController:actionSheet animated:YES completion:nil];
            }
            
        }
        
    } failure:^(NSError *error) {
        
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
    tf.text = @"";
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1002){
        // 微信号
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            //self.wechatid = tf.text;
            if (tf.text.length>0) {
                [self changePersonInfo_Wechatid:tf.text];
            }
        }
    }
}

- (void)changePersonInfo_Wechatid:(NSString *)wxid
{
    if (wxid.length == 0) {
        [YQToast yq_ToastText:@"填写微信号" bottomOffset:100];
    }else{
        // 修改微信号 (企业和人才类型不同)
        if ([UserEntity getIsCompany]) {
            [self company_Wechatid:wxid];
        }else{
            [self person_Wechatid:wxid];
        }
    }
}
- (void)company_Wechatid:(NSString *)wxid
{
    [self showHudInView:self.view hint:@""];
    [[RequestManager sharedRequestManager] changeCPersonInfo_uid:[UserEntity getUid] name:@"" post:@"" wechatid:wxid team:@"" email:@"" avatar:@"" success:^(id resultDic) {
        [self hideHud];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            //[YQToast yq_ToastText:@"修改成功" bottomOffset:100];
            [UserEntity setWechatid:wxid];
            NSDictionary *ext = @{kKeyFlag:kWXFlag,kSendTextFlag:@"请求交换微信",kRecvTextFlag:@"我想要和您交换微信,您是否同意",kReplyFlag:@"-1",kNumberFlag:wxid};
            [self sendTextMessage:@"[交换微信]" withExt:ext];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"网络连接错误");
    }];
}
- (void)person_Wechatid:(NSString *)wxid
{
    [self showHudInView:self.view hint:@""];
    [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:@"" name:@"" sex:@"" birthday:@"" wechatid:wxid restatus:@"" edu:@"" year:@"" workyear:@"" success:^(id resultDic) {
        [self hideHud];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            [UserEntity setWechatid:wxid];
            NSDictionary *ext = @{kKeyFlag:kWXFlag,kSendTextFlag:@"请求交换微信",kRecvTextFlag:@"我想要和您交换微信,您是否同意",kReplyFlag:@"-1",kNumberFlag:wxid};
            [self sendTextMessage:@"[交换微信]" withExt:ext];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"网络连接错误");
    }];
}

- (void)reloadMessage:(NSNotification *)notification
{
    EMMessage *message = notification.object;
    [self addMessageToDataSource:message progress:nil];
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_CHAT_RELOADMESSAGE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ========环信自带头像点击事件========
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
    if ([[UserEntity getHXUserName] isEqualToString:[messageModel.message.ext objectForKey:@"EZHXUserID"]]) {
        
        return;
    } else {
        if ([UserEntity getIsCompany]) {  //企业账户登录时，聊天界面点击个人账户头像
            
            /*
             
             
             CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
             vc.entity = en;
             vc.isRecommend = NO;
             vc.isChat = YES;
             vc.hidesBottomBarWhenPushed = YES;
             */
            NSDictionary *dict = messageModel.message.ext;
            CompanyHomeEntity *en = [[CompanyHomeEntity alloc] init];
            en.itemId = dict[kProfileUserID];
            en.name = dict[kProfileUserName];
            en.paymember = @"-1";
            CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
            vc.hx_username = [messageModel.message.ext objectForKey:@"EZHXUserID"];
            vc.entity = en;
            vc.isRecommend = NO;
            vc.isChat = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            MemberDetailController *vc = [[MemberDetailController alloc] init];
            vc.memberId = [messageModel.message.ext objectForKey:@"EZProfileUserID"];
            vc.hx_username = [messageModel.message.ext objectForKey:@"EZHXUserID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


/*!
 @method
 @brief 点击了简历消息 (lyq添加)
 @discussion 点击了简历消息,如果使用,用户必须要自定义处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 */

- (void)messageViewController:(EaseMessageViewController *)viewController didResumeSelectForModel:(id<IMessageModel>)messageModel
{
    NSDictionary *dict = messageModel.message.ext;
    // 点击后跳转
    CompanyHomeEntity *en = [[CompanyHomeEntity alloc] init];
    en.itemId = dict[kProfileUserID];
    en.name = dict[kProfileUserName];
    en.paymember = @"-1";
    
    CompanyPersonalDetailVC *vc = [[CompanyPersonalDetailVC alloc] init];
    vc.entity = en;
    vc.isRecommend = NO;
    vc.isChat = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/*!
 @method
 @brief 点击了同意或者拒绝 0-同意;1-拒绝 (lyq添加)
 @discussion 点击了交换信息,如果使用,用户必须要自定义处理
 @param viewController 当前消息视图
 @param messageModel 消息模型
 */
- (void)messageViewController:(EaseMessageViewController *)viewController didCellButtonSelectForModel:(id<IMessageModel>)messageModel buttonIndex:(NSInteger)buttonIndex
{
    NSString *lyqKey = [messageModel.message.ext objectForKey:kKeyFlag];
    
    if (buttonIndex == 1) {
        // 拒绝交换
        if ([lyqKey isEqualToString:kWXFlag]) {
            NSDictionary *ext = @{kKeyFlag:kWXFlag,kSendTextFlag:@"您已成功拒绝了对方交换微信请求",kRecvTextFlag:@"对方拒绝了您的交换微信请求",kReplyFlag:@"1"};
            [self sendTextMessage:@"[交换微信]" withExt:ext];
        }else if ([lyqKey isEqualToString:kTelFlag]){
            NSDictionary *ext = @{kKeyFlag:kTelFlag,kSendTextFlag:@"您已成功拒绝了对方交换电话请求",kRecvTextFlag:@"对方拒绝了您的交换电话请求",kReplyFlag:@"1"};
            [self sendTextMessage:@"[交换电话]" withExt:ext];
        }
        
    }else if (buttonIndex == 0) {
        // 同意交换
        if ([lyqKey isEqualToString:kWXFlag]) {
            NSString *wxid = [UserEntity getWechatid];
            if (wxid.length != 0) {
                NSString *recvstr = [NSString stringWithFormat:@"%@的微信号:%@",[UserEntity getNickName],wxid];
                NSString *wxstr = [messageModel.message.ext objectForKey:kNumberFlag];
                NSString *sendstr = [NSString stringWithFormat:@"%@的微信号:%@",[messageModel.message.ext objectForKey:kProfileUserName],wxstr];
                NSDictionary *ext = @{kKeyFlag:kWXFlag,kSendTextFlag:sendstr,kRecvTextFlag:recvstr,kReplyFlag:@"0",kNumberFlag:wxid};
                [self sendTextMessage:@"[交换微信]" withExt:ext];
            }else{
                [self changeWXid];
            }
        }else if ([lyqKey isEqualToString:kTelFlag]){
            NSString *recvstr = [NSString stringWithFormat:@"%@的手机号:%@",[UserEntity getNickName],[UserEntity getPhone]];
            NSString *wxstr = [messageModel.message.ext objectForKey:kNumberFlag];
            NSString *sendstr = [NSString stringWithFormat:@"%@的手机号:%@",[messageModel.message.ext objectForKey:kProfileUserName],wxstr];
            NSDictionary *ext = @{kKeyFlag:kTelFlag,kSendTextFlag:sendstr,kRecvTextFlag:recvstr,kReplyFlag:@"0",kNumberFlag:[UserEntity getPhone]};
            [self sendTextMessage:@"[交换电话]" withExt:ext];
        }
    }
}
//- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
//{
//    NSMutableArray *emotions = [NSMutableArray array];
//    for (NSString *name in [EaseEmoji allEmoji]) {
//        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
//        [emotions addObject:emotion];
//    }
//    EaseEmotion *temp = [emotions objectAtIndex:0];
//    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
//    
//    NSMutableArray *emotionGifs = [NSMutableArray array];
//    _emotionDic = [NSMutableDictionary dictionary];
//    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
//    int index = 0;
//    for (NSString *name in names) {
//        index++;
//        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
//        [emotionGifs addObject:emotion];
//        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
//    }
//    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
//    
//    return @[managerDefault,managerGif];
//}
//
//- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
//                                      messageModel:(id<IMessageModel>)messageModel
//{
//    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
//    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
//    if (emotion == nil) {
//        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
//    }
//    return emotion;
//}
//
//- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController messageModel:(id<IMessageModel>)messageModel
//{
//    BOOL flag = NO;
//    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
//        return YES;
//    }
//    return flag;
//}
//
//- (void)messageViewController:(EaseMessageViewController *)viewController didResumeSelectForModel:(id<IMessageModel>)messageModel
//{
//    
//}
//
///*!
// @method
// @brief 将要接收离线消息的回调
// @discussion
// @result
// */
//- (void)willReceiveOfflineMessages
//{
//    
//}
//
///*!
// @method
// @brief 接收到离线非透传消息的回调
// @discussion
// @param offlineMessages 接收到的离线列表
// @result
// */
//- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
//{
//    
//}
//
///*!
// @method
// @brief 离线非透传消息接收完成的回调
// @discussion
// @param offlineMessages 接收到的离线列表
// @result
// */
//- (void)didFinishedReceiveOfflineMessages
//{
//    
//}
//
///*!
// @method
// @brief 接收到离线透传消息的回调
// @discussion
// @param offlineCmdMessages 接收到的离线透传消息列表
// @result
// */
//- (void)didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages
//{
//    
//}
//
///*!
// @method
// @brief 离线透传消息接收完成的回调
// @discussion
// @param offlineCmdMessages 接收到的离线透传消息列表
// @result
// */
//- (void)didFinishedReceiveOfflineCmdMessages
//{
//    
//}
//
///*!
// @method
// @brief 收到消息时的回调
// @param message      消息对象
// @discussion 当EMConversation对象的enableReceiveMessage属性为YES时，会触发此回调
// 针对有附件的消息，此时附件还未被下载。
// 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:，
// 下载完所有附件后，回调didMessageAttachmentsStatusChanged:error:会被触发
// */
//
//
///*!
// @method
// @brief 未读消息数改变时的回调
// @discussion 当EMConversation对象的enableUnreadMessagesCountEvent为YES时，会触发此回调
// @result
// */
//- (void)didUnreadMessagesCountChanged
//{
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
