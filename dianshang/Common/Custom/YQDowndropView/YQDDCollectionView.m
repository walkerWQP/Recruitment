//
//  YQDDCollectionView.m
//  CustomTable
//
//  Created by yunjobs on 2017/10/25.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#define defaultItemW (APP_WIDTH-60)/4

#import "YQDowndropConst.h"
#import "YQDDCollectionView.h"
#import "YQDowndropItem.h"

static NSString *CellIdentifier = @"collectionCell";
static NSString *HeaderIdentifier = @"headerCell";

@interface YQDDCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger footViewH;
}
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YQDDCollectionView

- (instancetype)initWithFrame:(CGRect)frame downdropItem:(YQDowndropItem *)subItem
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = RGB(243, 243, 243);
        self.tableArray = subItem.collectionArray;
        // 添加底部按钮
        subItem.footView = [self footView];
        if (subItem.footView) {
            CGRect aframe = subItem.footView.frame;
            aframe.origin.y = frame.size.height-aframe.size.height;
            subItem.footView.frame = aframe;
            [self addSubview:subItem.footView];
            footViewH = aframe.size.height;
        }
        
        [self initCollectionView:frame];
    }
    return self;
}

- (void)initCollectionView:(CGRect)frame
{
    CGFloat itemW = (APP_WIDTH-60)/4;
    CGFloat itemH = 35;
    
    YQDDCollectionViewFlowLayout *flowLayout = [[YQDDCollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.headerReferenceSize = CGSizeMake(APP_WIDTH, 50);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 15;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-footViewH) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.contentInset = UIEdgeInsetsMake(0, 15, 40, 15);
    [self addSubview:collectionView];
    
    [collectionView registerClass:[YQDDCollectionCell class] forCellWithReuseIdentifier:CellIdentifier];
    [collectionView registerClass:[YQDDCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    
    self.collectionView = collectionView;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    [collectionView addGestureRecognizer:tap];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.tableArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    YQDDCollectionItem *item = [self.tableArray objectAtIndex:section];
    return item.collectionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YQDDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor grayColor];
    YQDDCollectionItem *item = [self.tableArray objectAtIndex:indexPath.section];
    YQSingleTableViewItem *singleItem = item.collectionList[indexPath.row];
    cell.buttonItem = singleItem;
    
    __weak typeof(self) weakSelf = self;
    cell.refreshSection = ^(NSIndexPath *path) {
        [weakSelf refreshSection:path];
    };
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    YQDDCollectionCell *cell = [[YQDDCollectionCell alloc] init];
    YQDDCollectionItem *item = [self.tableArray objectAtIndex:indexPath.section];
    YQSingleTableViewItem *singleItem = item.collectionList[indexPath.row];
    NSString *content = singleItem.text;
    int itemW = [content yq_stringWidthWithFixedHeight:30 font:17];
    itemW = itemW < defaultItemW ? defaultItemW : itemW;
    //NSLog(@"%@->%d",content,itemW);
    return CGSizeMake(itemW, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionReusableView *reusableView = nil;
    //NSDictionary *dic = _disDataList[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader)
    {
        YQDDCollectionHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        
        YQDDCollectionItem *item = [self.tableArray objectAtIndex:indexPath.section];
        header.titleLabel.text = item.collectionText;
        
        //header.backgroundColor = [UIColor yellowColor];
        
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewcell按钮点击回调方法

- (void)refreshSection:(NSIndexPath *)path
{
    // 重置其他的选择状态并刷新
    YQDDCollectionItem *item = [self.tableArray objectAtIndex:path.section];
    if (item.isMultiselect) {
        if (path.row == 0) {
            for (YQSingleTableViewItem *singleItem in item.collectionList) {
                singleItem.isSelect = singleItem == item.collectionList.firstObject;
            }
        }else{
            YQSingleTableViewItem *singleItem0 = item.collectionList[0];
            singleItem0.isSelect = NO;
            YQSingleTableViewItem *singleItem1 = item.collectionList[path.row];
            singleItem1.isSelect = !singleItem1.isSelect;
            // 如果没有选择任意一项就是默认第一项
            int flag = 0;
            for (YQSingleTableViewItem *singleItem in item.collectionList) {
                if (singleItem.isSelect) {
                    flag ++;
                    break;
                }
            }
            if (flag == 0) {
                singleItem0.isSelect = YES;
            }
        }
    }else{
        for (YQSingleTableViewItem *singleItem in item.collectionList) {
            if (singleItem.isSelect) {
                singleItem.isSelect = NO;
                break;
            }
        }
        YQSingleTableViewItem *singleItem1 = item.collectionList[path.row];
        singleItem1.isSelect = YES;
        
    }
    //NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
    //[self.collectionView reloadSections:indexSet];
    [self.collectionView reloadData];
}

#pragma mark - public
- (void)refresh
{
    [self.collectionView reloadData];
}

#pragma mark - private
// 创建底部
- (UIView *)footView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 45)];
    
    UIButton *footButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.yq_width*0.5, view.yq_height)];
    footButton.backgroundColor = [UIColor whiteColor];
    [footButton setTitle:@"重置" forState:UIControlStateNormal];
    [footButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [footButton addTarget:self action:@selector(ResetClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:footButton];
    
    UIButton *footButton0 = [[UIButton alloc] initWithFrame:CGRectMake(footButton.yq_right, 0, view.yq_width*0.5, view.yq_height)];
    footButton0.backgroundColor = THEMECOLOR;
    [footButton0 setTitle:@"确定" forState:UIControlStateNormal];
    [footButton0 addTarget:self action:@selector(DetermineClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:footButton0];
    
    return view;
}

- (void)ResetClick:(UIButton *)sender
{
    if (self.ResetClickBlock) {
        self.ResetClickBlock(self);
    }
}

- (void)DetermineClick:(UIButton *)sender
{
    if (self.DetermineClickBlock) {
        self.DetermineClickBlock(self);
    }
}

@end

#pragma mark -
#pragma mark - CollectionCell

@interface YQDDCollectionCell ()

@end

@implementation YQDDCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIButton *textBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [textBtn addTarget:self action:@selector(textBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [textBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [textBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        textBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [textBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [textBtn setBackgroundColor:THEMECOLOR forState:UIControlStateSelected];
        textBtn.layer.cornerRadius = 3;
        textBtn.layer.borderColor = RGB(180, 180, 180).CGColor;
        textBtn.layer.borderWidth = 0.5;
        textBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:textBtn];
        self.textButton = textBtn;
    }
    
    return self;
}

- (void)setButtonItem:(YQSingleTableViewItem *)buttonItem
{
    _buttonItem = buttonItem;
    
    NSString *content = buttonItem.text;
    int itemW = [content yq_stringWidthWithFixedHeight:30 font:17];
    itemW = itemW < defaultItemW ? defaultItemW : itemW;
    CGRect frame = self.textButton.frame;
    frame.size.width = itemW;
    self.textButton.frame = frame;
    [self.textButton setTitle:content forState:UIControlStateNormal];
    
    self.textButton.selected = buttonItem.isSelect;
    
    self.textButton.layer.borderWidth = buttonItem.isSelect ? 0 : 0.5;
}

- (void)textBtnClick:(UIButton *)sender
{
    NSIndexPath *path = [self indexPathWithView:sender];
    if (self.refreshSection) {
        self.refreshSection(path);
    }
//    sender.selected = !sender.selected;
//    sender.layer.borderWidth = sender.selected ? 0 : 0.5;
    
}

- (NSIndexPath *)indexPathWithView:(UIView *)view
{
    UICollectionView *table = nil;
    UICollectionViewCell *cell = nil;
    
    while (view != nil && ![view isKindOfClass:[UICollectionViewCell class]]) {
        view = [view superview];
    }
    cell = (UICollectionViewCell *)view;
    
    while (view != nil && ![view isKindOfClass:[UICollectionView class]]) {
        view = [view superview];
    }
    table = (UICollectionView *)view;
    
    if (cell != nil && table != nil) {
        return [table indexPathForCell:cell];
    }else{
        return nil;
    }
}

@end

#pragma mark -
#pragma mark - Collection头部

@implementation YQDDCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        titleLabel.textColor = RGB(102, 102, 102);
        titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        //YQDDCollectionItem *item = [self.tableArray objectAtIndex:indexPath.section];
        //titleLabel.text = item.collectionText;
        
    }
    
    return self;
}

@end

#pragma mark -
#pragma mark - 左对齐样式

@interface YQDDCollectionViewFlowLayout()
{
    //在居中对齐的时候需要知道这行所有cell的宽度总和
    CGFloat _sumCellWidth ;
}
@end

@implementation YQDDCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    //用来临时存放一行的Cell数组
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index]; // 当前cell的位置信息
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1]; // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
        nil : layoutAttributes[index+1];//下一个cell 位置信息
        
        //加入临时数组
        [layoutAttributesTemp addObject:currentAttr];
        _sumCellWidth += currentAttr.frame.size.width;
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        //如果下一个cell在本行，这开始调整Frame位置
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}
//调整属于同一行的cell的位置frame
-(void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
    CGFloat nowWidth = 0.0;
    nowWidth = self.sectionInset.left;
    for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
        CGRect nowFrame = attributes.frame;
        nowFrame.origin.x = nowWidth;
        attributes.frame = nowFrame;
        nowWidth += nowFrame.size.width + 10;
    }
    _sumCellWidth = 0.0;
    [layoutAttributes removeAllObjects];
}

@end

