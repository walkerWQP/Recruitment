//
//  YQDowndropView.m
//  CustomTable
//
//  Created by yunjobs on 2017/10/24.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#import "YQDowndropView.h"
#import "YQDowndropHeadView.h"

#import "YQDDSingleTableView.h"
#import "YQDDCollectionView.h"

#import "YQDowndropBodyView.h"

@interface YQDowndropView ()

@property (nonatomic, strong) YQDowndropHeadView *headView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bodyViews;
// 当前正在显示的视图
@property (nonatomic, strong) YQDowndropItem *curSubItem;

@end

@implementation YQDowndropView

// 根据数据创建对应的视图
- (void)setItem:(NSMutableArray<YQDowndropItem *> *)item
{
    _item = item;
    
    // 创建背景视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height+self.frame.origin.y+APP_NAVH, APP_WIDTH, APP_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithRed:(0)/255.0 green:(0)/255.0 blue:(0)/255.0 alpha:(0.5)];
    bgView.tag = -100;
    bgView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [bgView addGestureRecognizer:tap];
    //加载到windows上
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.bgView = bgView;
    self.bgView.hidden = YES;
    
    [self.bgView addSubview:self.bodyViews];//我添加的
    
    // 创建body视图,方便管理子视图
    YQDowndropBodyView *bodyViews = [[YQDowndropBodyView alloc] initWithFrame:CGRectMake(0, self.frame.size.height+self.frame.origin.y+APP_NAVH, APP_WIDTH, APP_HEIGHT)];
    bodyViews.backgroundColor = [UIColor clearColor];
    //bodyViews.userInteractionEnabled = NO;
    bodyViews.hidden = YES;
    self.bodyViews = bodyViews;
    //加载到windows上
    [[UIApplication sharedApplication].keyWindow addSubview:self.bodyViews];
    
    
    NSMutableArray *headItemArr = [NSMutableArray array];
    NSInteger index = 0;
    for (YQDowndropItem *subItem in item) {
        
        YQHeadViewItem *headItem = [[YQHeadViewItem alloc] init];
        headItem.text = subItem.title;
        headItem.type = subItem.type;
        headItem.index = index;
        headItem.titleView = nil;
        
        if (subItem.type == YQDowndropItemTypeSingleTableView) {
            YQSingleTableViewItem *item = [subItem.singleListArray objectAtIndex:0];
            headItem.text = item.text;
        }
        
        [headItemArr addObject:headItem];
        // 把headitem添加到bodyitem
        subItem.headItem = headItem;
        // 根据类型创建内容视图
        [self initBodyView:subItem viewTag:index];
        
        index++;
    }
    
    // 创建头部视图
    YQDowndropHeadView *headView = [[YQDowndropHeadView alloc] initWithFrame:self.bounds titleArr:headItemArr];
    
    __weak typeof(self) weakSelf = self;
    headView.headViewBlock = ^(NSInteger index) {
        [weakSelf headViewClick:index];
    };
    
    self.headView = headView;
    [self addSubview:self.headView];
//    [self addSubview:headView];
//    self.headView = headView;
}

