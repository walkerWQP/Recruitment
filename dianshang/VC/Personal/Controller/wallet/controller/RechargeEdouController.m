//
//  RechargeEdouController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/29.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "RechargeEdouController.h"
#import "YQPayManage.h"
#import "YQBannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RechargeEdouController ()<UIAlertViewDelegate>
{
    int flag;
}
@property (nonatomic, strong) YQBannerItem *curItem;
@property (nonatomic, strong) YQBannerView *bannerView;
@property (nonatomic, strong) NSMutableArray *bannerArray;

@property (nonatomic, strong) EdouView *curBtn;
@property (nonatomic, strong) NSMutableArray *edouArray;

@end

@implementation RechargeEdouController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值";
    
    [self reqEdouList];
    
    [self reqActivityList];
}
- (void)initImageView:(NSMutableArray *)list
{
    self.tableView.yq_y = 100;
    self.tableView.yq_height -= 100;
    
    self.bannerArray = list;
    
    YQBannerItem *item =list.firstObject;
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 100)];
    view.userInteractionEnabled = YES;
    //view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [view addGestureRecognizer:tap];
    [view sd_setImageWithURL:[NSURL URLWithString:item.image]];
}
- (void)initBannerView:(NSMutableArray *)list
{
    self.tableView.yq_y = 100;
    self.tableView.yq_height -= 100;
    
    YQBannerView *view = [[YQBannerView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 100)];
    //view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    YQWeakSelf;
    [view itemPress:^(NSInteger index, YQBannerItem *item) {
        [weakSelf goDetail:item];
    }];
    self.bannerView = view;
    self.bannerView.items = list;
    self.bannerArray = list;
}
- (void)initView
{
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.tableFooterView = [self footerView];
    self.tableView.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:self.tableView];
}
- (void)setUpdata
{
    NSMutableArray *items = [NSMutableArray array];
    
    PersonItem *item0 = [PersonItem setCellItemImage:@"person_qianbao" title:@"支付宝"];
    [items addObject:item0];
    
//    PersonItem *item1 = [PersonItem setCellItemImage:@"buysms" title:@"微信"];
//    [items addObject:item1];
    
    YQGroupCellItem *group = [YQGroupCellItem setGroupItems:items headerTitle:@"   选择充值方式" footerTitle:nil];
    [self.groups addObject:group];
}

