//
//  ZFQTeacherViewController.m
//  DIMSystem
//
//  Created by wecash on 15/4/7.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQTeacherViewController.h"
#import "UIBarButtonItem+DIM.h"
#import "ZFQMecroDefine.h"
#import "ZFQGeneralService.h"

#import "DropDownListView.h"

@interface ZFQTeacherViewController () <DropDownChooseDataSource,DropDownChooseDelegate>
{
    NSArray *departments;       //部门
    NSDictionary *departmentDic;
    NSArray *jobs;              //职位
    
    DropDownListView *majorListView;
    NSString *currDepartmentKey;
}
@end

@implementation ZFQTeacherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置返回按钮
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithIcon:@"内页-返回"
                                                   HighegIcon:@"内页-返回-press"
                                                       Target:self
                                                       action:@selector(tapBackItemAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    //添加关闭键盘gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.cancelsTouchesInView = NO;
    [_myScrollView addGestureRecognizer:tapGesture];
    
    
    CGRect originFrame = CGRectZero;
    //-------个人信息----------
    UILabel *infoLabel = [ZFQGeneralService labelWithTitle:@"个人信息" fontSize:14];
    originFrame = infoLabel.frame;
    originFrame.origin = CGPointMake(20, 10);
    infoLabel.frame = originFrame;
    [_myScrollView addSubview:infoLabel];
    
    //选择照片按钮
    UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarBtn.frame = CGRectMake(20, 10 + CGRectGetMaxY(infoLabel.frame), 50, 50);
    [avatarBtn setTitle:@"添加\n头像" forState:UIControlStateNormal];
    [avatarBtn setTitleColor:ZFQ_LinkColorNormal forState:UIControlStateNormal];
    [avatarBtn setTitleColor:ZFQ_LinkColorPressed forState:UIControlStateHighlighted];
    avatarBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    avatarBtn.titleLabel.numberOfLines = 0;
    avatarBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    avatarBtn.layer.borderWidth = 1;
    avatarBtn.layer.cornerRadius = 25.f;
    [_myScrollView addSubview:avatarBtn];
    
    originFrame = CGRectZero;
    CGFloat padding = 10.f;

    //姓名框
    CGFloat textFieldWidth = ZFQ_ScreenWidth/2 - 50;
    CGFloat textFieldHeight = 30;
    UITextField *nameTextField = [ZFQGeneralService textFieldWithPlaceholder:@"姓名" width:textFieldWidth];
    originFrame = nameTextField.frame;
    originFrame.origin = CGPointMake(CGRectGetMaxX(avatarBtn.frame) + 20, CGRectGetMaxY(avatarBtn.frame) - originFrame.size.height - 20);
    nameTextField.frame = originFrame;
    [_myScrollView addSubview:nameTextField];
    
    //性别
    UILabel *genderLabel = [ZFQGeneralService labelWithTitle:@"性别:"];
    originFrame = genderLabel.frame;
    genderLabel.center = CGPointMake(CGRectGetMaxX(nameTextField.frame) + padding + originFrame.size.width/2, nameTextField.center.y);
    [_myScrollView addSubview:genderLabel];
    
    CGRect genderDropListViewFrame = CGRectMake(CGRectGetMaxX(genderLabel.frame), CGRectGetMinY(nameTextField.frame), textFieldWidth/2-10, textFieldHeight);
    DropDownListView *genderDropListView = [[DropDownListView alloc] initWithFrame:genderDropListViewFrame
                                                                        dataSource:self
                                                                          delegate:self
                                                                               tag:100];
    [_myScrollView addSubview:genderDropListView];
    
    //教工号
    UITextField *teacherIDTextField = [ZFQGeneralService textFieldWithPlaceholder:@"教工号"
                                                                            width:nameTextField.frame.size.width];
    originFrame = teacherIDTextField.frame;
    CGFloat centerY = CGRectGetMaxY(nameTextField.frame) + 10 + teacherIDTextField.frame.size.height/2;
    teacherIDTextField.center = CGPointMake(nameTextField.frame.origin.x + originFrame.size.width/2, centerY);
    [_myScrollView addSubview:teacherIDTextField];
    
    CGFloat paddingV = 40;
    //-----------联系方式---------
    UILabel *contactLabel = [ZFQGeneralService labelWithTitle:@"联系方式" fontSize:14];
    originFrame = contactLabel.frame;
    originFrame.origin = CGPointMake(avatarBtn.frame.origin.x, CGRectGetMaxY(teacherIDTextField.frame) + paddingV);
    contactLabel.frame = originFrame;
    [_myScrollView addSubview:contactLabel];
    
    //手机号
    UITextField *mobileTextField = [ZFQGeneralService textFieldWithPlaceholder:@"手机号" width:teacherIDTextField.frame.size.width];
    originFrame = mobileTextField.frame;
    originFrame.origin = CGPointMake(teacherIDTextField.frame.origin.x, CGRectGetMaxY(contactLabel.frame) + 10);
    mobileTextField.frame = originFrame;
    [_myScrollView addSubview:mobileTextField];
    //QQ号
    UITextField *qqTextField = [ZFQGeneralService textFieldWithPlaceholder:@"qq号" width:mobileTextField.frame.size.width];
    originFrame = qqTextField.frame;
    originFrame.origin = CGPointMake(mobileTextField.frame.origin.x, CGRectGetMaxY(mobileTextField.frame) + 10);
    qqTextField.frame = originFrame;
    [_myScrollView addSubview:qqTextField];
    //邮箱
    UITextField *emailTextField = [ZFQGeneralService textFieldWithPlaceholder:@"邮箱" width:mobileTextField.frame.size.width];
    originFrame = emailTextField.frame;
    originFrame.origin = CGPointMake(qqTextField.frame.origin.x, CGRectGetMaxY(qqTextField.frame) + 10);
    emailTextField.frame = originFrame;
    [_myScrollView addSubview:emailTextField];
    
    //--------------职位信息------------
    UILabel *jobInfoLabel = [ZFQGeneralService labelWithTitle:@"职位信息" fontSize:14];
    originFrame = jobInfoLabel.frame;
    originFrame.origin = CGPointMake(contactLabel.frame.origin.x, CGRectGetMaxY(emailTextField.frame) + paddingV);
    jobInfoLabel.frame = originFrame;
    [_myScrollView addSubview:jobInfoLabel];
    
    //1.学院
    CGRect departmentFrame = CGRectMake(emailTextField.frame.origin.x, CGRectGetMaxY(jobInfoLabel.frame) + 10, emailTextField.frame.size.width + 20, textFieldHeight);
    DropDownListView *departmentListView = [[DropDownListView alloc] initWithFrame:departmentFrame
                                                                        dataSource:self
                                                                          delegate:self
                                                                               tag:101];
    departmentListView.needOffset = YES;
    [_myScrollView addSubview:departmentListView];
    //2.专业
    CGRect majorFrame = departmentFrame;
    majorFrame.origin.y = CGRectGetMaxY(departmentFrame) + 10;
    majorListView = [[DropDownListView alloc] initWithFrame:majorFrame
                                                                        dataSource:self
                                                                          delegate:self
                                                                               tag:102];
    majorListView.needOffset = YES;
    [_myScrollView addSubview:majorListView];
    //3.职位
    CGRect jobFrame = majorFrame;
    jobFrame.origin.y = CGRectGetMaxY(majorFrame) + 10;
    DropDownListView *jobListView = [[DropDownListView alloc] initWithFrame:jobFrame
                                                 dataSource:self
                                                   delegate:self
                                                        tag:103];
    jobListView.needOffset = YES;
    [_myScrollView addSubview:jobListView];
    
    //设置contentSize
    _myScrollView.contentSize = CGSizeMake(ZFQ_ScreenWidth, CGRectGetMaxY(jobListView.frame) + 100);
    _myScrollView.alwaysBounceVertical = YES;
}