- (void)initBodyView:(YQDowndropItem *)subItem viewTag:(NSInteger)viewTag
{
    // 根据类型创建
    if (subItem.type == YQDowndropItemTypeSingleTableView) {
        NSInteger tableH = [YQDDSingleTableView cellHeight] * subItem.singleListArray.count;
        // 如果有底部控件就加上它的高度
        if (subItem.footView) {
            tableH += subItem.footView.yq_height;
        }
        // 设置最大高度
        tableH = tableH > kDowndropMaxHeight ? kDowndropMaxHeight : tableH;
        
        // 创建单表视图
        YQDDSingleTableView *singleView = [[YQDDSingleTableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, tableH) downdropItem:subItem];
        subItem.bodyView = singleView;
        singleView.tag = viewTag;
        singleView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        singleView.selectIndexPath = ^(YQDDSingleTableView *singleTableView, NSIndexPath *path) {
            // 改变headView的标题
            [weakSelf chageHeadView:singleTableView.tag indexPath:path];
        };
        singleView.FootViewBlock = ^(YQDDSingleTableView *singleTableView) {
            // footView点击回调
            [weakSelf FootViewClick:singleTableView];
        };
        [self.bodyViews addSubview:singleView];
        
    }else if (subItem.type == YQDowndropItemTypeCollectionView) {
        
        // 创建Collection表视图
        YQDDCollectionView *collectionView = [[YQDDCollectionView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, kDowndropMaxHeight) downdropItem:subItem];
        subItem.bodyView = collectionView;
        collectionView.tag = viewTag;
        collectionView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        collectionView.ResetClickBlock = ^(YQDDCollectionView *collectionView){
            // 重置当前视图
            [weakSelf ResetClick:collectionView];
        };
        collectionView.DetermineClickBlock = ^(YQDDCollectionView *collectionView){
            // 确定已选择条件并执行条件回调
            [weakSelf DetermineClick:collectionView];
        };
        [self.bodyViews addSubview:collectionView];
        
    }
}

- (void)downdropViewRefreshUI:(YQDowndropItem *)subItem index:(NSInteger)index
{
    YQDowndropItem *item = [self.item objectAtIndex:index];
    if (item.type == YQDowndropItemTypeSingleTableView) {
        YQDDSingleTableView *singleView = (YQDDSingleTableView *)item.bodyView;
        [singleView refreshTable:subItem];
        YQSingleTableViewItem *singleItem = [subItem.singleListArray objectAtIndex:0];
        [item.headItem.titleView setTitle:singleItem.text forState:UIControlStateNormal];
        //[self.item replaceObjectAtIndex:index withObject:subItem];
    }
}


#pragma mark - YQDDCollectionView回调方法
// 重置当前视图
- (void)ResetClick:(YQDDCollectionView *)collectionView
{
    YQDowndropItem *subItem = [self.item objectAtIndex:collectionView.tag];
    
    for (YQDDCollectionItem *item in subItem.collectionArray) {
        for (YQSingleTableViewItem *singleItem in item.collectionList) {
            singleItem.isSelect = singleItem == item.collectionList.firstObject;
        }
    }
    
    [collectionView refresh];
}

// 确定已选择条件并执行条件回调
- (void)DetermineClick:(YQDDCollectionView *)collectionView
{
    NSMutableArray *array = [NSMutableArray array];
    
    YQDowndropItem *subItem = [self.item objectAtIndex:collectionView.tag];
    
    for (YQDDCollectionItem *item in subItem.collectionArray) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (YQSingleTableViewItem *singleItem in item.collectionList) {
            if (singleItem.isSelect) {
                if (singleItem != item.collectionList.firstObject) {
                    [tempArr addObject:singleItem];
                    [array addObject:singleItem];
                }
            }
        }
        // 如果没有选择条件就默认第一个
        if (tempArr.count == 0) {
            [array addObject:item.collectionList.firstObject];
        }
    }
    
    NSString *title = subItem.headItem.text;
    int count = 0;
    for (YQSingleTableViewItem *item in array) {
        if ([item.itemId integerValue] != 0) {
            count ++;
        }
    }
    if (count > 0) {
        title = [NSString stringWithFormat:@"%@(%d)",subItem.headItem.text,count];
        //title = subItem.headItem.text;
    }
    [subItem.headItem.titleView setTitle:title forState:UIControlStateNormal];
    
    if (self.refreshTableList) {
        self.refreshTableList(array,collectionView.tag);
    }
    
    // 关闭
    [self closeView:subItem];
}

#pragma mark - YQSingleTableView回调方法
- (void)chageHeadView:(NSInteger)index indexPath:(NSIndexPath *)path
{
    YQDowndropItem *subItem = [self.item objectAtIndex:index];
    // path = nil 不执行
    if (path != nil) {
        YQSingleTableViewItem *singleItem = [subItem.singleListArray objectAtIndex:path.row];
        NSString *title = singleItem.text;
        if (path.row == 0) {
            title = [NSString stringWithFormat:@"%@",singleItem.text];
        }
        [subItem.headItem.titleView setTitle:title forState:UIControlStateNormal];
        
        if (self.refreshTableList) {
            self.refreshTableList(@[singleItem],index);
        }
    }else {
        NSLog(@"path为nil，此方法没有执行");
    }
    
    // 关闭
    [self closeView:subItem];
}

