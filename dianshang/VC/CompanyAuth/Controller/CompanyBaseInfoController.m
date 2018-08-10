//
//  CompanyBaseInfoController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/27.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "CompanyBaseInfoController.h"
#import "CompanyLabelController.h"

#import "EZCPersonCenterEntity.h"
#import "RMExpectindustryEntity.h"
#import "YQCityLocation.h"

#import "KNActionSheet.h"
#import "YQCityListView.h"

#import "EaseLocationViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface CompanyBaseInfoController ()<UIAlertViewDelegate,YQCityLocationDelegate,EMLocationViewDelegate>
{
    UIView *headView;
    NSIndexPath *currentIndexPath;
}
/// 选择城市视图
@property (nonatomic, strong) YQCityListView *cityView;

@property (nonatomic, strong) UIImageView    *headImageView;

@property (nonatomic, strong) NSString       *nickName;
@property (nonatomic, strong) NSString       *address;

@property (nonatomic, strong) NSArray        *scopeArray;// 公司规模数组
@property (nonatomic, strong) NSArray        *financingArray;// 融资规模数组

@property (nonatomic, strong) NSArray        *tradeLabelArr;// 所在行业标签
@property (nonatomic, strong) NSArray        *companyArray;// 公司福利标签
@property (nonatomic, strong) NSMutableArray *tradeList;// 网络获取行业列表

@property (nonatomic, strong) NSString       *logoUrl;// 公司logo地址
@property (nonatomic, strong) NSString       *provStr;// 省
@property (nonatomic, strong) NSString       *cityStr;// 市
@property (nonatomic, strong) NSString       *areaStr;// 区

@property (nonatomic, strong) YQCityLocation *cityLocation;
@property (nonatomic, strong) NSString       *lon;//经度
@property (nonatomic, strong) NSString       *lat;//纬度
@property (nonatomic, strong) NSString       *markStr;


@end

@implementation CompanyBaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公司信息";
    
    if ([self.entity.companyEn.cname isEqualToString:@""]) {
        // 开启定位 监听 cityName
        YQCityLocation *city = [[YQCityLocation alloc] init];
        [city startLocation];
        city.delegate = self;
        self.cityLocation = city;
        //[city addObserver:self forKeyPath:@"latlonStr" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getScopeList]];
    [array removeObjectAtIndex:0];
    self.scopeArray = array;
    array = [NSMutableArray arrayWithArray:[EZPublicList getFinancingList]];
    [array removeObjectAtIndex:0];
    self.financingArray = array;
    
    [self reqHoptrade];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"保存" titleColor:[UIColor whiteColor] target:self action:@selector(rightClick:)];
}

