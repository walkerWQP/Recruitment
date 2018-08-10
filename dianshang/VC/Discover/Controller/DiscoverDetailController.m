//
//  DiscoverDetailController.m
//  dianshang
//
//  Created by yunjobs on 2017/11/16.
//  Copyright © 2017年 yunjobs. All rights reserved.
//

#import "DiscoverDetailController.h"

#import "YQDiscoverFrame.h"
#import "YQDiscover.h"
#import "YQDiscoverComment.h"

#import "YQToolBarButton.h"
#import "YQDiscoverCell.h"
#import "YQDiscoverDetailCell.h"

#import "UITextView+ZWPlaceHolder.h"
#import "YQViewController+YQShareMethod.h"

@interface DiscoverDetailController ()<UITextViewDelegate>
// 分享方法名
@property (nonatomic, strong) NSArray *shareSelectorNameArray;

@property (nonatomic, strong) NSMutableArray *commentList;

@property (nonatomic, strong) UIView *commentSuperView;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIButton *fabuBtn;

@property (nonatomic, strong) UIButton *praiseBtn;// 点赞按钮
@property (nonatomic, strong) UIButton *shareBtn;// 分享按钮

@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation DiscoverDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"职场详情";
    
    self.commentList = [NSMutableArray array];
    
#pragma mark ========增加监听，当键盘出现或改变时收出消息========
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
#pragma mark ========增加监听，当键退出时收出消息========
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self setUpData];
    [self initView];
    
    [self initBottomView];
    [self initCommentView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isComment) {
        [self.commentTextView becomeFirstResponder];
    }
}

- (void)initView
{
    UINib *nib1 = [UINib nibWithNibName:@"YQDiscoverDetailCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"YQDiscoverDetailCell"];
    self.tableView.yq_height -= (50+APP_BottomH);
    [self.view addSubview:self.tableView];
    
    YQWeakSelf;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isPullDown = NO;
        [weakSelf footerRereshing];
    }];
    
    [self.tableView.mj_footer beginRefreshing];
}
- (void)footerRereshing
{
    self.pageIndex ++;
    [self reqTopicDetail:[NSString stringWithFormat:@"%li",self.pageIndex]];
}
- (void)initBottomView
{
    NSArray *array = @[@"discover_unpraise",@"discover_share"];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT-APP_NAVH-(50+APP_BottomH), APP_WIDTH, 50+APP_BottomH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.yq_width, 0.5)];
    lineView.backgroundColor = RGB(180, 180, 180);
    [bottomView addSubview:lineView];
    
    CGFloat oneW = bottomView.yq_width-125;
    CGFloat onex = 15;
    CGFloat left = oneW+onex+10;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(onex, 0, oneW, 50)];
    [button setImage:[UIImage imageNamed:@"yijian"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"我来说几句" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [bottomView addSubview:button];
    
    CGFloat w = 40;
    CGFloat h = 40;
    CGFloat y = 5;
    
    for (int i = 0; i < array.count; i++) {
        
        YQToolBarButton *button = [[YQToolBarButton alloc] initWithFrame:CGRectMake(left+i*w+10*i, y, w, h)];
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [bottomView addSubview:button];
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        //button.backgroundColor = RandomColor;
        button.titleLabel.backgroundColor = bottomView.backgroundColor;
        button.tag = i+1;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 10;
        if (i == 0) {
            if (self.discover.attitudes_count>0) {
                NSString *str = [NSString stringWithFormat:@"%d",self.discover.attitudes_count];
                [button setTitle:str forState:UIControlStateNormal];
            }
            button.selected = self.discover.isPraise;
            self.praiseBtn = button;
            [button setImage:[UIImage imageNamed:@"discover_praise"] forState:UIControlStateSelected];
        }else{
            if (self.discover.reposts_count>0) {
                NSString *str = [NSString stringWithFormat:@"%d",self.discover.reposts_count];
                [button setTitle:str forState:UIControlStateNormal];
            }
            self.shareBtn = button;
        }
    }
    [self.view addSubview:bottomView];
}
- (void)initCommentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    view.backgroundColor = RGBA(0, 0, 0, 0);
    view.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyBoardClick:)];
    [view addGestureRecognizer:tap];
    self.commentSuperView = view;
    //加载到windows上
    [[UIApplication sharedApplication].keyWindow addSubview:self.commentSuperView];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT, APP_WIDTH, 100)];
    commentView.backgroundColor = [UIColor whiteColor];
    [view addSubview:commentView];
    self.commentView = commentView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, commentView.yq_width, 0.5)];
    lineView.backgroundColor = RGB(180, 180, 180);
    [commentView addSubview:lineView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 8, commentView.yq_width - 70, commentView.yq_height-8*2)];
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = RGB(243, 243, 243);
    [commentView addSubview:bgView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 0, bgView.yq_width - 16, bgView.yq_height)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:16];
    textView.placeholder = @"我来说几句";
    [bgView addSubview:textView];
    self.commentTextView = textView;
    
    //textView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    //textView.contentSize = CGSizeMake(textView.yq_width-20, MAXFLOAT);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(bgView.yq_right+10, commentView.yq_height-50, 50, 50)];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitleColor:RGB(180, 180, 180) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(fabuClick:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:button];
    self.fabuBtn = button;
}