#pragma mark - 按钮/手势事件
- (void)tapBackItemAction
{
    if (self.navigationController.viewControllers.count == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [self.view.window endEditing:YES];
}

#pragma mark - DropDownListView delegate dataSource

- (void)dropDownListView:(DropDownListView *)listView chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    switch (listView.tag) {
        case 101:{              //学院
            if (currDepartmentKey != nil) {
                //刷新专业
                [majorListView reloadMyTableViewDataInSection:section];
            }
            break;
        }
        case 102: {             //专业
            
            break;
        }
        default:
            break;
    }
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section dropDownListView:(DropDownListView *)listView
{
    switch (listView.tag) {     //性别
        case 100:
            return 2;
        case 101: {             //学院
            if (departments == nil) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"ZFQDepartment" ofType:@"plist"];
                departments = [NSArray arrayWithContentsOfFile:path];
            }
            return departments.count;
        }
        case 102: {             //专业
            if (currDepartmentKey == nil) {
                return 0;
            }
            if (departmentDic == nil) {
                departmentDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFQMajor" ofType:@"plist"]];
            }
            NSArray *array = [departmentDic objectForKey:currDepartmentKey];
            return array.count;
        }
        case 103: {
            if (jobs == nil) {
                jobs = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFQJob" ofType:@"plist"]];
            }
            return jobs.count;
        }
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInDropDownListView:(DropDownListView *)listView
{
    return 1;
}

- (NSString *)titleInSection:(NSInteger)section index:(NSInteger) index dropDownListView:(DropDownListView *)listView
{
    switch (listView.tag) {
        case 100: {             //性别
             return index == 0 ? @"男" : @"女";
        }
        case 101: {             //学院
            if (departments == nil) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"ZFQDepartment" ofType:@"plist"];
                departments = [NSArray arrayWithContentsOfFile:path];
            }
            NSDictionary *dic = [departments objectAtIndex:index];
            currDepartmentKey = dic.allKeys.firstObject;
            return [dic objectForKey:currDepartmentKey];
        }
        case 102: {             //专业
            if (currDepartmentKey == nil) {
                return nil;
            }
            if (departmentDic == nil) {
                departmentDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFQMajor" ofType:@"plist"]];
            }
            NSArray *array = [departmentDic objectForKey:currDepartmentKey];
            return [array objectAtIndex:index];
        }
        case 103: {
            if (jobs == nil) {
                jobs = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFQJob" ofType:@"plist"]];
            }
            return [jobs objectAtIndex:index];
        }
        default:
            return nil;
    }
}

-(NSInteger)defaultShowSection:(NSInteger)section dropDownListView:(DropDownListView *)listView
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
