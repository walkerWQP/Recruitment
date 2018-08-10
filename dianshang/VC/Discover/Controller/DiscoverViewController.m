//
//  DiscoverViewController.m
//  dianshang
//
//  Created by yunjobs on 2017/10/13.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define kButtonNormalColor RGBA(255, 255, 255, 0.7)

#import "DiscoverViewController.h"
#import "BusinessDetailController.h"
#import "BusinessController.h"
#import "DiscoverTopicReleaseVC.h"
#import "YQNavigationController.h"
#import "DiscoverDetailController.h"
#import "YQViewController+YQShareMethod.h"

#import "EZCPersonCenterController.h"
#import "PersonalAuthController.h"

//#import "YQPageScrollView.h"
#import "YQDiscoverCell.h"
#import "YQDiscoverPhotoView.h"
#import "YQBannerView.h"

#import "BusinessEntity.h"
#import "YQDiscover.h"
#import "YQDiscoverUser.h"
#import "YQDiscoverPhoto.h"
#import "YQDiscoverFrame.h"
#import "YQDiscoverComment.h"
#import "YQGroupTableItem.h"

#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "KNActionSheet.h"

@interface DiscoverViewController ()<MWPhotoBrowserDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITabBarControllerDelegate,UIAlertViewDelegate>
{
    NSInteger curTableIndex;
    NSIndexPath *curIndexPath;
}
@property (nonatomic, strong) UIView *headLineView;
@property (nonatomic, strong) NSMutableArray *tableGroups;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bannerSupView;
@property (nonatomic, strong) YQBannerView *bannerView;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) UINavigationController *photoNavigationController;
@property (nonatomic, strong) NSMutableArray *photos;

//@property (nonatomic,strong) NSMutableArray *statusFrames;
@property (nonatomic, assign) BOOL isPullDown;//是否是下拉刷新 YES:下拉,NO:上拉
@property (nonatomic, assign) NSInteger pageIndex;//页数

@property (nonatomic, strong) BusinessController *businessVC;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.delegate = self;
    
    [self initTitleView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"discover_release" highImage:@"discover_release" target:self action:@selector(rightClick)];
    //[UIBarButtonItem itemWithtitle:@"发布" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
//    [self setNav];
    
}

- (void)setNav
{
    //self.navigationItem.title = @"E聊";
    
    UISegmentedControl *segmentedC = [[UISegmentedControl alloc] initWithItems:@[@"职场",@"发现"]];
    segmentedC.yq_width = 120;
    segmentedC.selectedSegmentIndex = 0;
    segmentedC.tintColor = [UIColor whiteColor];
    [segmentedC addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = THEMECOLOR;
    [segmentedC setTitleTextAttributes:dic forState:UIControlStateSelected];
    self.navigationItem.titleView = segmentedC;
}

- (void)segmentChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.businessVC.view.hidden = YES;
    }else if (sender.selectedSegmentIndex == 1){
        self.businessVC.view.hidden = NO;
    }
}


