//
//  YQTableViewCell.m
//  kuainiao
//
//  Created by yunjobs on 16/8/22.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "YQTableViewCell.h"

#import "PersonItem.h"
#import "YQSettingSwitchItem.h"
//#import "YQBuySmsCellItem.h"

@interface YQTableViewCell ()

@property (nonatomic, assign) YQTableViewCellStyle YQCellStyle;

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIButton *cellRightBtn;

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation YQTableViewCell

- (UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bgImageView.backgroundColor = [UIColor whiteColor];
        _bgImageView.layer.cornerRadius = 8;
        _bgImageView.image = [UIImage imageNamed:@""];
    }
    return _bgImageView;
}

- (UIButton *)cellRightBtn
{
    if (_cellRightBtn == nil) {
        _cellRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_cellRightBtn setImage:[UIImage imageNamed:@"select_circle"] forState:UIControlStateSelected];
        [_cellRightBtn setImage:[UIImage imageNamed:@"unselect_circle"] forState:UIControlStateNormal];
        _cellRightBtn.userInteractionEnabled = NO;
    }
    return _cellRightBtn;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        YQSettingSwitchItem *switchItem =(YQSettingSwitchItem *) _item;
        _switchView.on = switchItem.isOn;
        [_switchView addTarget:self action:@selector(switchViewChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView tableViewCellStyle:(YQTableViewCellStyle)tableViewCellStyle
{
    static NSString *ID = @"cell";
    YQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        UITableViewCellStyle style = UITableViewCellStyleDefault;
        switch (tableViewCellStyle) {
            case YQTableViewCellStyleDefault:
                style = UITableViewCellStyleDefault;
                break;
            case YQTableViewCellStyleValue1:
                style = UITableViewCellStyleValue1;
                break;
            case YQTableViewCellStyleValue2:
                style = UITableViewCellStyleValue2;
                break;
            case YQTableViewCellStyleValue3:
                style = UITableViewCellStyleValue1;
                break;
            case YQTableViewCellStyleBgImage:
                style = UITableViewCellStyleValue1;
                break;
            case YQTableViewCellStyleSubtitle:
                style = UITableViewCellStyleSubtitle;
                break;
            default:
                break;
        }
        cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];
        cell.YQCellStyle = tableViewCellStyle;
        if (cell.YQCellStyle == YQTableViewCellStyleBgImage) {
            [cell.contentView addSubview:cell.bgImageView];
        }
    }
    
    return cell;
}

- (void)setItem:(YQCellItem *)item
{
    _item = item;
    
    [self setUpData];
    
    [self setRightBtn];
}

// 设置数据
- (void)setUpData
{
    if (_item.image) {
        self.imageView.image = [UIImage imageNamed:_item.image];
    }
    if (_item.title) {
        self.textLabel.text = _item.title;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = RGB(51, 51, 51);
    }else{
        self.textLabel.text = @"";
    }
    if (_item.subTitle) {
        self.detailTextLabel.text = _item.subTitle;
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.textColor = RGB(102, 102, 102);
    }else{
        self.detailTextLabel.text = @"";
    }
}

- (void)setRightBtn
{
    if ([_item isKindOfClass:[PersonItem class]]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([_item isKindOfClass:[YQSettingSwitchItem class]]){
        self.accessoryView = self.switchView;
    }
//    else if ([_item isKindOfClass:[YQBuySmsCellItem class]]){
//        self.accessoryView = self.cellRightBtn;
//        _cellRightBtn.selected =((YQBuySmsCellItem *)_item).isSelect;
//    }else{
//        self.accessoryView = nil;
//        self.accessoryType = UITableViewCellAccessoryNone;
//    }
}

- (void)switchViewChange:(UISwitch *)sender
{
    NSIndexPath *path = [self indexPathWithView:sender];
    if (path != nil) {
        if (self.switchChange) {
            self.switchChange(path);
        }
    }
}

- (void)switchChange:(void (^)(NSIndexPath *))block
{
    if (block) {
        self.switchChange = block;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.YQCellStyle == YQTableViewCellStyleValue3) {
        CGFloat jianju = self.textLabel.frame.origin.x;
        CGFloat w = self.frame.size.width - self.textLabel.frame.size.width - jianju*3;
        CGFloat x = self.textLabel.frame.size.width + jianju*2;
        CGFloat y = self.detailTextLabel.frame.origin.y;
        CGFloat h = self.detailTextLabel.frame.size.height;
        self.detailTextLabel.frame = CGRectMake(x, y, w, h);
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    }else if (self.YQCellStyle == YQTableViewCellStyleBgImage){
        CGFloat jianju = 8;
        CGFloat w = self.frame.size.width - jianju*2;
        CGFloat x = jianju;
        CGFloat y = jianju;
        CGFloat h = self.frame.size.height - jianju*2;
        self.bgImageView.frame = CGRectMake(x, y, w, h);
    }
}

@end
