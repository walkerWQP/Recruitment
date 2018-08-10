//
//  YQSingleTableView.m
//  CustomTable
//
//  Created by yunjobs on 2017/10/25.
//  Copyright © 2017年 com.mobile.hn3l. All rights reserved.
//

#import "YQDDSingleTableView.h"
#import "YQDowndropItem.h"

static NSString *CellIdentifier = @"singleCell";

@interface YQDDSingleTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger footViewH;
    NSIndexPath *previousIndexPath;
}
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation YQDDSingleTableView

- (instancetype)initWithFrame:(CGRect)frame downdropItem:(YQDowndropItem *)subItem
{
    if (self = [super initWithFrame:frame]) {
        _tableArray = subItem.singleListArray;
        
        if (subItem.footView) {
//            CGRect aframe = subItem.footView.frame;
//            aframe.origin.y = frame.size.height-aframe.size.height;
//            subItem.footView.frame = aframe;
            
            [self addSubConstraint:subItem.footView toView:self];
            
            footViewH = subItem.footView.frame.size.height;
            UIButton *button = (UIButton *)subItem.footView;
            [button addTarget:self action:@selector(footViewClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        //self.backgroundColor = [UIColor redColor];
        self.layer.masksToBounds = YES;
        [self initTableView:frame];
    }
    return self;
}

- (void)initTableView:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-footViewH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [self addSubview:tableView];
    self.tableview = tableView;
    if (IOS_VERSION_11_OR_ABOVE) {
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YQDDSingleTableView cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = RGB(239, 239, 239);
    YQSingleTableViewItem *item = [_tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.text;
    cell.textLabel.textColor = item.isSelect ? THEMECOLOR : [UIColor blackColor];
    
    if (indexPath.row == 0 && previousIndexPath == nil) {
        previousIndexPath = indexPath;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 选择相同的单元格回调indexPath = nil
    if (previousIndexPath.row != indexPath.row) {
        if (self.selectIndexPath) {
            YQSingleTableViewItem *item = [_tableArray objectAtIndex:indexPath.row];
            for (YQSingleTableViewItem *singleItem in _tableArray) {
                singleItem.isSelect = singleItem == item;
            }
            
            [self.tableview reloadData];
            
            self.selectIndexPath(self,indexPath);
        }
    }else{
        if (self.selectIndexPath) {
            self.selectIndexPath(self,nil);
        }
    }
    previousIndexPath = indexPath;
}

- (void)footViewClick:(UIButton *)sender
{
    if (self.FootViewBlock) {
        self.FootViewBlock(self);
    }
}

- (void)addSubConstraint:(UIView *)view toView:(UIView *)cell
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [cell addSubview:view];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
}


#pragma mark - public

- (void)refreshTable:(YQDowndropItem *)item
{
    _tableArray = item.singleListArray;
    
    CGFloat cellH = _tableArray.count * 50;
    CGFloat max = APP_HEIGHT-45-APP_NAVH-80;
    if (item.footView) {
        max -= item.footView.yq_height;
    }
    NSInteger h = cellH > max ? max : cellH;
    self.tableview.yq_height = h;
    
    previousIndexPath = nil;
    [self.tableview reloadData];
}

+ (NSInteger)cellHeight
{
    return 50;
}

@end