- (UIView *)headerView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, APP_WIDTH, 0)];
    contentView.backgroundColor = [UIColor clearColor];
    //[scroller addSubview:contentView];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 35)];
    titlelabel.text = @"选择充值金额";
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:titlelabel];
    
    NSMutableArray *array = self.edouArray;
    
    NSInteger column = 2;
    
    CGFloat jianju = 10;
    CGFloat top = titlelabel.yq_bottom;
    
    CGFloat viewW = (contentView.yq_width - jianju*(column+1)) / column;
    CGFloat viewH = viewW*0.5;
    
    CGFloat indexX = 0;
    CGFloat indexY = 0;
    CGFloat height = 200;
    
    for (int i = 1; i <= array.count; i++) {
        CGFloat x = indexX * viewW + (jianju*(indexX+1));
        CGFloat y = indexY * viewH + (jianju*(indexY+1));
        
        EdouItem *item = [array objectAtIndex:i-1];
        
        EdouView *view = [[EdouView alloc] init];
        view.frame = CGRectMake(x, y+top, viewW, viewH);
        [view setTitle:item.priceStr forState:UIControlStateNormal];
        view.subTitle = item.title;
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.item = item;
        [view setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [view setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setBackgroundColor:THEMECOLOR forState:UIControlStateSelected];
        [view addTarget:self action:@selector(selectEdou:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:view];
        
        if (i == 1) {
            view.selected = YES;
            view.subTitleColor = [UIColor whiteColor];
            self.curBtn = view;
        }
        
        indexX++;
        if (i % column == 0) {
            indexX = 0;
            indexY ++;
        }
        
        if (i == array.count) {
            height = view.yq_bottom+10;
        }
    }
    
    contentView.yq_height = height;
    
    return contentView;
}

- (UIView *)footerView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 60)];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (contentView.yq_height-40)*0.5, APP_WIDTH-40, 40)];
    [quitBtn setBackgroundColor:RGB(241, 88, 82) forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:RGB(201, 58, 54) forState:UIControlStateHighlighted];
    [quitBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 4;
    quitBtn.layer.masksToBounds = YES;
    [quitBtn addTarget:self action:@selector(goPayClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:quitBtn];
    
    return contentView;
}

#pragma mark - tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH-35, (cell.frame.size.height-20)/2, 20, 20)];
        image.tag = 100;
        [cell addSubview:image];
    }
    if (indexPath.row == flag) {
        ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageNamed:@"select1"];
    }else{
        ((UIImageView *)[cell viewWithTag:100]).image = [UIImage imageNamed:@"select1_un"];
    }
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = item.title;
    cell.imageView.image = [UIImage imageNamed:item.image];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.groups.count > 0) {
        YQGroupCellItem *group = [self.groups objectAtIndex:section];
        if (![group.headerTitle isEqualToString:@""] && group.headerTitle != nil) {
            UILabel *footView = [[UILabel alloc] init];
            footView.textColor = RGB(51, 51, 51);
            footView.textAlignment = NSTextAlignmentLeft;
            footView.font = [UIFont systemFontOfSize:16];
            footView.text = group.headerTitle;
            return footView;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    flag = (int)indexPath.row;
    [self.tableView reloadData];
}

- (void)selectEdou:(EdouView *)sender
{
    self.curBtn.selected = NO;
    self.curBtn.subTitleColor = RGB(102, 102, 102);
    sender.selected = YES;
    sender.subTitleColor = [UIColor whiteColor];
    
    self.curBtn = sender;
}
- (void)tapClick:(UIGestureRecognizer *)sender
{
    [self goDetail:self.bannerArray.firstObject];
}
- (void)goDetail:(YQBannerItem *)item
{
    self.curItem = item;
    NSString *str = [NSString stringWithFormat:@"您将购买%@个E豆,用于平台消费,总共需支付%@元",item.ext[@"coin"],item.ext[@"nowprice"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"优惠活动" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即购买", nil];
    alert.tag = 1000;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            YQPayManage *manage = [[YQPayManage alloc] init];
            
            YQPayMode model = YQPayModeAli;
            if (flag == 1) {
                model = YQPayModeWX;
            }
            NSDictionary *dict = self.curItem.ext;
            NSString *orderId = @"";
            NSString *money = dict[@"nowprice"];
            //CGFloat money = [str floatValue];
            
            [manage handlePayMode:model orderType:YQPayOrderEdouActivityType orderid:orderId money:money handleBlock:^(NSInteger code,YQPayMode model, NSString *codeMsg, NSString *errorStr) {
                if (code == 1000) {
                    [YQToast yq_ToastText:@"支付成功" bottomOffset:100];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if (code == 2000){
                    [YQToast yq_AlertText:@"支付失败"];
                }else if (code == 3000){
                    [YQToast yq_AlertText:@"支付取消"];
                }
            }];
        }
    }
}
- (void)goPayClick
{
    YQPayManage *manage = [[YQPayManage alloc] init];
    
    YQPayMode model = YQPayModeAli;
    if (flag == 1) {
        model = YQPayModeWX;
    }
    NSString *orderId = @"";
    NSString *money = self.curBtn.item.price;
    
    [manage handlePayMode:model orderType:YQPayOrderEdouType orderid:orderId money:money handleBlock:^(NSInteger code,YQPayMode model, NSString *codeMsg, NSString *errorStr) {
        if (code == 1000) {
            [YQToast yq_ToastText:@"支付成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (code == 2000){
            [YQToast yq_AlertText:@"支付失败"];
        }else if (code == 3000){
            [YQToast yq_AlertText:@"支付取消"];
        }
    }];
}

- (void)reqActivityList
{
    NSString *type = @"3";
    [[RequestManager sharedRequestManager] getDiscoverBanner_uid:@"" type:type success:^(id resultDic) {
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in resultDic[DATA]) {
                YQBannerItem *item = [[YQBannerItem alloc] init];
                item.image = [NSString stringWithFormat:@"%@%@",ImageURL,dic[@"imgurl"]];
                item.url = dic[@"link"];
                item.ext = dic;
                [list addObject:item];
            }
            if (list.count > 1) {
                [self initBannerView:list];
            }else{
                [self initImageView:list];
            }
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
- (void)reqEdouList
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getEdoulist_uid:nil success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            NSArray *list = resultDic[DATA];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in list) {
                EdouItem *item = [[EdouItem alloc] init];
                item.price = dict[@"price"];
                item.priceStr = [NSString stringWithFormat:@"%@元",dict[@"price"]];
                item.title = [NSString stringWithFormat:@"%@E豆",dict[@"coin"]];
                [array addObject:item];
            }
            self.edouArray = array;
            
            if (array.count > 0) {
                [self initView];
                [self setUpdata];
            }
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

@implementation EdouItem

@end

@interface EdouView ()

@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation EdouView

- (UILabel *)subLabel
{
    if (_subLabel == nil) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.frame.size.width, self.yq_height / 5*2);
        _subLabel.text = _subTitle;
        _subLabel.textColor = RGB(102, 102, 102);
        _subLabel.font = [UIFont systemFontOfSize:14];
        _subLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float h = self.yq_height / 5 * 3;
    self.titleLabel.frame = CGRectMake(0, 10, self.yq_width, h-10);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubTitle];
}

//- (void)setSubTitle:(NSString *)subTitle
//{
//    if (subTitle.length) {
//        _subTitle = subTitle;
//        [self addSubTitle];
//    }
//}

- (void)addSubTitle
{
    [self addSubview:self.subLabel];
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    
    self.subLabel.text = subTitle;
}
- (void)setSubTitleColor:(UIColor *)subTitleColor
{
    self.subLabel.textColor = subTitleColor;
}

@end