- (void)FootViewClick:(YQDDSingleTableView *)view
{
    YQDowndropItem *subItem = [self.item objectAtIndex:view.tag];
    // 关闭
    subItem.isOpen = NO;
    subItem.bodyView.hidden = YES;
    self.bodyViews.hidden = YES;
    self.bgView.hidden = YES;
}

#pragma mark - YQDowndropHeadView回调方法
- (void)headViewClick:(NSInteger)index
{
    YQDowndropItem *subItem = [self.item objectAtIndex:index];
    
    if (self.curSubItem == subItem || self.curSubItem == nil) {
        if (subItem.isOpen) {
            // 如果是打开的 直接关闭
            [self closeView:subItem];
        }else{
            // 如果是关闭的就直接打开
            [self openView:subItem];
        }
    } else {
        // 关闭当前的显示的
        if (self.curSubItem.isOpen) {
            //[self closeView:self.curSubItem];
            self.curSubItem.bodyView.hidden = YES;
            
        }
        // 打开现在的
        [self openView:subItem];
    }
    self.curSubItem = subItem;
   
}

-(void)openView:(YQDowndropItem *)subItem
{
    
    subItem.isOpen = YES;
    subItem.bodyView.yq_height = 0;
    subItem.bodyView.hidden = NO;
    self.bodyViews.hidden = NO;
    self.bgView.alpha = 0;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.bgView.alpha = 0.5;
        if (subItem.type == YQDowndropItemTypeSingleTableView) {
            NSInteger cellH = [YQDDSingleTableView cellHeight] * subItem.singleListArray.count;
            if (subItem.footView) {
                cellH = cellH+subItem.footView.yq_height;
            }
            NSInteger h = cellH > kDowndropMaxHeight ? kDowndropMaxHeight : cellH;
            subItem.bodyView.yq_height = h;
        }else if (subItem.type == YQDowndropItemTypeCollectionView) {
            subItem.bodyView.yq_height = kDowndropMaxHeight;
        }
    }];

}

-(void)closeView:(YQDowndropItem *)subItem
{
    subItem.isOpen = NO;
    [UIView animateWithDuration:.3 animations:^{
        subItem.bodyView.yq_height = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL isfinish){
        subItem.bodyView.hidden = YES;
        self.bodyViews.hidden = YES;
        self.bgView.hidden = YES;
    }];
}

#pragma mark - public

// 收起子视图
- (void)closeAllSubView
{
    YQDowndropItem *subItem = self.curSubItem;
    if (subItem.isOpen) {
        subItem.isOpen = NO;
        [UIView animateWithDuration:.01 animations:^{
            subItem.bodyView.yq_height = 0;
            self.bgView.alpha = 0;
        } completion:^(BOOL isfinish){
            subItem.bodyView.hidden = YES;
            self.bodyViews.hidden = YES;
            self.bgView.hidden = YES;
        }];
    }
}

- (void)removeSubView
{
    [self.bodyViews removeFromSuperview];
    [self.bgView removeFromSuperview];
}

#pragma mark - private


- (void)dealloc
{
    [self.bodyViews removeFromSuperview];
    [self.bgView removeFromSuperview];
}

- (void)tapClick:(UIGestureRecognizer *)sender
{
    if (self.curSubItem.isOpen) {
        self.curSubItem.isOpen = NO;
        [UIView animateWithDuration:.3 animations:^{
            self.curSubItem.bodyView.yq_height = 0;
            self.bgView.alpha = 0;
        } completion:^(BOOL isfinish){
            self.curSubItem.bodyView.hidden = YES;
            self.bodyViews.hidden = YES;
            self.bgView.hidden = YES;
        }];
    }
}



@end
