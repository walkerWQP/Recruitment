//
//  EZPublicList.m
//  dianshang
//
//  Created by yunjobs on 2017/10/21.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "EZPublicList.h"

#import "PersonItem.h"

#import "SettingViewController.h"
#import "UserMangerController.h"

#import "ResumeManageController.h"
#import "FollowJobController.h"
#import "DeliveryJobController.h"
#import "WalletViewController.h"
#import "CPositionMangerController.h"
#import "WhiteListController.h"// 白名单
#import "CResumeDeliverController.h"//企业端简历投递记录
#import "CResumeRecommendController.h"//企业端简历推荐记录
#import "DeliveryRecordController.h"
#import "RecommendOrderController.h"
#import "PersonalAuthController.h"
#import "SharedViewController.h"




@implementation EZPublicList

/// 经验
+ (NSArray *)getExperienceList
{
    NSArray *array = @[@"不限",
                       @"1年以下",
                       @"1-3年",
                       @"3-5年",
                       @"5-10年",
                       @"10年以上"
];
    return array;
}
/// 技能
+ (NSArray *)getSkillList
{
    NSArray *array = @[@"IT互联网",
                       @"社交",
                       @"媒体",
                       @"视频音频",
                       @"地图服务",
                       @"网络安全",
                       @"移动开发",
                       @"后端开发",
                       @"PHP",
                       @"Node.js",
                       @"GO",
                       @".Net",
                       @"前段开发",
                       @"Python",
                       @"Android",
                       @"iOS",
                       @"架构",
                       @"Unix/Linux开发",
                       @"机器学习",
                       @"数据挖掘",
                       @"Java",
                       @"算法",
                       @"机器学习",
                       @"文化传媒",
                       @"金融",
                       @"旅游娱乐",
                       @"商务服务",
                       @"幼儿教育",
                       @"成人教育",
                       @"建筑房产",
                       @"通信服务",
                       @"电子设备制造",
                       @"制造业",
                       @"贸易",
                       @"住宿/餐饮",
                       @"交通物流",
                       @"渠道",
                       @"市场开拓",
                       @"网络运营",
                       @"网络营销"];
    return array;
}
/// 顾问费
+ (NSArray *)getCostList
{
    NSArray *array = @[@"全部",
                       @"500以下",
                       @"500-1000",
                       @"1000-2000",
                       @"2000-3000",
                       @"3000-5000",
                       @"5000以上"
                       ];
    return array;
}
/// 薪资
+ (NSArray *)getSalaryList
{
    NSArray *array = @[@"全部",
                       @"3k以下",
                       @"3k-5k",
                       @"5k-10k",
                       @"10k-20k",
                       @"20k-50k",
                       @"50k以上"
                       ];
    return array;
}
+ (NSString *)getSalaryConvert:(NSString *)itemId
{
    NSString *str = @"0-0";
    switch ([itemId intValue]) {
        case 0:
            str = @"0-0";
            break;
        case 1:
            str = @"0-3";
            break;
        case 2:
            str = @"3-5";
            break;
        case 3:
            str = @"5-10";
            break;
        case 4:
            str = @"10-20";
            break;
        case 5:
            str = @"20-50";
            break;
        case 6:
            str = @"50-100";
            break;
            
        default:
            break;
    }
    return str;
}
/// 公司规模
+ (NSArray *)getScopeList
{
    NSArray *array = @[@"全部",
                       @"0-20人",
                       @"20-99人",
                       @"100-499人",
                       @"500-999人",
                       @"1000-9999人",
                       @"10000人以上"
];
    return array;
}
/// 公司标签
+ (NSArray *)getCompanyLabelList
{
    NSArray *array = @[@"股票期权",
                        @"带薪年假",
                        @"年度旅游",
                        @"不打卡",
                        @"年终分红",
                        @"免费零食",
                        @"美女如云",
                        @"扁平管理",
                        @"地铁周边",
                        @"领导nice",
                        @"移动互联网",
                        @"电子商务",
                        @"互联网金融",
                        @"智能硬件",
                        @"公司氛围好"];
    return array;
}
/// 行业
+ (NSArray *)getTradeList
{
    NSArray *array = @[@"全部",
                       @"非互联网行业",
                       @"健康医疗",
                       @"生活服务",
                       @"旅游",
                       @"金融",
                       @"信息安全",
                       @"广告营销",
                       @"移动互联网",
                       @"IT行业",
                       @"数据服务",
                       @"智能硬件",
                       @"电子商务",
                       @"信息安全",
                       @"文化体育娱乐",
                       @"企业服务",
                       @"社交网络",
                       @"教育培训",
                       @"新媒体",
                       @"快消品",
                       @"建筑工程",
                       @"物流快递",
                       @"贸易/进出口",
                       @"汽车行业",
                       @"咨询",
                       @"地产/建筑/工程",
                       @"贸易/零售"
                       ];
    return array;
}
/// 学历
+ (NSArray *)getEducationList
{
    NSArray *array = @[@"不限",
                       @"中专及以下",
                       @"高中",
                       @"大专",
                       @"本科",
                       @"硕士",
                       @"博士"
];
    return array;
}
/// 公司标识
+ (NSArray *)getCompanyFlagList
{
    NSArray *array = @[@"不限",
                       @"认证",
                       @"上门",
                       @"未认证",
                       @"认证被驳回"
                       
];
    return array;
}
/// 融资
+ (NSArray *)getFinancingList
{
    NSArray *array = @[@"全部",
                       @"未融资",
                       @"天使轮",
                       @"A轮",
                       @"B轮",
                       @"C轮",
                       @"D轮及以上",
                       @"已上市",
                       @"不需要融资"
];
    return array;
}

