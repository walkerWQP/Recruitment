//
//  RMExpectindustry.m
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#define defaultItemW 60

#import "RMExpectindustry.h"
#import "RMExpectindustryEntity.h"

#import "NSString+YQWidthHeight.h"


static NSString *CellIdentifier = @"collectionCell";
static NSString *HeaderIdentifier = @"headerCell";


@interface RMExpectindustry ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation RMExpectindustry

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"期望行业";
    
    self.tableArray = [NSMutableArray array];
    
    [self reqHoptrade];
    
    [self initCollectionView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"确定" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
}

- (void)rightClick:(UIButton *)sender
{
    NSMutableArray *array = [NSMutableArray array];
    for (RMExpectindustryEntity *singleItem in self.tableArray) {
        if (singleItem.isSelect) {
            [array addObject:singleItem];
        }
    }
    
    // 把选择标签回传到上一页
    if (_expectIndustryBlock) {
        _expectIndustryBlock(array);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initCollectionView
{
    CGFloat itemW = (APP_WIDTH-60)/4;
    CGFloat itemH = 35;
    
    RMCollectionViewFlowLayout *flowLayout = [[RMCollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.headerReferenceSize = CGSizeMake(APP_WIDTH, 50);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 15;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.contentInset = UIEdgeInsetsMake(0, 15, 40, 15);
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[RMCollectionCell class] forCellWithReuseIdentifier:CellIdentifier];
    [collectionView registerClass:[RMCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    
    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //RMExpectindustryEntity *item = [self.tableArray objectAtIndex:section];
    return self.tableArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor grayColor];
    RMExpectindustryEntity *item = [self.tableArray objectAtIndex:indexPath.row];
    
    cell.buttonItem = item;
    
    __weak typeof(self) weakSelf = self;
    cell.refreshSection = ^(NSIndexPath *path) {
        [weakSelf refreshSection:path];
    };
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    YQDDCollectionCell *cell = [[YQDDCollectionCell alloc] init];
    RMExpectindustryEntity *item = [self.tableArray objectAtIndex:indexPath.row];
    NSString *content = item.tname;
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
        RMCollectionHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        
        //RMExpectindustryEntity *item = [self.tableArray objectAtIndex:indexPath.row];
        header.titleLabel.text = @"选择期望行业,最多3个";
        
        //header.backgroundColor = [UIColor yellowColor];
        
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewcell按钮点击回调方法

- (void)refreshSection:(NSIndexPath *)path
{
    // 重置其他的选择状态并刷新
    RMExpectindustryEntity *item = [self.tableArray objectAtIndex:path.row];
    item.isSelect = !item.isSelect;
    int flag = 0;
    for (RMExpectindustryEntity *singleItem in self.tableArray) {
        if (singleItem.isSelect) {
            flag ++;
        }
    }
    if (flag > 3) {
        CLog(@"最多选三个");
        item.isSelect = NO;
    }
    
    
    //NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
    //[self.collectionView reloadSections:indexSet];
    [self.collectionView reloadData];
}

- (void)reqHoptrade
{
    [[RequestManager sharedRequestManager] getExpectIndustry_uid:nil success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            for (NSDictionary *dict in resultDic[DATA]) {
                
                RMExpectindustryEntity *en = [RMExpectindustryEntity ExpectindustryEntity:dict];
                en.isSelect = NO;
                for (RMExpectindustryEntity *item in self.expectArray) {
                    if ([item.uid isEqualToString:en.uid]) {
                        en.isSelect = YES;
                        break;
                    }
                }
                
                [self.tableArray addObject:en];
            }
            
            [self.collectionView reloadData];
            
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

//-(void)dealloc
//{
//    NSLog(@"%@",NSStringFromClass([self class]));
//}

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

#pragma mark -
#pragma mark - CollectionCell

@interface RMCollectionCell ()

@end

@implementation RMCollectionCell

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
        [textBtn setBackgroundColor:[UIColor redColor] forState:UIControlStateSelected];
        textBtn.layer.cornerRadius = 3;
        textBtn.layer.borderColor = RGB(180, 180, 180).CGColor;
        textBtn.layer.borderWidth = 0.5;
        textBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:textBtn];
        self.textButton = textBtn;
    }
    
    return self;
}

- (void)setButtonItem:(RMExpectindustryEntity *)buttonItem
{
    _buttonItem = buttonItem;
    
    NSString *content = buttonItem.tname;
    int itemW = [content yq_stringWidthWithFixedHeight:30 font:17];
    itemW = itemW < defaultItemW ? defaultItemW : itemW;
    CGRect frame = self.textButton.frame;
    frame.size.width = itemW;
    self.textButton.frame = frame;
    self.textButton.selected = buttonItem.isSelect;
    self.textButton.layer.borderWidth = buttonItem.isSelect ? 0 : 0.5;
    
    if ([buttonItem.uid isEqualToString:@"-1"]) {
        [self.textButton setBackgroundImage:[UIImage imageNamed:@"addkey"] forState:UIControlStateNormal];
        [self.textButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self.textButton setTitle:content forState:UIControlStateNormal];
        [self.textButton setBackgroundImage:[UIImage imageNamed:@"addkey_un"] forState:UIControlStateNormal];
    }
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

@implementation RMCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        titleLabel.textColor = RGB(102, 102, 102);
        titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel = titleLabel;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        //YQDDCollectionItem *item = [self.tableArray objectAtIndex:indexPath.section];
        //titleLabel.text = item.collectionText;
        
    }
    
    return self;
}

@end

#pragma mark -
#pragma mark - 左对齐样式

@interface RMCollectionViewFlowLayout()
{
    //在居中对齐的时候需要知道这行所有cell的宽度总和
    CGFloat _sumCellWidth ;
}
@end

@implementation RMCollectionViewFlowLayout

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