- (void)initTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85*self.tableGroups.count, 44)];
    self.navigationItem.titleView = titleView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH-APP_TABH)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(self.tableGroups.count*APP_WIDTH, scrollView.yq_height);
    scrollView.delegate = self;
    scrollView.pagingEnabled = NO;
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    //scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
//    [self tableview:scrollView toView:self.view toY:0];
    self.scrollView = scrollView;
    
    CGFloat buttonW = titleView.yq_width/self.tableGroups.count;
    CGFloat buttonH = titleView.yq_height;
    
    for (int i = 0; i < self.tableGroups.count; i++) {
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:i];
        
        CGFloat buttonX = i*buttonW;
        CGFloat buttonY = 0;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:item.title forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:kButtonNormalColor forState:UIControlStateNormal];
        [titleView addSubview:button];
        
        CGFloat viewX = i*APP_WIDTH;
        
        CGFloat viewH = self.scrollView.yq_height;
        
        if (i == 0 || i == 2) {
            UITableView *myTable  = [[UITableView alloc] initWithFrame:CGRectMake(viewX, 0, APP_WIDTH, viewH) style:UITableViewStylePlain];
            myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            myTable.backgroundColor = [UIColor clearColor];
            myTable.delegate = self;
            myTable.dataSource = self;
            myTable.scrollsToTop = NO;
            myTable.tableFooterView = [[UIView alloc] init];
            [self.scrollView addSubview:myTable];
            //[self tableview:myTable toView:self.scrollView toY:0];
            if (IOS_VERSION_11_OR_ABOVE) {
                myTable.estimatedRowHeight = 0;
                myTable.estimatedSectionHeaderHeight = 0;
                myTable.estimatedSectionFooterHeight = 0;
            }
            [self setupRefresh:myTable];
            if (i == 0) {
                // 刷新数据
                [myTable.mj_header beginRefreshing];
            }
            //[self setupData]; //添加假数据
            item.tableView = myTable;
        } else if (i == 1) {
            
            BusinessController *vc = [[BusinessController alloc] init];
            vc.view.yq_x = viewX;
//            vc.delegate = self;
            vc.view.yq_height = viewH;
            [self.scrollView addSubview:vc.view];

        }
        else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*APP_WIDTH, 0, APP_WIDTH, 200)];
            view.backgroundColor = RandomColor;
            [scrollView addSubview:view];
        }
        
        
        // 标题底部线
        if (i == 0) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*buttonW, buttonH-2, buttonW, 2)];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 2)];
            lineView.center = CGPointMake(button.center.x, buttonH-2*0.5);
            lineView.backgroundColor = [UIColor whiteColor];
            [titleView addSubview:lineView];
            self.headLineView = lineView;
        }
        
        item.button = button;
    }
}
- (void)didBusinessDelegate:(BusinessEntity *)entity
{
    if (entity.post_source.length > 0) {
        BusinessDetailController *detail = [[BusinessDetailController alloc] init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.urlStr = entity.post_source;
        detail.webTitle = @"详情";
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark ========假数据========
- (void)setupData
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:0];
    NSMutableArray *tableArr = [NSMutableArray array];
    NSArray *urlArr = @[
                        @"http://ww4.sinaimg.cn/thumbnail/7f8c1087gw1e9g06pc68ug20ag05y4qq.gif",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"
                        ];
    NSMutableArray *comment = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *str = [NSString stringWithFormat:@"%d->%@",i,@"这里是评论,蛹只有一个选择，那就是放弃所有抗拒、全然接纳当下感觉、平静等待，直到有一天破茧而出成为蝴蝶。"];
        if (i == 1) {
            str = [NSString stringWithFormat:@"%d->%@",i,@"这里是评论,蛹只有一个选择，那就是放弃所有抗拒、"];
        }
        YQDiscoverComment *en = [[YQDiscoverComment alloc] init];
        en.name = @"dddd";
        en.commentText = str;
        //NSDictionary *dict = @{@"name":@"dddddaaa",@"text":str};
        [comment addObject:en];
    }
    
    for (int i = 0; i < 10; i++) {
        YQDiscoverUser *user = [[YQDiscoverUser alloc] init];
        user.name = [NSString stringWithFormat:@"这里是姓名%d",i];
        YQDiscover *en = [[YQDiscover alloc] init];
        en.user = user;
        en.created_at = @"Tue Oct 31 10:50:10 +0800 2017";
        en.source = @"<a href=\"http://app.weibo.com/t/feed/5g0B8s\" rel=\"nofollow\">\u5fae\u535aweibo.com</a>";
        NSString *str = [NSString stringWithFormat:@"%d->%@",i,@"每只毛毛虫都可以变成自己的蝴蝶，只不过，在变成蝴蝶之前，自己会先变成作茧自缚的蛹。在茧里边面对自己制造的痛苦，任何挣扎或试图改变的行为都是徒劳的。蛹只有一个选择，那就是放弃所有抗拒、全然接纳当下感觉、平静等待，直到有一天破茧而出成为蝴蝶。"];
        en.text = str;
        en.isOpen = NO;
        NSMutableArray *url = [NSMutableArray array];
        for (int j = 0; j < i; j++) {
            
            YQDiscoverPhoto *photo = [[YQDiscoverPhoto alloc] init];
            photo.thumbnail_pic = urlArr[j];
            [url addObject:photo];
        }
        en.pic_urls = [NSMutableArray arrayWithArray:url];
        
        NSMutableArray *comentArray = [NSMutableArray array];
        for (int j = 9-i; j > 0; j--) {
            [comentArray addObject:comment[j]];
        }
        en.commentList = comentArray;
        
        [tableArr addObject:en];
    }
    
    for (YQDiscover *user in tableArr) {
        user.retweeted_status = user;
    }
    
    // 将 XFStatus数组 转为 XFStatusFrame数组
    NSArray *newFrames = [self stausFramesWithStatuses:tableArr];
    
    NSRange range = NSMakeRange(0, newFrames.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [item.tableViewArray insertObjects:newFrames atIndexes:indexSet];
}

#pragma mark - tableviewRefresh

- (void)setupRefresh:(UITableView *)tableView
{
    __weak typeof(self) weakSelf = self;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isPullDown = YES;
        [weakSelf headerRereshing];
    }];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isPullDown = NO;
        [weakSelf footerRereshing];
    }];
}