- (void)setUpData
{
    YQDiscoverFrame *discoverframe = [[YQDiscoverFrame alloc] init];
    self.discover.isOpen = YES;
    discoverframe.status = self.discover;
    self.discover.isOpen = NO;
    
    YQGroupCellItem *item = [YQGroupCellItem setGroupItems:[NSMutableArray arrayWithObject:discoverframe] headerTitle:nil footerTitle:nil];
    [self.groups addObject:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YQGroupCellItem *item = self.groups[indexPath.section];
        YQDiscoverFrame *frame = item.items[indexPath.row];
        int h = frame.cellHeight-frame.toolbarF.size.height-frame.commentListF.size.height;
        if (frame.contentLabelF.size.height > YQStatusTextMaxH) {
            h -= frame.openButtonF.size.height;
        }
        return h;
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YQGroupCellItem *item = self.groups[indexPath.section];
        //获得cell
        YQDiscoverCell *cell = [YQDiscoverCell cellWithTableView:tableView];
        cell.isToolbar = NO;
        //给cell传递模型数据
        YQDiscoverFrame *frame = item.items[indexPath.row];
        cell.statusFrame = frame;
        
        return cell;
    }
    
    YQDiscoverComment *comment = self.commentList[indexPath.row];
    YQDiscoverDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YQDiscoverDetailCell"];
    cell.entity = comment;
    YQWeakSelf;
    cell.praiseBtnBlock = ^(NSIndexPath *path) {
        [weakSelf commentPraise:path];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        [self.fabuBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    }else{
        [self.fabuBtn setTitleColor:RGB(180, 180, 180) forState:UIControlStateNormal];
    }
}

#pragma mark -

- (void)commentPraise:(NSIndexPath *)path
{
    YQDiscoverComment *comment = self.commentList[path.row];
    NSString *tid = self.discover.idstr;
    
    [[RequestManager sharedRequestManager] discoverCommentPraise_uid:[UserEntity getUid] tid:tid cid:comment.uid success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            //BOOL isPraise = [comment.tc_praise isEqualToString:@"1"];
            if (comment.isPraise) {
                comment.hot_count -= 1;
                comment.isPraise = NO;
            }else{
                comment.hot_count += 1;
                comment.isPraise = YES;
            }
            //entity.status = en;
            [self.commentList replaceObjectAtIndex:path.row withObject:comment];
            
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)bottomButtonClick:(UIButton *)sender
{
    if (sender.tag == 0) {
        // 评论
        [self.commentTextView becomeFirstResponder];
    }else if (sender.tag == 1){
        // 点赞
        [self reqPraiseTopic:nil];
    }else if (sender.tag == 2){
        // 分享
        [self shareView];
    }
}

- (void)fabuClick:(UIButton *)sender
{
    NSString *desc = self.commentTextView.text;
    if ([desc isEqualToString:@""]) {
        [YQToast yq_ToastText:@"说点什么吧" bottomOffset:100];
    }else{
        // 评论
        [[RequestManager sharedRequestManager] discoverCommentTopic_uid:[UserEntity getUid] tid:self.discover.idstr desc:desc success:^(id resultDic) {
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                [self.commentTextView resignFirstResponder];
                
                YQDiscoverComment *comment = [[YQDiscoverComment alloc] init];
                comment.name = [UserEntity getNickName];
                comment.commentText = desc;
                comment.avatar = [UserEntity getHeadImgUrl];
                [self.commentList addObject:comment];
                
                [self.tableView reloadData];
                CGFloat offset = self.tableView.contentSize.height-self.tableView.yq_height;
                if (offset > 0) {
                    [self.tableView setContentOffset:CGPointMake(0, offset)];
                }
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}

- (void)tapHideKeyBoardClick:(UIGestureRecognizer *)sender
{
    //[self.fabuBtn setTitleColor:RGB(180, 180, 180) forState:UIControlStateNormal];
    [self.commentTextView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.commentSuperView.userInteractionEnabled = YES;
#pragma mark ========获取键盘的高度========
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    self.commentView.yq_bottom = APP_HEIGHT - height;
}

#pragma mark ========当键退出时调用========
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.commentView.yq_y = APP_HEIGHT;
    self.commentSuperView.userInteractionEnabled = NO;
}

#pragma mark - 网络访问
#pragma mark ========点赞========
- (void)reqPraiseTopic:(NSIndexPath *)indexPath
{
    [[RequestManager sharedRequestManager] discoverPraiseTopic_uid:[UserEntity getUid] tid:self.discover.idstr success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            YQDiscover *en = self.discover;
            if (en.isPraise) {
                en.attitudes_count -= 1;
                en.isPraise = NO;
            }else{
                en.attitudes_count += 1;
                en.isPraise = YES;
            }
            
            if (en.attitudes_count > 0) {
                NSString *str = [NSString stringWithFormat:@"%d",en.attitudes_count];
                [self.praiseBtn setTitle:str forState:UIControlStateNormal];
            }else{
                [self.praiseBtn setTitle:@"" forState:UIControlStateNormal];
            }
            self.praiseBtn.selected = en.isPraise;
            
            if (self.opeationSuccessBlock) {
                self.opeationSuccessBlock(nil);
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)reqTopicDetail:(NSString *)page
{
    NSString *tid = self.discover.idstr;
    
    [[RequestManager sharedRequestManager] discoverTopicDetail_uid:[UserEntity getUid] tid:tid page:page pagesize:KPageSize success:^(id resultDic) {
        [self.tableView.mj_footer endRefreshing];
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            NSArray *list = resultDic[DATA][@"detail"];
            if (list.count != 0) {
                for (NSDictionary *dict in list) {
                    YQDiscoverComment *comment = [YQDiscoverComment DiscoverCommentWithDict:dict];
                    [self.commentList addObject:comment];
                }
                NSInteger count_comment = [resultDic[DATA][@"count_comment"] integerValue];
                if (self.commentList.count == count_comment) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                if (self.commentList.count > 0) {
                    if (self.groups.count != 2) {
                        YQGroupCellItem *item1 = [YQGroupCellItem setGroupItems:self.commentList headerTitle:@"   热门评论" footerTitle:nil];
                        [self.groups addObject:item1];
                    }else{
                        YQGroupCellItem *item1 = [self.groups objectAtIndex:1];
                        item1.items = self.commentList;
                    }
                    [self.tableView reloadData];
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

#pragma mark ========将要执行分享的时候调用========
- (void)shreViewWillAppear
{
    // 调用分享话题接口(分享次数+1 无论分享是否成功都+1)
    NSLog(@"1     %@",self.discover.idstr);
    [[RequestManager sharedRequestManager] discoverShareTopic_uid:@"" tid:self.discover.idstr success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            YQDiscover *en = self.discover;
            if (en.isPraise) {
                en.reposts_count -= 1;
            }else{
                en.reposts_count += 1;
            }
            
            if (en.reposts_count > 0) {
                NSString *str = [NSString stringWithFormat:@"%d",en.reposts_count];
                [self.shareBtn setTitle:str forState:UIControlStateNormal];
            }else{
                [self.shareBtn setTitle:@"" forState:UIControlStateNormal];
            }
            
            if (self.opeationSuccessBlock) {
                self.opeationSuccessBlock(nil);
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
    
}

#pragma mark ========设置分享参数========
- (NSMutableDictionary *)getShateParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 通用参数设置
    NSLog(@"3    %@",self.discover.text);
    [parameters SSDKSetupShareParamsByText:self.discover.text
                                    images:nil
                                       url:nil
                                     title:nil
                                      type:SSDKContentTypeText];
    return parameters;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
