//
//  YQDowndropItem.h
//  CustomTable
//
//  Created by yunjobs on 2017/10/24.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

typedef enum {
    YQDowndropItemTypeSingleTableView  = 0,     //单个表
    YQDowndropItemTypeDoubleTableView,          //未实现 双表
    YQDowndropItemTypeCollectionView,           //集合表
    YQDowndropItemTypeCustomView                //未实现 自定义
    
} YQDowndropItemType;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YQDoubleTableViewItem;
@class YQSingleTableViewItem;
@class YQDDCollectionItem;
@class YQHeadViewItem;

@interface YQDowndropItem : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) YQDowndropItemType type;

@property (nonatomic, strong) YQHeadViewItem *headItem;

@property (nonatomic, strong) UIView *bodyView;

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) UIView *footView;

@property (nonatomic, strong) NSMutableArray<YQSingleTableViewItem *> *singleListArray;

@property (nonatomic, strong) NSMutableArray<YQDoubleTableViewItem *> *doubleListArray;

@property (nonatomic, strong) NSMutableArray<YQDDCollectionItem *> *collectionArray;

@end

@interface YQHeadViewItem : NSObject

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIButton *titleView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) YQDowndropItemType type;

@end

@interface YQSingleTableViewItem : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface YQDoubleTableViewItem : NSObject

@property (nonatomic, strong) NSString *oneTableText;

@property (nonatomic, strong) NSMutableArray<YQSingleTableViewItem *> *twoTableList;

@end

@interface YQDDCollectionItem : NSObject

// 是否多选
@property (nonatomic, assign) BOOL isMultiselect;

@property (nonatomic, strong) NSString *collectionText;

@property (nonatomic, strong) NSMutableArray<YQSingleTableViewItem *> *collectionList;

@end
