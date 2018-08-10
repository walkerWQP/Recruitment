//
//  ShareInvitationController.m
//  dianshang
//
//  Created by yunjobs on 2018/2/5.
//  Copyright © 2018年 yunjobs. All rights reserved.
//

#import "ShareInvitationController.h"
#import "YQViewController+YQShareMethod.h"

#import "YQLabel.h"
#import "YQCustomButton.h"
#import "ShareIconItem.h"

@interface ShareInvitationController ()

@end

@implementation ShareInvitationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"邀请好友";
    
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = RGB(245, 237, 114);
    
    UIImage *image = [UIImage imageNamed:@"shareInterview"];
    CGFloat w = image.size.width;
    CGFloat h = image.size.height * (APP_WIDTH/w);
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, h)];
    bgView.contentMode = UIViewContentModeScaleAspectFit;
    bgView.image = image;
    [self.view addSubview:bgView];
    
    YQLabel *label = [[YQLabel alloc] initWithFrame:CGRectMake(15, h*0.7, APP_WIDTH-30, 200)];
    label.text = @"想要推荐更多求职者简历?\n身边求职熟人少?\n邀请好友获取更多可推荐简历\n并且新注册好友可享百元大礼包";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.verticalAlignment = VerticalAlignmentTop;
    [self.view addSubview:label];
    
    [self shareView0];
}

- (void)shareView0
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *array = @[@"微信",@"微信朋友圈",@"QQ"];
    NSArray *array1 = @[@"share_icon2",@"share_icon3",@"share_icon4"];
    for (int i = 0; i < array.count; i++) {
        ShareIconItem *item = [[ShareIconItem alloc] init];
        item.title = array[i];
        item.icon = array1[i];
        [items addObject:item];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT-APP_NAVH-APP_BottomH-120, APP_WIDTH, 120)];
    [self.view addSubview:view];
    
    int x = 0;
    int y = 0;
    
    NSInteger column = 3;
    
    if (column == 0) {
        column = items.count;
    }
    float row = ceil((float)items.count / column); // 行数(向上取整)
    
    float buttonW = APP_WIDTH / column;
    float buttonH = buttonW*1.2;
    
    view.yq_height = buttonH * row + APP_BottomH;
    view.yq_y = APP_HEIGHT-APP_NAVH-APP_BottomH - view.yq_height;
    
    for (int i = 0; i < items.count; i++)
    {
        ShareIconItem *item = [items objectAtIndex:i];
        
        float buttonX = x * buttonW;
        float buttonY = y * buttonH;
        
        YQCustomButton *button = [[YQCustomButton alloc] init];
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button setImage:[UIImage imageNamed:item.icon] forState:UIControlStateNormal];
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setSubTitle:item.subTitle];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.type = CustomButtonTypeScale;
        //button.imageSize = CGSizeMake(42, 42);
        button.scale = 0.6;
        button.tag = i+1;
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        if (i==1) {
            //self.smsButton = button;
        }
        
        x++;
        if (x % column == 0) {
            y++;
            x=0;
        }
    }
}

- (void)buttonClick:(UIButton *)sender
{
    NSArray *shareSelectorNameArray = @[@"WechatSessionShare",@"WechatTimelineShare",@"QQFriendShare"];
    NSString *selectorName = shareSelectorNameArray[sender.tag-1];
    
    SEL sel = NSSelectorFromString(selectorName);
    if([self respondsToSelector:sel])
    {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL) = (void *)imp;
        func(self, sel);
    }
}

#pragma mark - 分享视图
// 将要执行分享的时候调用
- (void)shreViewWillAppear
{
    
}
// 设置分享参数
- (NSMutableDictionary *)getShateParameters
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *title = [NSString stringWithFormat:@"共享招聘顾问,找工作赚佣金,新用户立享百元红包！"];
    NSString *image = [UserEntity getHeadImgUrl];
    NSString *urlStr = [NSString stringWithFormat:@"%@/index/sharelist.html?uid=%@",H5BaseURL,[UserEntity getUid]];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 通用参数设置
    [parameters SSDKSetupShareParamsByText:@"找工作还在靠自己？上E招招聘，万人帮你推荐优质职位，我的工作从此就靠小伙伴。"
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
