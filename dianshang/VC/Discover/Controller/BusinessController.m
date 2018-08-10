//
//  BusinessController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/6.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "BusinessController.h"
#import "BusinessDetailController.h"
#import "YQBannerView.h"
#import "YQGroupTableItem.h"
#import "HHHorizontalPagingView.h"
#import "BusinessCell.h"
#import "BusinessEntity.h"
#import "BusinessModel.h"
#import "BusinessCollectionViewCell.h"
#import "YQNavigationController.h"

@interface BusinessController ()<UICollectionViewDataSource, UICollectionViewDelegate,WAdvertScrollViewDelegate>


@property (nonatomic, assign) NSInteger      curTableIndex;
@property (nonatomic, strong) UIView         *bannerSupView;
@property (nonatomic, strong) YQBannerView   *bannerView;

@property (nonatomic, strong) UIView         *titleView;
//企业推荐服务
@property (nonatomic, strong) UIView         *serviceView;

@property (nonatomic, strong) UIView         *contentView;

@property (nonatomic, strong) UICollectionView *businessCollectionView;

@property (nonatomic, strong) NSMutableArray  *dataArr;

@property (nonatomic, strong) NSMutableArray  *strDataArr;

@property (nonatomic, strong) WAdvertScrollView *titleScrollView;

@end

@implementation BusinessController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)strDataArr {
    if (!_strDataArr) {
        _strDataArr = [NSMutableArray array];
    }
    return _strDataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    
   
    
    [self getDataStr];
    
  
}

- (void)makeBusinessCollectionViewUI {
    
    
    
    if (!_businessCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(210, 0, 0, 0);
        //设置滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        layout.minimumInteritemSpacing = 1;
        //上下间距
        layout.minimumLineSpacing = 1;
        
        _businessCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT) collectionViewLayout:layout];
        _businessCollectionView.delegate = self;
        _businessCollectionView.dataSource = self;
        _businessCollectionView.showsVerticalScrollIndicator = NO;
        _businessCollectionView.showsHorizontalScrollIndicator = NO;
        _businessCollectionView.scrollEnabled = YES;
        [_businessCollectionView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_businessCollectionView];
        //注册cell
        [_businessCollectionView registerClass:[BusinessCollectionViewCell class] forCellWithReuseIdentifier:BusinessCollectionViewCell_CollectionViewCell];
        
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BusinessCollectionViewCell_CollectionViewCell forIndexPath:indexPath];
   
    cell.model = self.dataArr[indexPath.row];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((APP_WIDTH - 1.2) / 2, 90);
    
}

//点击响应方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BusinessModel *model = self.dataArr[indexPath.row];
    
    if (model.post_source.length > 0) {
//        BusinessDetailController *detail = [[BusinessDetailController alloc] init];
//        detail.hidesBottomBarWhenPushed = YES;
//        detail.urlStr = model.post_source;
//        detail.webTitle = @"详情";
//        [self.navigationController pushViewController:detail animated:YES];
        WWebViewController *WWebVC = [[WWebViewController alloc] init];
        WWebVC.url = model.post_source;
        WWebVC.webTitle = @"详情";
        WWebVC.progressColor = [UIColor blueColor];
        
        YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:WWebVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
    
    
}


- (void)initBannerView {
    NSMutableArray *bannerItems = [NSMutableArray array];
    NSArray *resultArr = @[@"home_banner1",@"home_banner2",@"home_banner3"];
    NSArray *urlArr = @[@"http://h5.welian.com/event/i/eyJhaWQiOjQyMjczfQ==",@"http://3g.tongxingzhe.cn/micWeb/html/login.html",@"http://zugeliang01.com/?icode=3JctF"];
    for (int i = 0; i < resultArr.count; i++) {
        YQBannerItem *item = [[YQBannerItem alloc] init];
        item.image = resultArr[i];
        item.url = urlArr[i];
        [bannerItems addObject:item];
    }
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 100)];
    self.bannerSupView = bannerView;
    //[self.view addSubview:bannerView];
    YQBannerView *banner = [[YQBannerView alloc] initWithFrame:CGRectMake(0, 0, bannerView.yq_width, bannerView.yq_height)];
    banner.items = bannerItems;
    //banner.backgroundColor = RandomColor;
    banner.pageControlShowStyle = YQPageControlShowStyleRight;
    [bannerView addSubview:banner];
//    YQWeakSelf;
    [banner itemPress:^(NSInteger index, YQBannerItem *item) {
        BusinessEntity *en = [[BusinessEntity alloc] init];
        en.post_source = item.url;
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didBusinessDelegate:)]) {
//            [weakSelf.delegate didBusinessDelegate:en];
//        }
    }];
    self.bannerView = banner;
    [self.businessCollectionView addSubview:self.bannerView];
}