/// 求职状态
+ (NSArray *)getJobIntentionStateList
{
    NSArray *array = @[@"全部",
                       @"在职-暂不考虑",
                       @"在职-考虑机会",
                       @"离职-随时到岗"
                       ];
    return array;
}

#pragma mark - 城市列表

+ (NSDictionary *)getCityDict
{
    //获取地区列表
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSDictionary *dict0 = [[NSDictionary alloc] initWithContentsOfFile:path];

    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

    for (NSString *str in dict0) {
        NSDictionary *provDict = dict0[str];
        NSString *provName = provDict.allKeys[0];
        NSDictionary *cityDict = provDict[provName];
        
        NSMutableDictionary *tempCityArr = [NSMutableDictionary dictionary];
        for (NSString *str in cityDict) {
            NSDictionary *shiDic1 = cityDict[str];
            NSString *cityName = shiDic1.allKeys[0];
            NSArray *areaArr = shiDic1[cityName];
            
            [tempCityArr setObject:areaArr forKey:cityName];
        }
        [mDict setObject:tempCityArr forKey:provName];
    }
    return mDict;
}
// 根据城市获取区县列表
+ (NSArray *)getAreaListWith:(NSString *)city
{
//    if (!([city hasSuffix:@"县"]||[city hasSuffix:@"区"]||[city hasSuffix:@"州"]||[city hasSuffix:@"市"])) {
//        city = [city stringByAppendingString:@"市"];
//    }
    
    //获取地区列表
    NSDictionary *listArr = [EZPublicList getCityDict];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in listArr) {
        NSDictionary *cityDict = [listArr objectForKey:key];
        int flag = 0;
        for (NSString *citykey in cityDict) {
            if ([citykey isEqual:city]) {
                array = cityDict[citykey];
                flag ++;
                break;
            }
        }
        if (flag!=0) {
            break;
        }
    }
    
    return array;
}
// 全国城市列表
+ (NSArray *)getCityList
{
//    //获取地区列表
//    NSDictionary *listArr = [EZPublicList getCityDict];
//    
//    NSMutableArray *array = [NSMutableArray array];
//    for (NSString *key in listArr) {
//        NSDictionary *cityDict = [listArr objectForKey:key];
//        [array addObjectsFromArray:cityDict.allKeys];
//    }
//    
//    return array;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"allcity" ofType:@"plist"];
    return [[NSArray alloc] initWithContentsOfFile:path];
}