- (void)headerRereshing
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    item.pageCount = 1;
    NSString *isdefault = @"1";// 合伙人
    if (curTableIndex == 0) {
        isdefault = @"2";// 职场
    }
    [self reqWorkplaceList:[NSString stringWithFormat:@"%li",item.pageCount] isdefault:isdefault];
}

- (void)footerRereshing
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    item.pageCount++;
    NSString *isdefault = @"1";// 合伙人
    if (curTableIndex == 0) {
        isdefault = @"2";// 职场
    }
    [self reqWorkplaceList:[NSString stringWithFormat:@"%li",item.pageCount] isdefault:isdefault];
}

#pragma mark - tableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (curTableIndex == 0 || curTableIndex == 2) {
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
        return item.tableViewArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curTableIndex == 0 || curTableIndex == 2) {
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
        YQDiscoverFrame *frame = item.tableViewArray[indexPath.row];
        return frame.cellHeight;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curTableIndex == 0 || curTableIndex == 2) {
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
        YQDiscoverFrame *frame = item.tableViewArray[indexPath.row];
        //获得cell
        YQDiscoverCell *cell = [YQDiscoverCell cellWithTableView:item.tableView];
        //给cell传递模型数据
        cell.statusFrame = frame;
        
        YQWeakSelf;
        cell.textOpenBlock = ^(NSIndexPath *path) {
            [weakSelf openDetail:path];
        };
        
        cell.photoClickBlock = ^(NSIndexPath *path, NSMutableArray<NSDictionary *> *photos, YQDiscoverPhotoView *photoView) {
            [weakSelf addPhotoBrowerWithItemsArr:photos photoView:photoView];
        };
        
        cell.toolbarBlock = ^(NSIndexPath *path, UIButton *sender) {
            [weakSelf toolbarClick:path button:sender];
        };
        
        //cell.backgroundColor = RandomColor;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    curIndexPath = indexPath;
    
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    YQDiscoverFrame *frame = item.tableViewArray[indexPath.row];
    
    DiscoverDetailController *vc = [[DiscoverDetailController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.discover = frame.status;
    
    vc.opeationSuccessBlock = ^(NSString *text) {
        [item.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)toolbarClick:(NSIndexPath *)indexPath button:(UIButton *)sender
{
//    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
//    YQDiscoverFrame *entity = item.tableViewArray[indexPath.row];
    curIndexPath = indexPath;
    if (sender.tag == 1) {
        //转发
        [self shareView];
    }else if (sender.tag == 2){
        //评论
        YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
        YQDiscoverFrame *frame = item.tableViewArray[indexPath.row];
        
        DiscoverDetailController *vc = [[DiscoverDetailController alloc] init];
        vc.isComment = YES;
        vc.hidesBottomBarWhenPushed = YES;
        vc.discover = frame.status;
        vc.opeationSuccessBlock = ^(NSString *text) {
            [item.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 3){
        //赞
        [self reqPraiseTopic:indexPath];
    }
}

- (void)openDetail:(NSIndexPath *)indexPath
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    YQDiscoverFrame *entity = item.tableViewArray[indexPath.row];
    YQDiscover *en = entity.status;
    en.isOpen = !en.isOpen;
    entity.status = en;
    [item.tableViewArray replaceObjectAtIndex:indexPath.row withObject:entity];
    
    [item.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addPhotoBrowerWithItemsArr:(NSMutableArray *)array photoView:(YQDiscoverPhotoView *)photoView
{
//    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc] init];
//    photoBrower.itemsArr = [array copy];
//    photoBrower.currentIndex = photoView.tag;
//    
//    //[photoBrower setIsNeedRightTopBtn:NO]; // 是否需要 右上角 操作功能按钮
//    
//    [photoBrower present];
//    _photoBrower = photoBrower;
    self.photos = [NSMutableArray array];
    for (NSDictionary *item in array) {
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:item[@"url"]]];
        //photo.caption = @"dd";
        [self.photos addObject:photo];
    }
    [self.photoBrowser setCurrentPhotoIndex:photoView.tag];
    NSLog(@"%d",(int)photoView.tag);
    [self presentViewController:self.photoNavigationController animated:YES completion:nil];
}

#pragma mark - scroller

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        //线条的跟随动画
        //self.headLineView.yq_x = scrollView.contentOffset.x/self.tableGroups.count;
//        CGFloat centerX = scrollView.contentOffset.x / APP_WIDTH * (self.headLineView.yq_right+self.headLineView.yq_width*0.5);
//        self.headLineView.center = CGPointMake(centerX, self.headLineView.center.y);
        self.isShowNoMoreData = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x / pageWidth));
        //NSLog(@"%d",page);
        
        YQGroupTableItem *item3 = [self.tableGroups objectAtIndex:page];
        
        self.headLineView.yq_width = item3.button.titleLabel.yq_width;
        self.headLineView.center = CGPointMake(item3.button.center.x, self.headLineView.center.y);
        
        //设置选中按钮样式
        [self setHeadViewButton:page];
    }
}

#pragma mark ========设置选中按钮样式========
- (void)setHeadViewButton:(NSInteger)page
{
    self.navigationItem.rightBarButtonItem.customView.hidden = page == 1;
    
    curTableIndex = page;
    
    YQGroupTableItem *item3 = [self.tableGroups objectAtIndex:page];
    if (item3.tableViewArray.count == 0) {
        //>0 就不主动刷新
        [item3.tableView.mj_header beginRefreshing];
        // ==0 默认不选中
    }else{
        // 重新设置全选按钮状态
        //[self setAllSelectBtnWithTableIndex:nil];
    }
    // 设置按钮标题
    //[self setButtonTitle:page];
    
    for (int i = 0; i < self.tableGroups.count; i++) {
        YQGroupTableItem *itema = [self.tableGroups objectAtIndex:i];
        UIButton *button = itema.button;
        if ([button isEqual:item3.button]) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:kButtonNormalColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    return [NSString stringWithFormat:@"%lu / %lu", (unsigned long)index+1, (unsigned long)self.photos.count];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
    KNActionSheet *actionsSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:@[@"保存图片"] actionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            id <MWPhoto> photo = self.photos[index];
            if ([photo underlyingImage]) {
                UIImageWriteToSavedPhotosAlbum([photo underlyingImage], self,
                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }
        
    }];
    [actionsSheet show];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
}

#pragma mark - getter/setter

- (NSMutableArray *)tableGroups
{
    if (_tableGroups == nil) {
        _tableGroups = [NSMutableArray array];
        NSArray *titleArr = @[@"职场",@"发现"];
        //NSArray *titleArr = @[@"职场",@"发现",@"合伙人"];
        for (int i = 0; i < titleArr.count; i++) {
            YQGroupTableItem *item = [[YQGroupTableItem alloc] init];
            item.title = [titleArr objectAtIndex:i];
            item.tableView = [[UITableView alloc] init];
            item.tableViewArray = [NSMutableArray array];
            item.button = [[UIButton alloc] init];
            item.pageCount = i+1;
            //item.type = i+2;
            [_tableGroups addObject:item];
        }
    }
    return _tableGroups;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        //_photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - 点击事件
- (void)rightClick
{
    NSInteger flag = 0;
    if ([UserEntity getIsCompany]) {
        NSInteger auth = [[UserEntity getRealAuth] integerValue];
        if (auth == 1) {
            flag = 1;
        }else if (auth == 2 || auth == 0){
            //去认证
            [self goAuth];
        }else if (auth == 3){
            // 等待审核
            [self waitExamine];
        }
    }else{
        NSInteger auth = [[UserEntity getRealAuth] integerValue];
        if (auth == 1) {
            flag = 1;
        }else if (auth == 2 || auth == 0){
            //去认证
            [self goAuth];
        }else if (auth == 3){
            // 等待审核
            [self waitExamine];
        }
    }
    
    
    if (flag == 1) {
        // 发布新话题
        DiscoverTopicReleaseVC *vc = [[DiscoverTopicReleaseVC alloc] init];
        if (curTableIndex == 0) {
            vc.isdefault = @"2";// 职场
            vc.navigationItem.title = @"发职场动态";
            vc.placeholder = @"分享有价值的职场内容,为你的职业竞争力加分";
        }else{
            vc.navigationItem.title = @"发合伙人动态";
            vc.placeholder = @"分享有价值的职场内容,为你的职业竞争力加分";
            vc.isdefault = @"1";// 合伙人
        }
        YQWeakSelf;
        vc.releaseSuccessBlock = ^(NSString *text) {
            [weakSelf headerRereshing];;
        };
        YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)goAuth
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"根据国家互联网政策规定要求请先进行实名认证，方能在职场社交中发布相关话题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)waitExamine
{
    [YQToast yq_AlertText:@"您的资料正在审核中,请耐心等待"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            if ([UserEntity getIsCompany]) {
                EZCPersonCenterController *vc = [[EZCPersonCenterController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                PersonalAuthController *vc = [[PersonalAuthController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)buttonClick:(UIButton *)sender
{
    // 设置选中按钮样式
    [self setHeadViewButton:sender.tag];
    
    // 设置滑动的线
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:sender.tag];
    //UIButton *button = item.button;
    [UIView animateWithDuration:0.3 animations:^{
        //self.headLineView.yq_x = button.yq_x;
        self.headLineView.yq_width = item.button.titleLabel.yq_width;
        self.headLineView.center = CGPointMake(item.button.center.x, self.headLineView.center.y);
    }];
    // 设置滑动的偏移量
    self.scrollView.contentOffset = CGPointMake(sender.tag*APP_WIDTH, 0);
    //    [scroller setContentOffset:CGPointMake((sender.tag-1)*APP_WIDTH, 0) animated:NO];
}

#pragma mark - tool

-(NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (YQDiscover *status in statuses) {
        YQDiscoverFrame *f = [[YQDiscoverFrame alloc] init];
        f.status = status;
        [frames addObject:f];
        
    }
    return frames;
    
}
#pragma mark - 网络请求
#pragma mark ========点赞========
- (void)reqPraiseTopic:(NSIndexPath *)indexPath
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    YQDiscoverFrame *entity = item.tableViewArray[indexPath.row];
    
    [[RequestManager sharedRequestManager] discoverPraiseTopic_uid:[UserEntity getUid] tid:entity.status.idstr success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            YQDiscover *en = entity.status;
            if (en.isPraise) {
                en.attitudes_count -= 1;
                en.isPraise = NO;
            }else{
                en.attitudes_count += 1;
                en.isPraise = YES;
            }
            entity.status = en;
            [item.tableViewArray replaceObjectAtIndex:indexPath.row withObject:entity];
            
            [item.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark ========职场列表========
- (void)reqWorkplaceList:(NSString *)page isdefault:(NSString *)isdefault
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    [[RequestManager sharedRequestManager] getDiscoverTopicList_uid:[UserEntity getUid] page:page pagesize:KPageSize isdefault:isdefault success:^(id resultDic) {
        [item.tableView.mj_header endRefreshing];
        [item.tableView.mj_footer endRefreshing];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSMutableArray *tableArr = [NSMutableArray array];
            
            for (NSDictionary *dict in resultDic[DATA]) {
                
                YQDiscoverUser *user = [[YQDiscoverUser alloc] init];
                user.name = dict[@"name"];
                user.profile_image_url = dict[@"avatar"];
                YQDiscover *en = [[YQDiscover alloc] init];
                en.idstr = dict[@"topicid"];
                en.attitudes_count = [dict[@"praise"] intValue];
                en.comments_count = [dict[@"count"] intValue];
                en.reposts_count = [dict[@"share"] intValue];
                en.isPraise = [dict[@"t_praise"] isEqualToString:@"1"];
                en.user = user;
                en.created_at = dict[@"createtime"];
                en.source = @"";
                en.text = dict[@"describe"];
                en.isOpen = NO;
                en.pic_urls = [NSMutableArray array];
                NSMutableArray *comentArray = [NSMutableArray array];
                for (NSDictionary *d in dict[@"comment"]) {
                    YQDiscoverComment *en = [[YQDiscoverComment alloc] init];
                    en.name = d[@"name"];
                    en.commentText = d[@"desc"];
                    [comentArray addObject:en];
                }
                en.commentList = comentArray;
                
                [tableArr addObject:en];
            }
            
            if (tableArr.count != 0) {
                if (self.isPullDown) {
                    [item.tableViewArray removeAllObjects];
                }
                // 将 XFStatus数组 转为 XFStatusFrame数组
                NSArray *newFrames = [self stausFramesWithStatuses:tableArr];
                //NSRange range = NSMakeRange(0, newFrames.count);
                //NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                [item.tableViewArray addObjectsFromArray:newFrames];
                
                [item.tableView reloadData];
            }else{
                [item.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark - tabBarControllerDelegete

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //单击处理
    int i=0;
    UINavigationController *navdid=tabBarController.selectedViewController;//当前状态下已经处于选择状态的vc
    UINavigationController *nav=(UINavigationController*)viewController;//点击的vc
    if (![navdid.topViewController isEqual:self]) {//这里是判断nav的rootviewcontroller，但是这一层时它里面只有onetableviewcontroller这一个控制器，所以我们可以判断topViewController就是它了，这个属性是取栈定控制器。
        i--;//如果是从别的页面切换过来则不用立马做未读消息处理，让i的值随意变动一下，不等于1就行了
    }
    if ([nav.topViewController isEqual:self]) {
        i++;
    }
    if (i==1) {
        //这里做未读消息滚动处理或者刷新功能处理，如果这个页面里面有分了两个小页面，可以使用block和delegate，当然我建议使用block，比代理模式简单又好用。
        if (curTableIndex == 0 || curTableIndex == 2) {
            YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
            if (item.tableView.contentOffset.y == 0) {
                //CLog(@"刷新");
            }else{
                [item.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
    }
    return YES;//这里做一下解释，该方法用于控制TabBarItem能不能选中，返回NO，将禁止用户点击某一个TabBarItem被选中。
}

#pragma mark - 分享视图
#pragma mark ========将要执行分享的时候调用========
- (void)shreViewWillAppear
{
    // 调用分享话题接口(分享次数+1 无论分享是否成功都+1)
    
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    YQDiscoverFrame *frame = item.tableViewArray[curIndexPath.row];
    NSLog(@"2     %@",frame.status.idstr);
    [[RequestManager sharedRequestManager] discoverShareTopic_uid:@"" tid:frame.status.idstr success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            YQDiscover *en = frame.status;
            if (en.isPraise) {
                en.reposts_count -= 1;
            }else{
                en.reposts_count += 1;
            }
            
            [item.tableViewArray replaceObjectAtIndex:curIndexPath.row withObject:frame];
            
            [item.tableView reloadRowsAtIndexPaths:@[curIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
    
}

#pragma mark ========设置分享参数========
- (NSMutableDictionary *)getShateParameters
{
    YQGroupTableItem *item = [self.tableGroups objectAtIndex:curTableIndex];
    YQDiscoverFrame *frame = item.tableViewArray[curIndexPath.row];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 通用参数设置
    
    NSLog(@"4   %@",frame.status.text);
    
    [parameters SSDKSetupShareParamsByText:frame.status.text
                                    images:nil
                                       url:nil
                                     title:nil
                                      type:SSDKContentTypeText];
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
