//
//  CommonProblemVC.m
//  kuainiao
//
//  Created by yunjobs on 16/4/23.
//  Copyright © 2016年 yunjobs. All rights reserved.
//

#import "CommonProblemVC.h"
//#import "CustomLabel.h"

@interface CommonProblemVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    UITableView *myTable;
    NSArray *tableArr;
    
    NSIndexPath *selectIndex;
}

@end

@implementation CommonProblemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webTitle = @"常见问题";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/public/question.html",H5BaseURL]];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    self.navigationItem.title = @"常见问题";
//
//    //读取plist文件中的内容
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CommonProblem" ofType:@"plist"];
//    NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];
//
//    tableArr = data;
//
//    [self initView];
}

- (void)initView
{
    
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.backgroundColor = RGB(243, 243, 243);
    myTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 10)];
    myTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:myTable];
    
    if (IOS_VERSION_11_OR_ABOVE) {
        myTable.estimatedRowHeight = 0;
        myTable.estimatedSectionHeaderHeight = 0;
        myTable.estimatedSectionFooterHeight = 0;
    }
    
    //去除表格线在左端留有的空白（在viewDidLoad中添加）
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)])
    {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)])
    {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - table

//去除表格线在左端留有的空白（tableView的代理方法）
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((selectIndex != nil && selectIndex.row == indexPath.row)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell0"];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, APP_WIDTH-30, 45)];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.tag = 1;
            label.numberOfLines = 0;
            label.adjustsFontSizeToFitWidth = YES;
            [cell addSubview:label];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(label.yq_x, label.yq_bottom, label.yq_width, 0.5)];
            line.backgroundColor = RGB(180, 180, 180);
            [cell addSubview:line];
            
            UILabel *labela = [[UILabel alloc] initWithFrame:CGRectMake(15, label.yq_bottom+3, APP_WIDTH-30, 45)];
            //[labela setVerticalAlignment:VerticalAlignmentTop];
            labela.font = [UIFont systemFontOfSize:14];
            labela.textColor = RGB(51, 51, 51);
            labela.numberOfLines = 0;
            labela.tag = 2;
            labela.adjustsFontSizeToFitWidth = YES;
            //labela.backgroundColor = RandomColor;
            [cell addSubview:labela];
        }
        NSDictionary *dic = [tableArr objectAtIndex:indexPath.row];
        ((UILabel *)[cell viewWithTag:1]).text = dic[@"title"];
        ((UILabel *)[cell viewWithTag:2]).text = dic[@"content"];
        UILabel *label = ((UILabel *)[cell viewWithTag:2]);
        CGRect frame = label.frame;
        frame.size.height = [self yq_textHeight:dic[@"content"] size:CGSizeMake(APP_WIDTH-30, MAXFLOAT) font:14].height;
        label.frame = frame;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_"];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, APP_WIDTH-30, 45)];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.tag = 1;
            [cell addSubview:label];
        }
        NSDictionary *dic = [tableArr objectAtIndex:indexPath.row];
        ((UILabel *)[cell viewWithTag:1]).text = dic[@"title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if ((selectIndex != nil && selectIndex.row == indexPath.row)) {
        NSDictionary *dic = [tableArr objectAtIndex:indexPath.row];
        height = [self yq_textHeight:dic[@"content"] size:CGSizeMake(APP_WIDTH-30, MAXFLOAT) font:14].height;
        height = height <= 45 ? 45+45 : height+45+12;
    }
    else{
        height = 45;
    }
    return height;
}

- (CGSize)yq_textHeight:(NSString *)text size:(CGSize)size font:(NSInteger)font
{
    CGSize stringSize = CGSizeZero;
    if (text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringSize =[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                     context:nil].size;
#else
        
        stringSize = [text sizeWithFont:[UIFont systemFontOfSize:font]
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByCharWrapping];
#endif
    }
    return stringSize;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!selectIndex) {
        selectIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        BOOL isSelect = selectIndex.row == indexPath.row ? YES : NO;
        
        //两次点击不同的cell
        if (!isSelect){
            //收起上次点击展开的cell;
            NSIndexPath *tempIndexPath = [selectIndex copy];
            selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tempIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
            //展开新选择的cell;
            //            isSelectRow = true;
            selectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else{
            //若点击相同的cell，收起cell
            //            isSelectRow = false;
            selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
