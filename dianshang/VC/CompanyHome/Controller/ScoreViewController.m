//
//  ScoreViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/12/20.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "ScoreViewController.h"
#import "JWStarView.h"

@interface ScoreViewController ()<JWStarViewViewDelegate>

@property (nonatomic, strong) UILabel *scoreLbl;

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评分";
    self.fd_interactivePopDisabled = YES;
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithtitle:@"提交" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self initView];
}

- (void)initView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, APP_WIDTH-40, 40)];
    label.text = @"给ta评分:";
    //label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    
    JWStarView *star = [[JWStarView alloc]initWithFrame:CGRectMake(20, label.yq_bottom, APP_WIDTH-40-60, 40)];
    star.rateStyle = HalfStar;
    star.currentScore = 5;
    star.delegate = self;
    [self.view addSubview:star];
    
    UILabel *scorelabel = [[UILabel alloc] initWithFrame:CGRectMake(star.yq_right, star.yq_y, 60, 40)];
    scorelabel.text = @"100";
    scorelabel.font = [UIFont systemFontOfSize:17];
    scorelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:scorelabel];
    
    self.scoreLbl = scorelabel;
}

-(void)starView:(JWStarView *)starView currentScore:(CGFloat)currentScore
{
    self.scoreLbl.text = [NSString stringWithFormat:@"%g",currentScore*20];
}

- (void)rightClick:(UIButton *)sender
{
    //
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] companyScore_uid:[UserEntity getUid] rid:self.rid shareid:self.shareid grade:self.scoreLbl.text success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"评分提交成功" bottomOffset:100];
            if (self.backBlock) {
                self.backBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
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
