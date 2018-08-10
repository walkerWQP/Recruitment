//
//  RMAddEditResume.m
//  dianshang
//
//  Created by yunjobs on 2017/11/9.
//  Copyright © 2017年 yunjobs. All rights reserved.
//
#define zishu 2000

#import "RMAddEditResume.h"

#import "ResumeManageEntity.h"

#import "YQBrithDayView.h"
#import "KNActionSheet.h"

#import "NSString+MyDate.h"
#import "UITextField+YQTextField.h"
#import "UITextView+ZWPlaceHolder.h"

@interface RMAddEditResume ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    UIScrollView *scroller;
}
// 描述字数
@property (nonatomic, strong) UILabel *wordNumLbl;
// 公司名/项目名/学校名
@property (nonatomic, strong) UITextField *oneTextField;
// 部门/项目职责/专业
@property (nonatomic, strong) UITextField *twoTextField;
// 职位/项目业绩/学历
@property (nonatomic, strong) UITextField *threeTextField;
// 开始时间段
@property (nonatomic, strong) UITextField *startTextField;
// 结束时间段
@property (nonatomic, strong) UITextField *endTextField;
// 工作内容/项目描述/在校经历
@property (nonatomic, strong) UITextView *textView;

// 开始
@property (nonatomic, strong) YQBrithDayView *startView;
// 结束
@property (nonatomic, strong) YQBrithDayView *endView;

@property (nonatomic, strong) NSArray *eduArray;

@end

@implementation RMAddEditResume

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[EZPublicList getEducationList]];
    [array removeObjectAtIndex:0];
    self.eduArray = array;
    
    if (self.type == RMSectionTypeWorking) {
        self.navigationItem.title = @"添加工作经历";
    }else if (self.type == RMSectionTypeExperience){
        self.navigationItem.title = @"添加项目经验";
    }else if (self.type == RMSectionTypeEducational){
        self.navigationItem.title = @"添加教育经历";
    }
    [self initView];
    
    if (self.editEntity != nil) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"保存" titleColor:[UIColor whiteColor] target:self action:@selector(saveClick:)];
        
        // 设置默认数据
        [self setUpdata];
        
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithtitle:@"确认添加" titleColor:[UIColor whiteColor] target:self action:@selector(addClick:)];
    }
}

- (void)setUpdata
{
    if (self.type == RMSectionTypeWorking) {
        NSString *start = [NSString timeStampToString:self.editEntity.entrytime formatter:YYYYMMdd];
        NSString *end = [NSString timeStampToString:self.editEntity.leavetime formatter:YYYYMMdd];
        if ([self.editEntity.leavetime isEqualToString:@"943891200"]) {
            end = @"至今";
        }
        self.oneTextField.text = self.editEntity.companyname;
        self.twoTextField.text = self.editEntity.position;
        self.startTextField.text = start;
        self.endTextField.text = end;
        self.textView.text = self.editEntity.content;
        self.wordNumLbl.text = [NSString stringWithFormat:@"%ld/%d",self.textView.text.length,zishu];
    }else if (self.type == RMSectionTypeExperience){
        NSString *start = [NSString timeStampToString:self.editEntity.starttime formatter:YYYYMMdd];
        NSString *end = [NSString timeStampToString:self.editEntity.endtime formatter:YYYYMMdd];
        if ([self.editEntity.endtime isEqualToString:@"943891200"]) {
            end = @"至今";
        }
        self.oneTextField.text = self.editEntity.pname;
        self.twoTextField.text = self.editEntity.duty;
        self.startTextField.text = start;
        self.endTextField.text = end;
        self.textView.text = self.editEntity.describetion;
        self.wordNumLbl.text = [NSString stringWithFormat:@"%ld/%d",self.textView.text.length,zishu];
    }else if (self.type == RMSectionTypeEducational){
        NSString *start = [NSString timeStampToString:self.editEntity.entrancetime formatter:YYYYMMdd];
        NSString *end = [NSString timeStampToString:self.editEntity.graduate formatter:YYYYMMdd];
        if ([self.editEntity.graduate isEqualToString:@"943891200"]) {
            end = @"至今";
        }
        self.oneTextField.text = self.editEntity.schoolname;
        self.twoTextField.text = self.editEntity.major;
        self.threeTextField.text = self.editEntity.edu;
        self.startTextField.text = start;
        self.endTextField.text = end;
        self.textView.text = self.editEntity.experience;
        self.wordNumLbl.text = [NSString stringWithFormat:@"%ld/%d",self.textView.text.length,zishu];
    }
}