- (void)setUpdata
{
    if (self.groups.count>0) {
        [self.groups removeAllObjects];
    }
    YQWeakSelf;
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    YQCellItem *item2 = [YQCellItem setCellItemImage:nil title:@"公司名"];
    item2.subTitle = @"填写公司名";
    item2.operationBlock = ^{
        [weakSelf changeName];
    };
    [mArr addObject:item2];
    
    YQCellItem *item0 = [YQCellItem setCellItemImage:nil title:@"公司规模"];
    item0.subTitle = @"选择公司规模";
    item0.operationBlock = ^{
        [weakSelf selectView:0];
    };
    [mArr addObject:item0];
    
    YQCellItem *item6 = [YQCellItem setCellItemImage:nil title:@"融资规模"];
    item6.subTitle = @"选择融资规模";
    [mArr addObject:item6];
    item6.operationBlock = ^{
        [weakSelf selectView:1];
    };
    YQCellItem *item7 = [YQCellItem setCellItemImage:nil title:@"所在行业"];
    item7.subTitle = @"选择所在行业";
    [mArr addObject:item7];
    item7.operationBlock = ^{
        if (![self.typeStr isEqualToString:@"1"]) {
            [weakSelf goTrade];
        } else {
            NSLog(@"已认证的企业所在行业无法修改");
        }
    };
    
    YQCellItem *item3 = [YQCellItem setCellItemImage:nil title:@"公司标签"];
    item3.subTitle = @"选择公司标签";
    item3.operationBlock = ^{
        [weakSelf goCompanyLabel];
    };
    [mArr addObject:item3];

    YQCellItem *item5 = [YQCellItem setCellItemImage:nil title:@"所在省市"];
    item5.subTitle = @"选择所在省市";
    item5.operationBlock = ^{
        if (![self.typeStr isEqualToString:@"1"]) {
            [weakSelf selectView:2];
        } else {
            NSLog(@"已认证的企业所在省市无法修改");
        }
    };
    [mArr addObject:item5];
    
    YQCellItem *item1 = [YQCellItem setCellItemImage:nil title:@"详细地址"];
    item1.subTitle = @"填写详细地址";
    item1.operationBlock = ^{
        [weakSelf changeAddress];
    };
    [mArr addObject:item1];
    
    YQCellItem *item8 = [YQCellItem setCellItemImage:nil title:@"地图标注"];
    item8.subTitle = @"未标注";
    item8.operationBlock = ^{
        [weakSelf labelPosition];
    };
    [mArr addObject:item8];
    
    YQGroupCellItem *group1 = [YQGroupCellItem setGroupItems:mArr headerTitle:nil footerTitle:nil];
    [self.groups addObject:group1];
    
    EZCompanyInfoEntity *en = self.entity.companyEn;
    if (![en.cname isEqualToString:@""]) {
        item2.subTitle = en.cname;
        self.nickName = en.cname;
    }
    if ([en.scale integerValue] > 0) {
        item0.subTitle = [self.scopeArray objectAtIndex:[en.scale integerValue]-1];
    }
    if ([en.cvedit integerValue] > 0) {
        item6.subTitle = [self.financingArray objectAtIndex:[en.cvedit integerValue]-1];
    }
    if (![en.tradeid isEqualToString:@""]) {
        if ([en.tradeid isEqualToString:@"0"]) {
            item7.subTitle = @"选择所在行业";
        }else{
            NSArray *array = [en.tradeid componentsSeparatedByString:@","];
            
            if (array.count > 0) {
                item7.subTitle = [NSString stringWithFormat:@"%li个标签",array.count];
            }else{
                item7.subTitle = @"选择所在行业";
            }
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSString *str in array) {
                RMExpectindustryEntity *en = [[RMExpectindustryEntity alloc] init];
                //en.tname = [[EZPublicList getTradeList] objectAtIndex:[str integerValue]];
                en.tname = [self.tradeList objectAtIndex:[str integerValue]-1];
                en.uid = str;
                [mArr addObject:en];
            }
            self.tradeLabelArr = mArr;
        }
    }
    if (![en.ctag isEqualToString:@""]) {
        NSArray *array = [en.ctag componentsSeparatedByString:@"|"];
        
        if (array.count > 0) {
            item3.subTitle = [NSString stringWithFormat:@"%li个标签",array.count];
        }else{
            item3.subTitle = @"选择公司标签";
        }
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSString *str in array) {
            RMExpectindustryEntity *en = [[RMExpectindustryEntity alloc] init];
            en.tname = str;
            [mArr addObject:en];
        }
        self.companyArray = mArr;
    }
    if (![en.city isEqualToString:@""]) {
        NSString *provStr = en.province;
        NSString *cityStr = en.city;
        NSString *areaStr = en.area;
        self.provStr = provStr;
        self.cityStr = cityStr;
        self.areaStr = areaStr;
        if ([provStr isEqualToString:cityStr]) {
            item5.subTitle = [NSString stringWithFormat:@"%@ %@",cityStr,areaStr];
        }else{
            item5.subTitle = [NSString stringWithFormat:@"%@ %@ %@",provStr,cityStr,areaStr];
        }
        self.lat = en.lat;
        self.lon = en.lng;
    }
    if (![en.address isEqualToString:@""]) {
        item1.subTitle = en.address;
        self.address = en.address;
    }
    
    if ([self.lat isEqualToString:@""] && [self.lon isEqualToString:@""]) {
        
        item8.subTitle = @"未标注";
    } else {
        
        item8.subTitle = @"已标注";
    }
   
    
}