- (void)initView {
    
    self.hud.hidden = YES;
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(5, self.bannerView.frame.size.height + 10, APP_WIDTH - 10, 40)];
    self.titleView.layer.cornerRadius = 20;
    self.titleView.layer.masksToBounds = YES;
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.businessCollectionView addSubview:self.titleView];

    UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 25, 25)];
    imagView.image = [UIImage imageNamed:@"gonggao"];
    [self.titleView addSubview:imagView];
    
    self.titleScrollView = [[WAdvertScrollView alloc] initWithFrame:CGRectMake(imagView.frame.size.width + 20, 8, self.titleView.frame.size.width - (imagView.frame.size.width + 20), 40)];
    
    self.titleScrollView.advertScrollViewStyle = WAdvertScrollViewStyleMore;
    self.titleScrollView.titleColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.titleScrollView.scrollTimeInterval = 5;
    self.titleScrollView.titles = self.strDataArr;
    self.titleScrollView.titleFont = [UIFont systemFontOfSize:14];
    self.titleScrollView.delegate = self;
//    self.titleScrollView.layer.cornerRadius = 20;
//    self.titleScrollView.layer.masksToBounds = YES;
    self.titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.titleView addSubview:self.titleScrollView];
    
    self.serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.frame.size.height + self.titleView.frame.size.height + 20, APP_WIDTH, 40)];
    self.serviceView.backgroundColor = [UIColor whiteColor];
    [self.businessCollectionView addSubview:self.serviceView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 2, 30)];
    lineView.backgroundColor = RGB(49, 117, 210);
    [self.serviceView addSubview:lineView];
    
    UILabel *serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 5, self.serviceView.frame.size.width - 22, 30)];
    serviceLabel.text = @"企业/推荐服务";
    serviceLabel.textColor = RGB(124, 124, 124);
    serviceLabel.font = [UIFont systemFontOfSize:14];
    [self.serviceView addSubview:serviceLabel];
    
}

#pragma mark ========跑马灯代理方法========
- (void)advertScrollView:(WAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"点击跑马灯");
}

#pragma mark ========APP活动内容========
- (void)getDataStr {
    NSString *type = [UserEntity getIsCompany] ? @"2" : @"1";
    [[RequestManager sharedRequestManager] getAllactices:type success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSLog(@"%@",resultDic[DATA]);
            
            for (NSDictionary *dic in resultDic[DATA]) {
                [self.strDataArr addObject:[dic objectForKey:@"title"]];
            }
            [self getData];
        } else {
            NSLog(@"%@",resultDic[CODE]);
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)getData {
    NSString *type = [UserEntity getIsCompany] ? @"2" : @"1";
    [[RequestManager sharedRequestManager] getActivityList_uid:[UserEntity getUid] type:type page:@"1" pagesize:@"10" success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSLog(@"%@",resultDic[DATA]);
//            NSArray *array = resultDic[DATA];
//            NSMutableArray *list = [NSMutableArray array];
//            for (NSDictionary *dic in array) {
//                BusinessModel *model = [BusinessModel BusinessModelWithDict:dic];
//                [list addObject:model];
//            }
//            self.dataArr = list;
            for (NSDictionary *dic in resultDic[DATA]) {
                BusinessModel *model = [[BusinessModel alloc] init];
                model.title = [dic objectForKey:@"title"];
                model.post_source = [dic objectForKey:@"post_source"];
                model.content = [dic objectForKey:@"content"];
                model.itemId = [dic objectForKey:@"id"];
                model.create_time = [dic objectForKey:@"create_time"];
                model.descriptionStr = [dic objectForKey:@"description"];
                model.imgurl = [dic objectForKey:@"imgurl"];
                [self.dataArr addObject:model];
            }
            [self makeBusinessCollectionViewUI];
            [self initBannerView];
            [self reqDiscoverBannerList];
            [self initView];
            
            [self.businessCollectionView reloadData];
        } else {
            NSLog(@"%@",resultDic[CODE]);
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)reqDiscoverBannerList
{
    NSString *type = [UserEntity getIsCompany] ? @"2" : @"1";
    [[RequestManager sharedRequestManager] getDiscoverBanner_uid:@"" type:type success:^(id resultDic) {
        
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in resultDic[DATA]) {
                YQBannerItem *item = [[YQBannerItem alloc] init];
                item.image = [NSString stringWithFormat:@"%@%@",ImageURL,dic[@"banner"]];
                item.url = dic[@"link"];
                [list addObject:item];
            }
            self.bannerView.items = list;
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)dealloc
{
    [self.bannerView stopTimer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
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