- (void)initView
{
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT-APP_NAVH)];
    scroller.backgroundColor = RGB(239, 239, 239);
    scroller.delegate = self;
    [self.view addSubview:scroller];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerClick:)];
    [scroller addGestureRecognizer:tap];
    
    UIView *detailView0 = [self storeDetailView:nil];
    
    UIView *content = [self contentTextView:detailView0];
    
    if (self.editEntity) {
        
        UIView *buttonView = [self buttonView:content];
        
        [scroller setContentSize:CGSizeMake(APP_WIDTH, buttonView.yq_bottom+20)];
    }else{
        [scroller setContentSize:CGSizeMake(APP_WIDTH, content.yq_bottom+20)];
    }
    
}
- (UIView *)contentTextView:(UIView *)storePhotoView
{
    CGFloat w = scroller.yq_width;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, 230)];
    contentView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:contentView];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 45)];
    titlelabel.text = @"工作内容:";
    titlelabel.textColor = RGB(51, 51, 51);
    titlelabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:titlelabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, titlelabel.yq_bottom, contentView.yq_width-30, contentView.yq_height-titlelabel.yq_height-15)];
    textView.delegate = self;
    textView.backgroundColor = RGB(243, 243, 243);
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.cornerRadius = 5;
    textView.placeholder = @"1.主要负责新员工入职培训；\n2.分析制定员工每月个人销售业绩；\n3.帮助员工提高每日客单价，整体店面管理等工作。";
    [contentView addSubview:textView];
    _textView = textView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textView.yq_width-102, contentView.yq_height-20, 100, 20)];
    label.text = [NSString stringWithFormat:@"0/%d",zishu];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGB(102, 102, 102);
    label.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:label];
    self.wordNumLbl = label;
    
    if (self.type == RMSectionTypeExperience) {
        titlelabel.text = @"项目描述:";
        textView.placeholder = @"描述该项目，向HR展示您的项目经验\n\n例如：\n1.项目概况…\n2.人员分工…\n3.我的责任…";
    }else if (self.type == RMSectionTypeEducational){
        titlelabel.text = @"在校经历:";
        textView.placeholder = @"作为班级团支书主要负责团员、党员的学习工作，积极分子的发展评估，负责班级的团费、党费管理…";
    }
    
    
    
    return contentView;
}
- (UIView *)buttonView:(UIView *)storePhotoView
{
    CGFloat w = scroller.yq_width;
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, 95)];
    buttonView.backgroundColor = [UIColor clearColor];
    [scroller addSubview:buttonView];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, APP_WIDTH - 60, 45)];
    [saveBtn setTitle:@"删 除" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    saveBtn.layer.cornerRadius = 4;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setBackgroundColor:blueBtnNormal forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:blueBtnHighlighted forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:saveBtn];
    
    return buttonView;
}
- (UIView *)storeDetailView:(UIView *)storePhotoView
{
    NSArray *arr = @[@"公司名称",@"职位",@"入职时间",@"离职时间"];
    if (self.type == RMSectionTypeExperience) {
        arr = @[@"项目名称",@"项目职责",@"开始时间",@"结束时间"];
    }else if (self.type == RMSectionTypeEducational){
        arr = @[@"学校名称",@"专业",@"学历",@"入校时间",@"毕业时间"];
    }
    
    CGFloat w = scroller.yq_width;
    CGFloat h = 45;
    UIView *storeDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, storePhotoView.yq_bottom+8, w, h*arr.count)];
    storeDetailView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:storeDetailView];
    
    for (int i = 0; i < arr.count; i++) {
        
        CGFloat y = h * i;
        
        UITextField *textfield = [[UITextField alloc] init];
        textfield.frame = CGRectMake(0, y, w, h);
        textfield.textColor = RGB(51, 51, 51);
        textfield.font = [UIFont systemFontOfSize:14];
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.delegate = self;
        textfield.adjustsFontSizeToFitWidth = YES;
        [storeDetailView addSubview:textfield];
        
        if (self.type == RMSectionTypeEducational) {
            if (i == 0) {
                _oneTextField = textfield;
            }else if (i == 1) {
                _twoTextField = textfield;
            }else if (i == 2) {
                _threeTextField = textfield;
            }else if (i == 3) {
                _startTextField = textfield;
            }else if (i == 4) {
                _endTextField = textfield;
            }
        }else{
            if (i == 0) {
                _oneTextField = textfield;
            }else if (i == 1) {
                _twoTextField = textfield;
            }else if (i == 2) {
                _startTextField = textfield;
            }else if (i == 3) {
                _endTextField = textfield;
            }
        }
        
        
        if (i >= 2) {
            textfield.placeholder = [NSString stringWithFormat:@"请选择%@",arr[i]];
            [textfield yq_setTitle:[arr[i] stringByAppendingString:@":"] titleColor:RGB(51, 51, 51) rightImage:@"back_right"];
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.enabled = NO;
            
            UIButton *button = [[UIButton alloc] initWithFrame:textfield.frame];
            [storeDetailView addSubview:button];
            
            if (self.type == RMSectionTypeEducational) {
                if (i == 2){
                    // 选择学历
                    [button addTarget:self action:@selector(EduClick:) forControlEvents:UIControlEventTouchUpInside];
                }if (i == 3){
                    // 选择开始时间段
                    [button addTarget:self action:@selector(StartTimeClick:) forControlEvents:UIControlEventTouchUpInside];
                }else if (i == 4){
                    // 选择结束时间段
                    [button addTarget:self action:@selector(EndTimeClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }else{
                if (i == 2){
                    // 选择开始时间段
                    [button addTarget:self action:@selector(StartTimeClick:) forControlEvents:UIControlEventTouchUpInside];
                }else if (i == 3){
                    // 选择结束时间段
                    [button addTarget:self action:@selector(EndTimeClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        
        }else{
            textfield.placeholder = [NSString stringWithFormat:@"请输入%@",arr[i]];
            [textfield yq_setTitle:[arr[i] stringByAppendingString:@":"] titleColor:RGB(51, 51, 51)];
        }
        
        if (i != arr.count-1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, y+h-1, APP_WIDTH-20, 0.5)];
            lineView.backgroundColor = RGB(239, 239, 239);
            [storeDetailView addSubview:lineView];
        }
        
    }
    
    return storeDetailView;
}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [scroller setContentOffset:CGPointMake(0, 200) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>zishu) {
        NSMutableString *a = [NSMutableString stringWithString:textView.text];
        self.textView.text = [a substringToIndex:zishu];
    }
    self.wordNumLbl.text = [NSString stringWithFormat:@"%d/%d",(int)textView.text.length,zishu];
}

#pragma mark - 事件

- (void)EduClick:(UIButton *)sender
{
    [self hideKeyBoard];
    YQWeakSelf;
    KNActionSheet *actionsSheet = [[KNActionSheet alloc] initWithCancelTitle:nil destructiveTitle:nil otherTitleArr:self.eduArray actionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex != -1) {
            weakSelf.threeTextField.text = [weakSelf.eduArray objectAtIndex:buttonIndex];
        }
    }];
    [actionsSheet show];
}

- (void)StartTimeClick:(UIButton *)sender
{
    [self hideKeyBoard];
    
    self.startView = [[YQBrithDayView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH,APP_HEIGHT)];
    [self.startView showAnimate];
    
    YQWeakSelf;
    self.startView.dateBlock = ^(NSString *dateStr) {
        weakSelf.startTextField.text = dateStr;
    };
}
- (void)EndTimeClick:(UIButton *)sender
{
    [self hideKeyBoard];
    
    self.endView = [[YQBrithDayView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH,APP_HEIGHT) isSofor:YES];
    [self.endView showAnimate];
    
    YQWeakSelf;
    self.endView.dateBlock = ^(NSString *dateStr) {
        weakSelf.endTextField.text = dateStr;
    };
}

#pragma mark - 事件处理
- (void)deleteBtnClick:(UIButton *)sender
{
    if (self.type == RMSectionTypeWorking) {
        // 保存工作经历
        [self deleteWork];
    }else if (self.type == RMSectionTypeExperience){
        // 保存工作经历
        [self deleteProject];
    }else if (self.type == RMSectionTypeEducational){
        // 保存教育经历
        [self deleteEdu];
    }
}

- (void)saveClick:(UIButton *)sender
{
    if (self.type == RMSectionTypeWorking) {
        // 保存工作经历
        [self addwork:self.editEntity.itemId];
    }else if (self.type == RMSectionTypeExperience){
        // 保存工作经历
        [self addproject:self.editEntity.itemId];
    }else if (self.type == RMSectionTypeEducational){
        // 保存教育经历
        [self addedu:self.editEntity.itemId];
    }
}
- (void)addClick:(UIButton *)sender
{
    if (self.type == RMSectionTypeWorking) {
        // 添加工作经历
        [self addwork:@""];
    }else if (self.type == RMSectionTypeExperience){
        // 添加项目经验
        [self addproject:@""];
    }else if (self.type == RMSectionTypeEducational){
        // 添加教育经历
        [self addedu:@""];
    }
}

- (void)deleteWork
{
    [[RequestManager sharedRequestManager] deleteWork_uid:self.editEntity.itemId success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"删除成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addEditBlock) {
                self.addEditBlock(NO,nil);
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)deleteEdu
{
    [[RequestManager sharedRequestManager] deleteEdu_uid:self.editEntity.itemId success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"删除成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addEditBlock) {
                self.addEditBlock(NO,nil);
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}

- (void)deleteProject
{
    [[RequestManager sharedRequestManager] deleteProject_uid:self.editEntity.itemId success:^(id resultDic) {
        if ([resultDic[CODE] isEqualToString:SUCCESS]) {
            [YQToast yq_ToastText:@"删除成功" bottomOffset:100];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.addEditBlock) {
                self.addEditBlock(NO,nil);
            }
        }
    } failure:^(NSError *error) {
        [self.hud hide:YES];
        NSLog(@"网络连接错误");
    }];
}
// 添加/保存项目经验
- (void)addproject:(NSString *)projectId
{
    NSString *pname = self.oneTextField.text;
    NSString *duty = self.twoTextField.text;
    NSString *starttime = self.startTextField.text;
    NSString *endtime = self.endTextField.text;
    NSString *describetion = self.textView.text;
    
    if ([endtime isEqualToString:@"至今"]) {
        endtime = @"00-00-00";
    }
    
    NSString *msg = @"";
    if ([pname isEqualToString:@""]) {
        msg = @"请输入项目名称";
    }else if ([duty isEqualToString:@""]){
        msg = @"请输入项目职责";
    }else if ([starttime isEqualToString:@""]){
        msg = @"请选择开始时间";
    }else if ([endtime isEqualToString:@""]){
        msg = @"请选择结束时间";
    }else if ([describetion isEqualToString:@""]){
        msg = @"请输入项目描述";
    }
    if (msg.length > 0) {
        [YQToast yq_ToastText:msg bottomOffset:100];
    }else{
        [[RequestManager sharedRequestManager] addProject_uid:[UserEntity getUid] projectId:projectId pname:pname duty:duty starttime:starttime endtime:endtime describetion:describetion success:^(id resultDic) {
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                
                [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.addEditBlock) {
                    ResumeManageSubEntity *en = [[ResumeManageSubEntity alloc] init];
                    en.pname = pname;
                    en.duty = duty;
                    en.describetion = describetion;
                    en.starttime = [NSString stringToTimeStamp:starttime formatter:YYYYMMdd];
                    if ([endtime isEqualToString:@"00-00-00"]) {
                        en.endtime = @"943891200";
                    }else{
                        en.endtime = [NSString stringToTimeStamp:endtime formatter:YYYYMMdd];
                    }
                    self.addEditBlock(YES,en);
                }
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}
// 添加/保存工作经历
- (void)addwork:(NSString *)workId
{
    NSString *companyname = self.oneTextField.text;
    NSString *position = self.twoTextField.text;
    NSString *entrytime = self.startTextField.text;
    NSString *leavetime = self.endTextField.text;
    NSString *content = self.textView.text;
    
    if ([leavetime isEqualToString:@"至今"]) {
        leavetime = @"00-00-00";
    }
    
    NSString *msg = @"";
    if ([companyname isEqualToString:@""]) {
        msg = @"请输入公司名称";
    }else if ([position isEqualToString:@""]){
        msg = @"请输入职位";
    }else if ([entrytime isEqualToString:@""]){
        msg = @"请选择入职日期";
    }else if ([leavetime isEqualToString:@""]){
        msg = @"请选择离职日期";
    }else if ([content isEqualToString:@""]){
        msg = @"请输入工作内容";
    }
    if (msg.length > 0) {
        [YQToast yq_ToastText:msg bottomOffset:100];
    }else{
        [[RequestManager sharedRequestManager] addWork_uid:[UserEntity getUid] workId:workId companyname:companyname position:position entrytime:entrytime leavetime:leavetime content:content success:^(id resultDic) {
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                
                [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.addEditBlock) {
                    ResumeManageSubEntity *en = [[ResumeManageSubEntity alloc] init];
                    en.companyname = companyname;
                    en.position = position;
                    en.content = content;
                    en.entrytime = [NSString stringToTimeStamp:entrytime formatter:YYYYMMdd];
                    if ([leavetime isEqualToString:@"00-00-00"]) {
                        en.leavetime = @"943891200";
                    }else{
                        en.leavetime = [NSString stringToTimeStamp:leavetime formatter:YYYYMMdd];
                    }
                    self.addEditBlock(YES,en);
                }
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}
// 添加/保存教育经历
- (void)addedu:(NSString *)eduId
{
    NSString *schoolname = self.oneTextField.text;
    NSString *major = self.twoTextField.text;
    NSInteger str = [self.eduArray indexOfObject:self.threeTextField.text] + 1;
    NSString *edu = [NSString stringWithFormat:@"%li",str];
    NSString *entrancetime = self.startTextField.text;
    NSString *graduate = self.endTextField.text;
    NSString *experience = self.textView.text;
    
    if ([graduate isEqualToString:@"至今"]) {
        graduate = @"00-00-00";
    }
    
    NSString *msg = @"";
    if ([schoolname isEqualToString:@""]) {
        msg = @"请输入学校名称";
    }else if ([major isEqualToString:@""]){
        msg = @"请输入专业";
    }else if ([edu isEqualToString:@""]){
        msg = @"请选择学历";
    }else if ([entrancetime isEqualToString:@""]){
        msg = @"请选择入校日期";
    }else if ([graduate isEqualToString:@""]){
        msg = @"请选择毕业日期";
    }else if ([experience isEqualToString:@""]){
        msg = @"请输入在校经历";
    }
    
    if (msg.length > 0) {
        [YQToast yq_ToastText:msg bottomOffset:100];
    }else{
        [[RequestManager sharedRequestManager] addEdu_uid:[UserEntity getUid] eduId:eduId schoolname:schoolname major:major entrancetime:entrancetime graduate:graduate edu:edu experience:experience success:^(id resultDic) {
            if ([resultDic[CODE] isEqualToString:SUCCESS]) {
                
                [YQToast yq_ToastText:@"保存成功" bottomOffset:100];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.addEditBlock) {
                    ResumeManageSubEntity *en = [[ResumeManageSubEntity alloc] init];
                    en.schoolname = schoolname;
                    en.major = major;
                    en.edu = edu;
                    en.entrancetime = [NSString stringToTimeStamp:entrancetime formatter:YYYYMMdd];
                    if ([graduate isEqualToString:@"00-00-00"]) {
                        en.graduate = @"943891200";
                    }else{
                        en.graduate = [NSString stringToTimeStamp:graduate formatter:YYYYMMdd];
                    }
                    en.experience = experience;
                    self.addEditBlock(YES,en);
                }
            }
        } failure:^(NSError *error) {
            [self.hud hide:YES];
            NSLog(@"网络连接错误");
        }];
    }
}
- (void)scrollerClick:(UIGestureRecognizer *)sender
{
    // 隐藏键盘
    [self hideKeyBoard];
}

- (void)hideKeyBoard
{
    [_oneTextField resignFirstResponder];
    [_twoTextField resignFirstResponder];
    [_threeTextField resignFirstResponder];
    [_startTextField resignFirstResponder];
    [_endTextField resignFirstResponder];
    [_textView resignFirstResponder];
}

//-(void)dealloc
//{
//    NSLog(@"%@",NSStringFromClass([self class]));
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