- (void)initView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClick:)];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addGestureRecognizer:tap];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.yq_bottom-3, APP_WIDTH, 3)];
    lineView.backgroundColor = RGB(243, 243, 243);
    [headView addSubview:lineView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:headView.bounds];
    label.text = @"    公司logo";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    [headView addSubview:label];
    
    if (![self.entity.companyEn.logo isEqualToString:@""]) {
        self.logoUrl = self.entity.companyEn.logo;
    }
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(APP_WIDTH-80, (80-65)/2, 65, 65)];
    NSString *avatar = [NSString stringWithFormat:@"%@%@",ImageURL,self.logoUrl];
    [image sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"cheadImg"]];
    image.tag = -1;
    [headView addSubview:image];
    //image.layer.cornerRadius = image.frame.size.height/2;
    //image.layer.masksToBounds = YES;
    self.headImageView = image;
    
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:self.tableView];
}
#pragma mark - table

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    
    if (item.operationBlock != nil) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentIndexPath = indexPath;
    
    YQGroupCellItem *group = [self.groups objectAtIndex:indexPath.section];
    YQCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    if (item.operationBlock) {
        item.operationBlock();
    }
}

#pragma mark - 选择头像
//点击头像选择图库还是拍照
- (void)headTapClick:(UIGestureRecognizer *)sender
{
    self.isClip = YES;//表示需要裁剪
    [self openActionSheet:YQClipTypeSquare];
}

- (void)uploadImage:(UIImage *)originImage filePath:(NSString *)filePath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 显示
    self.headImageView.image = originImage;
    
    // 保存图片到数组
    NSData *imageData = UIImagePNGRepresentation(originImage);
    [self changePersonInfo_headImg:imageData];
}
#pragma mark - 事件

