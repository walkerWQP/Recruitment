//
//  CompanyLabelController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define defaultItemW 60

#import "CompanyLabelController.h"
#import "RMExpectindustry.h"

#import "RMExpectindustryEntity.h"

#import "NSString+YQWidthHeight.h"

static NSString *CellIdentifier = @"collectionCell";
static NSString *HeaderIdentifier = @"headerCell";

@interface CompanyLabelController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
{
    NSInteger totalCount;
}
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CompanyLabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self reqHoptrade];
    
    [self initCollectionView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"确定" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
    if (totalCount == 0) {
        totalCount = 3;
    }
}

- (void)setIsAdd:(BOOL)isAdd
{
    _isAdd = isAdd;
    if (isAdd) {
        RMExpectindustryEntity *en = [[RMExpectindustryEntity alloc] init];
        en.isSelect = NO;
        en.tname = @"add";
        en.uid = @"-1";
        [self.tableArray addObject:en];
        //[self.collectionView reloadData];
    }
}

- (NSMutableArray *)tableArray
{
    if (_tableArray == nil) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *str in self.allArray) {
            RMExpectindustryEntity *en = [[RMExpectindustryEntity alloc] init];
            en.isSelect = NO;
            en.tname = str;
            en.uid = [NSString stringWithFormat:@"%li",[self.allArray indexOfObject:str]+1];
            [array addObject:en];
        }
        
        for (RMExpectindustryEntity *item in self.expectArray) {
            int flag = 0;
            for (RMExpectindustryEntity *sub in array) {
                if ([item.tname isEqualToString:sub.tname]) {
                    sub.isSelect = YES;
                    flag = 1;
                    break;
                }
            }
            if (flag == 0) {
                RMExpectindustryEntity *en = [[RMExpectindustryEntity alloc] init];
                en.isSelect = YES;
                en.tname = item.tname;
                en.uid = [NSString stringWithFormat:@"%li",array.count];
                [array addObject:en];
            }
        }
        _tableArray = array;
    }
    return _tableArray;
}

//- (void)setTableArray:(NSMutableArray *)tableArray
//{
//    //_tableArray = tableArray;
//    
//    
//}

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

- (void)setSelectCount:(NSInteger)selectCount
{
    _selectCount = selectCount;
    
    totalCount = selectCount;
}

//- (void)setTitleStr:(NSString *)titleStr
//{
//    _titleStr = titleStr;
//    
//    //self.titleLabel.text = titleStr;
//}

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
        
        if (self.titleStr != nil) {
            header.titleLabel.text = self.titleStr;
        }else{
            header.titleLabel.text = @"选择所在行业,最多3个";
        }
        //header.backgroundColor = [UIColor yellowColor];
        
        return header;
    }
    return nil;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            if (tf.text.length>0) {
                if (tf.text.length>6) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"不能超过6个字" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    RMExpectindustryEntity *en = [[RMExpectindustryEntity alloc] init];
                    en.isSelect = YES;
                    en.tname = tf.text;
                    en.uid = [NSString stringWithFormat:@"%li",self.tableArray.count];
                    [self.tableArray insertObject:en atIndex:self.tableArray.count-1];
                    [self.collectionView reloadData];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"不能为空" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}

#pragma mark - UICollectionViewcell按钮点击回调方法

- (void)refreshSection:(NSIndexPath *)path
{
    RMExpectindustryEntity *item = [self.tableArray objectAtIndex:path.row];
    item.isSelect = !item.isSelect;
    int flag = 0;
    for (RMExpectindustryEntity *singleItem in self.tableArray) {
        if (singleItem.isSelect) {
            flag ++;
        }
    }
    // 重置其他的选择状态并刷新
    if ([item.uid isEqualToString:@"-1"]) {
        item.isSelect = NO;
        if (flag > totalCount) {
            NSString *str = [NSString stringWithFormat:@"最多%li个标签",totalCount];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入标签,不超过6个字" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 1001;
            [alert show];
        }
    }else{
        
        if (flag > totalCount) {
            NSString *str = [NSString stringWithFormat:@"最多%li个标签",totalCount];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            item.isSelect = NO;
        }
    
        //NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
        //[self.collectionView reloadSections:indexSet];
        [self.collectionView reloadData];
    }
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