#pragma mark - 我的

// 根据角色返回我的列表信息
+ (NSArray *)getPersonalListRole:(NSString *)role
{
    PersonItem *item0 = [PersonItem setCellItemImage:@"yaoqing" title:@"邀请好友"];
    item0.pushController = [SharedViewController class];
    PersonItem *item1 = [PersonItem setCellItemImage:@"bangzhu" title:@"帮助"];
    item1.pushController = [UserMangerController class];
    PersonItem *item2 = [PersonItem setCellItemImage:@"person_setting" title:@"设置"];
    item2.pushController = [SettingViewController class];
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:@[item0,item1,item2]];
    
    return mArr;
}

// 根据角色返回我的头部列表信息
+ (NSArray *)getPersonalHeadListRole:(NSString *)role
{
    NSArray *titleArray = @[@"面试记录",@"简历管理",@"投递记录",@"钱包",@"实名认证"];
    NSArray *classArray = @[[DeliveryJobController class],[ResumeManageController class],[DeliveryRecordController class],[WalletViewController class],[PersonalAuthController class]];
    NSArray *imageArray = @[@"person_icon3",@"person_icon2",@"person_icon5",@"person_icon4",@"person_icon7"];
    
    if ([role isEqualToString:@"2"]) {
        /// 企业
        titleArray = @[@"职位管理",@"人才直投",@"HR推荐",@"顾问订单",@"钱包"];
        classArray = @[[CPositionMangerController class],[CResumeDeliverController class],[CResumeRecommendController class],[RecommendOrderController class],[WalletViewController class]];
        imageArray = @[@"person_icon6",@"person_icon5",@"person_icon7",@"person_icon1",@"person_icon4"];
    }
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        PersonItem *item = [PersonItem setCellItemImage:imageArray[i] title:titleArray[i]];
        item.pushController = classArray[i];
        [mArr addObject:item];
    }
    
    return mArr;
}

/*  测试数据  */
+ (void)printPropertyWithDict:(NSDictionary *)dict
{
    NSMutableString *strM              = [NSMutableString string];
    NSMutableString *descriptionHeader = [NSMutableString stringWithFormat:@"[NSString stringWithFormat:%@\"",@"@"];
    NSMutableString *descriptionEnd    = [NSMutableString string];
    NSInteger count                    = [dict count];
    __block NSInteger index            = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                              id  _Nonnull obj,
                                              BOOL * _Nonnull stop) {
        //        NSLog(@"类型%@\n",[obj class]);
        NSString *str;
        NSString *Header;
        index ++;
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")] || [obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) int %@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSArray *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSDictionary *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%d"];
        }
        if ([obj isKindOfClass:(NSClassFromString(@"NSNull"))]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@  (null);",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        [descriptionEnd appendFormat:@"_%@,",key];
        [descriptionHeader appendFormat:@"%@",Header];
        [strM appendFormat:@"\n%@",str];
    }];
    if (count == index && count > 0) {
        [descriptionHeader replaceCharactersInRange:NSMakeRange(descriptionHeader.length - 3, 3) withString:@"\","];
        [descriptionEnd replaceCharactersInRange:NSMakeRange(descriptionEnd.length - 1, 1) withString:@"];"];
    }
    NSLog(@"\n\n*******模型所有属性，自己要改下(默认空的数据为字符串)*******%@",strM);
    //    NSLog(@"\n\n***************重写模型的描述粘贴复制这句***************\nreture %@%@",descriptionHeader,descriptionEnd);
    
}

@end