//保存内容
- (void)rightClick:(UIButton *)sender
{
    if (![self.typeStr isEqualToString:@"1"]) {
        YQGroupCellItem *items = [self.groups objectAtIndex:0];
        YQCellItem *item = [items.items objectAtIndex:1];
        NSString *scaleStr = [NSString stringWithFormat:@"%li",[self.scopeArray indexOfObject:item.subTitle]+1];//公司规模
        YQCellItem *item2 = [items.items objectAtIndex:2];
        NSInteger a = [self.financingArray indexOfObject:item2.subTitle];
        NSString *cveditStr = [NSString stringWithFormat:@"%li",a+1];//融资规模
        
        NSString *tradeStr = @"";
        for (RMExpectindustryEntity *en in self.tradeLabelArr) {
            tradeStr = [tradeStr stringByAppendingString:en.uid];
            if (![en isEqual:self.tradeLabelArr.lastObject]) {
                tradeStr = [tradeStr stringByAppendingString:@","];
            }
        }
        NSString *companyStr = @"";
        for (RMExpectindustryEntity *en in self.companyArray) {
            companyStr = [companyStr stringByAppendingString:en.tname];
            if (![en isEqual:self.companyArray.lastObject]) {
                companyStr = [companyStr stringByAppendingString:@"|"];
            }
        }
        
        NSString *msg = @"";
        if (self.logoUrl.length == 0) {
            msg = @"请设置公司logo";
        }else if (self.nickName.length == 0) {
            msg = @"请填写公司名";
        }else if ([scaleStr integerValue] < 0) {
            msg = @"请选择公司规模";
        }else if ([cveditStr integerValue] < 0) {
            msg = @"请选择融资规模";
        }else if (self.tradeLabelArr.count == 0) {
            msg = @"请选择所在行业";
        }else if (self.companyArray.count == 0) {
            msg = @"请选择公司标签";
        }else if (self.provStr.length == 0) {
            msg = @"请选择省市区";
        }else if (self.address.length == 0) {
            msg = @"请填写公司详细地址";
        } else if (self.lat.length == 0 || self.lon.length == 0) {
            // 定位失败后用固定数据(以后再改)
            //            self.lon = @"113.664764";
            //            self.lat = @"34.827373";
            msg = @"请标注公司位置";
        } else {
            
            [self.hud show:YES];
            [[RequestManager sharedRequestManager] companyAuthBaseInfo_uid:[UserEntity getUid] cname:self.nickName lat:self.lat lng:self.lon province:self.provStr city:self.cityStr area:self.areaStr logo:self.logoUrl scale:scaleStr cvedit:cveditStr ctag:companyStr address:self.address tradeid:tradeStr success:^(id resultDic) {
                [self.hud hide:YES];
                if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                    [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                    self.entity.companyEn.cname = self.nickName;
                    self.entity.companyEn.scale = scaleStr;
                    self.entity.companyEn.cvedit = cveditStr;
                    self.entity.companyEn.lng = self.lon;
                    self.entity.companyEn.lat = self.lat;
                    self.entity.companyEn.province = self.provStr;
                    self.entity.companyEn.city = self.cityStr;
                    self.entity.companyEn.area = self.areaStr;
                    self.entity.companyEn.address = self.address;
                    self.entity.companyEn.tradeid = tradeStr;
                    self.entity.companyEn.ctag = companyStr;
                    self.entity.companyEn.logo = self.logoUrl;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlreadyPerfect" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {
                [self.hud hide:YES];
                NSLog(@"网络连接错误");
            }];
        }
        
        if (msg.length >0) {
            [YQToast yq_ToastText:msg bottomOffset:100];
        }
    } else {
        YQGroupCellItem *items = [self.groups objectAtIndex:0];
        YQCellItem *item = [items.items objectAtIndex:1];
        NSString *scaleStr = [NSString stringWithFormat:@"%li",[self.scopeArray indexOfObject:item.subTitle]+1];//公司规模
        YQCellItem *item2 = [items.items objectAtIndex:2];
        NSInteger a = [self.financingArray indexOfObject:item2.subTitle];
        NSString *cveditStr = [NSString stringWithFormat:@"%li",a+1];//融资规模
        
        NSString *tradeStr = @"";
        for (RMExpectindustryEntity *en in self.tradeLabelArr) {
            tradeStr = [tradeStr stringByAppendingString:en.uid];
            if (![en isEqual:self.tradeLabelArr.lastObject]) {
                tradeStr = [tradeStr stringByAppendingString:@","];
            }
        }
        NSString *companyStr = @"";
        for (RMExpectindustryEntity *en in self.companyArray) {
            companyStr = [companyStr stringByAppendingString:en.tname];
            if (![en isEqual:self.companyArray.lastObject]) {
                companyStr = [companyStr stringByAppendingString:@"|"];
            }
        }
        
        NSLog(@"1     %@",self.nickName);
        NSLog(@"2     %@",scaleStr);
        NSLog(@"3     %@",cveditStr);
        NSLog(@"4     %@",self.lon);
        NSLog(@"5     %@",self.lat);
        NSLog(@"6     %@",self.provStr);
        NSLog(@"7     %@",self.cityStr);
        NSLog(@"8     %@",self.areaStr);
        NSLog(@"9     %@",self.address);
        NSLog(@"10    %@",tradeStr);
        NSLog(@"11    %@",companyStr);
        NSLog(@"12    %@",self.logoUrl);
        
        self.entity.companyEn.cname = self.nickName;
        self.entity.companyEn.scale = scaleStr;
        self.entity.companyEn.cvedit = cveditStr;
        self.entity.companyEn.lng = self.lon;
        self.entity.companyEn.lat = self.lat;
        self.entity.companyEn.province = self.provStr;
        self.entity.companyEn.city = self.cityStr;
        self.entity.companyEn.area = self.areaStr;
        self.entity.companyEn.address = self.address;
        self.entity.companyEn.tradeid = tradeStr;
        self.entity.companyEn.ctag = companyStr;
        self.entity.companyEn.logo = self.logoUrl;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlreadyPerfect" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//地图标注
- (void)labelPosition {
    
    EaseLocationViewController *easeLocationVC = [[EaseLocationViewController alloc] init];
    easeLocationVC.typeStr = @"1";
    easeLocationVC.delegate = self;
    [self.navigationController pushViewController:easeLocationVC animated:YES];
    
}

- (void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address {
    self.lat = [NSString stringWithFormat:@"%f",latitude];
    self.lon = [NSString stringWithFormat:@"%f",longitude];
    [self.tableView reloadData];
}


- (void)goCompanyLabel
{
    CompanyLabelController *vc = [[CompanyLabelController alloc] init];
    vc.navigationItem.title = @"公司标签";
    vc.selectCount = 6;
    vc.titleStr = @"选择公司标签,最多6个";
    NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getCompanyLabelList]];
    [array removeObjectAtIndex:0];
    vc.allArray = array;
    vc.expectArray = self.companyArray;
    vc.isAdd = YES;
    // 根据数据刷新
    YQWeakSelf;
    vc.expectIndustryBlock = ^(NSArray *array) {
        [weakSelf refreshTable:array tag:1];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goTrade
{
    CompanyLabelController *vc = [[CompanyLabelController alloc] init];
    vc.navigationItem.title = @"所在行业";
    vc.selectCount = 1;
    vc.titleStr = @"选择1个公司行业标签";
    //NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getTradeList]];
    //[array removeObjectAtIndex:0];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.tradeList];
    vc.allArray = array;
    vc.expectArray = self.tradeLabelArr;
    // 根据数据刷新
    YQWeakSelf;
    vc.expectIndustryBlock = ^(NSArray *array) {
        [weakSelf refreshTable:array tag:0];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshTable:(NSArray *)array tag:(NSInteger)tag
{
    YQGroupCellItem *items = [self.groups objectAtIndex:0];
    YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
    if (tag == 0) {
        // 所在行业
        
        self.tradeLabelArr = array;
        if (array.count > 0) {
            item.subTitle = [NSString stringWithFormat:@"%li个标签",array.count];
        }else{
            item.subTitle = @"选择所在行业";
        }
    }else if (tag == 1) {
        // 公司标签
        self.companyArray = array;
        if (array.count > 0) {
            item.subTitle = [NSString stringWithFormat:@"%li个标签",array.count];
        }else{
            item.subTitle = @"选择公司标签";
        }
    }else if (tag == 2) {
        // 公司规模
        if (array.count > 0) {
            NSInteger a = [array.firstObject integerValue];
            item.subTitle = [self.scopeArray objectAtIndex:a];
        }
    }else if (tag == 3) {
        // 融资规模
        if (array.count > 0) {
            NSInteger a = [array.firstObject integerValue];
            item.subTitle = [self.financingArray objectAtIndex:a];
        }
    }else if (tag == 4) {
        // 城市
        if (array.count > 0) {
            item.subTitle = array.firstObject;
        }
    }
    [self.tableView reloadData];
}
- (void)selectView:(NSInteger)tag
{
    NSArray *array = nil;
    if (tag == 0) {
        // 公司规模
        array = self.scopeArray;
    }else if (tag == 1){
        // 融资规模
        array = self.financingArray;
    }else if (tag == 2){
        [self.cityView showAnimate];
    }
    
    if (array) {
        YQWeakSelf;
        KNActionSheet *actionSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:array  actionBlock:^(NSInteger buttonIndex) {
            if (buttonIndex != -1) {
                NSString *str = [NSString stringWithFormat:@"%li",buttonIndex];
                [weakSelf refreshTable:@[str] tag:2+tag];
            }
        }];
        [actionSheet show];
    }
}
// 城市view
- (YQCityListView *)cityView
{
    if (_cityView == nil) {
        YQCityListView *cityView = [[YQCityListView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT) column:3];
        //YQGroupCellItem *items = [self.groups objectAtIndex:0];
        //YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
        cityView.defultCityStr = self.cityStr;
        cityView.titleStr = @"所在城市";
        YQWeakSelf;
        [cityView buttonPress:^(NSString *provStr, NSString *cityStr, NSString *areaStr) {
            CLog(@"%@->%@->%@",provStr,cityStr,areaStr);
            weakSelf.provStr = provStr;
            weakSelf.cityStr = cityStr;
            weakSelf.areaStr = areaStr;
            if ([provStr isEqualToString:cityStr]) {
                [weakSelf refreshTable:@[[NSString stringWithFormat:@"%@ %@",cityStr,areaStr]] tag:4];
            }else{
                [weakSelf refreshTable:@[[NSString stringWithFormat:@"%@ %@ %@",provStr,cityStr,areaStr]] tag:4];
            }
            
        }];
        _cityView = cityView;
    }
    return _cityView;
}
- (void)changeName
{
    if (![self.typeStr isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"公司名" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 1000;
        [alert show];
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.placeholder = @"填写公司名";
        tf.text = self.nickName;
    } else {
        NSLog(@"已认证过得公司名称无法修改");
    }
    
    
}
- (void)changeAddress
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"填写地址" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1001;
    [alert show];
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"填写详细地址";
    tf.text = self.address;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        // 昵称
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            self.nickName = tf.text;
            if (tf.text.length>0) {
                [self changePersonInfo_nickname:tf.text];
            }
        }
    }else if (alertView.tag == 1001){
        // 简介
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            self.address = tf.text;
            if (tf.text.length>0) {
                [self changePersonInfo_Address:tf.text];
            }
        }
    }
}

- (void)changePersonInfo_nickname:(NSString *)nickname
{
    YQGroupCellItem *items = [self.groups objectAtIndex:0];
    YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
    item.subTitle = nickname;
    
    [self.tableView reloadData];
}
- (void)changePersonInfo_Address:(NSString *)desc
{
    YQGroupCellItem *items = [self.groups objectAtIndex:0];
    YQCellItem *item = [items.items objectAtIndex:currentIndexPath.row];
    item.subTitle = desc;
    
    [self.tableView reloadData];
}

// 修改头像
- (void)changePersonInfo_headImg:(NSData *)headImg
{
    [self.slideView show:YES];
    [[RequestManager sharedRequestManager] uploadImage_uid:[UserEntity getUid] imageArr:@[headImg] progressBlock:^(CGFloat f) {
        self.slideView.progress = f;
    } success:^(id resultDic) {
        [self.slideView hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSDictionary *dict = resultDic[DATA];
            self.logoUrl = [dict objectForKey:@"file"];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
    
    //[self.slideView show:YES];//self.slideView.progress = f;
    //    NSString *avatar = @"";
    //    [[RequestManager sharedRequestManager] userSetting_uid:[UserEntity getUid] phone:@"" avatar:avatar name:@"" sex:@"" birthday:@"" wechatid:@"" restatus:@"" success:^(id resultDic) {
    //
    //    } failure:nil];
}
#pragma mark - YQCityLocationDelegate

- (void)yq_locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    double lat = locations.firstObject.coordinate.latitude;
    double lon = locations.firstObject.coordinate.longitude;
    
    self.lat = [NSString stringWithFormat:@"%f",lat];
    self.lon = [NSString stringWithFormat:@"%f",lon];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            self.cityStr = [city hasSuffix:@"市"] ? [city substringToIndex:city.length-1] : city;
            self.provStr = placemark.administrativeArea;
            self.areaStr = placemark.subLocality;
            
            YQGroupCellItem *items = [self.groups objectAtIndex:0];
            YQCellItem *item = [items.items objectAtIndex:5];
            
            if (placemark.administrativeArea == nil) {
                self.provStr = self.cityStr;
                item.subTitle = [NSString stringWithFormat:@"%@ %@",self.cityStr,self.areaStr];
            }else{
                item.subTitle = [NSString stringWithFormat:@"%@ %@ %@",self.provStr,self.cityStr,self.areaStr];
            }
            
            [self.tableView reloadData];
        }
        else if (error == nil && [array count] == 0)
        {
            CLog(@"No results were returned.");
            //self.cityName = @"error";
        }
        else if (error != nil)
        {
            CLog(@"An error occurred = %@", error);
            //self.cityName = @"error";
        }
    }];
}
/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"latlonStr"])
    {
        NSString *cityName = change[@"new"];
        if (cityName.length>0) {
            
            
            YQGroupCellItem *items = [self.groups objectAtIndex:0];
            YQCellItem *item = [items.items objectAtIndex:5];
            NSString *scaleStr = [NSString stringWithFormat:@"%li",[self.scopeArray indexOfObject:item.subTitle]+1];//公司规模
        }
        
        
        [self.tableView reloadData];
    }
}

- (void)dealloc
{
    [self.cityLocation removeObserver:self forKeyPath:@"cityName"];
}*/

- (void)reqHoptrade
{
    [self.hud show:YES];
    [[RequestManager sharedRequestManager] getExpectIndustry_uid:nil success:^(id resultDic) {
        [self.hud hide:YES];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            
            self.tradeList = [NSMutableArray array];
            for (NSDictionary *dict in resultDic[DATA]) {
                
//                RMExpectindustryEntity *en = [RMExpectindustryEntity ExpectindustryEntity:dict];
//                en.isSelect = NO;
                
                [self.tradeList addObject:dict[@"tname"]];
            }
            
            [self setUpdata];
            [self initView];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)dealloc
{
    
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
