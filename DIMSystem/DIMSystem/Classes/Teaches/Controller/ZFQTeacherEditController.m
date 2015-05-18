//
//  ZFQTeacherViewController.m
//  DIMSystem
//
//  Created by wecash on 15/4/7.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQTeacherEditController.h"
#import "UIBarButtonItem+DIM.h"
#import "ZFQMecroDefine.h"
#import "ZFQGeneralService.h"

#import "DropDownListView.h"
#import "UIImage+CropPortraint.h"
#import "SVProgressHUD+ZFQCustom.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "commenConst.h"

@interface ZFQTeacherEditController () <DropDownChooseDataSource,DropDownChooseDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    DropDownListView *majorListView;
    NSString *currDepartmentKey;
    
    UIButton *avatarBtn;        //头像按钮
    
    UITextField *currFocusField;
    CGFloat preOffsetY;
    NSInteger departIndex;      //学院的index
}

@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSDictionary *departmentDic;;
@property (nonatomic,strong) NSArray *jobs;
@property (nonatomic,strong) NSArray *departmentInfo;

@end

@implementation ZFQTeacherEditController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    preOffsetY = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tapCancelItemAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapCompleteItemAction)];
    
    //添加关闭键盘gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.cancelsTouchesInView = NO;
    [_myScrollView addGestureRecognizer:tapGesture];
    _myScrollView.delegate = self;
    //添加键盘显示观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    CGRect originFrame = CGRectZero;
    //-------个人信息----------
    UILabel *infoLabel = [ZFQGeneralService labelWithTitle:@"个人信息" fontSize:14];
    originFrame = infoLabel.frame;
    originFrame.origin = CGPointMake(20, 10);
    infoLabel.frame = originFrame;
    [_myScrollView addSubview:infoLabel];
    
    //选择照片按钮
    avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarBtn.frame = CGRectMake(20, 10 + CGRectGetMaxY(infoLabel.frame), 50, 50);
    [avatarBtn setTitle:@"添加\n头像" forState:UIControlStateNormal];
    [avatarBtn setTitleColor:ZFQ_LinkColorNormal forState:UIControlStateNormal];
    [avatarBtn setTitleColor:ZFQ_LinkColorPressed forState:UIControlStateHighlighted];
    [avatarBtn setImage:self.myAvatar forState:UIControlStateNormal];
    avatarBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    avatarBtn.titleLabel.numberOfLines = 0;
    avatarBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    avatarBtn.layer.borderWidth = 1;
    avatarBtn.layer.cornerRadius = 25.f;
    avatarBtn.clipsToBounds = YES;
    
    [avatarBtn addTarget:self action:@selector(tapAvatarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:avatarBtn];
    
    originFrame = CGRectZero;
    CGFloat padding = 10.f;
    
    //姓名框
    CGFloat textFieldWidth = ZFQ_ScreenWidth/2 - 50;
    CGFloat textFieldHeight = 30;
    nameTextField = [ZFQGeneralService textFieldWithPlaceholder:@"姓名" width:textFieldWidth];
    originFrame = nameTextField.frame;
    originFrame.origin = CGPointMake(CGRectGetMaxX(avatarBtn.frame) + 20, CGRectGetMaxY(avatarBtn.frame) - originFrame.size.height - 20);
    nameTextField.frame = originFrame;
    [_myScrollView addSubview:nameTextField];
    nameTextField.delegate = self;
    nameTextField.text = _teacherInfo[@"t_name"];
    
    //性别
    UILabel *genderLabel = [ZFQGeneralService labelWithTitle:@"性别:"];
    originFrame = genderLabel.frame;
    genderLabel.center = CGPointMake(CGRectGetMaxX(nameTextField.frame) + padding + originFrame.size.width/2, nameTextField.center.y);
    [_myScrollView addSubview:genderLabel];
    
    CGRect genderDropListViewFrame = CGRectMake(CGRectGetMaxX(genderLabel.frame), CGRectGetMinY(nameTextField.frame), textFieldWidth/2-10, textFieldHeight);
    genderDropListView = [[DropDownListView alloc] initWithFrame:genderDropListViewFrame
                                                      dataSource:self
                                                        delegate:self
                                                             tag:100];
    [_myScrollView addSubview:genderDropListView];
    
    //教工号
    teacherIDTextField = [ZFQGeneralService textFieldWithPlaceholder:@"教工号"
                                                               width:nameTextField.frame.size.width + 40];
    originFrame = teacherIDTextField.frame;
    CGFloat centerY = CGRectGetMaxY(nameTextField.frame) + 10 + teacherIDTextField.frame.size.height/2;
    teacherIDTextField.center = CGPointMake(nameTextField.frame.origin.x + originFrame.size.width/2, centerY);
    [_myScrollView addSubview:teacherIDTextField];
    teacherIDTextField.delegate = self;
    teacherIDTextField.text = _teacherInfo[@"t_id"];
    teacherIDTextField.enabled = NO;
    
    CGFloat paddingV = 40;
    //-----------联系方式---------
    UILabel *contactLabel = [ZFQGeneralService labelWithTitle:@"联系方式" fontSize:14];
    originFrame = contactLabel.frame;
    originFrame.origin = CGPointMake(avatarBtn.frame.origin.x, CGRectGetMaxY(teacherIDTextField.frame) + paddingV);
    contactLabel.frame = originFrame;
    [_myScrollView addSubview:contactLabel];
    
    //手机号
    mobileTextField = [ZFQGeneralService textFieldWithPlaceholder:@"手机号" width:teacherIDTextField.frame.size.width];
    originFrame = mobileTextField.frame;
    originFrame.origin = CGPointMake(teacherIDTextField.frame.origin.x, CGRectGetMaxY(contactLabel.frame) + 10);
    mobileTextField.frame = originFrame;
    [_myScrollView addSubview:mobileTextField];
    mobileTextField.delegate = self;
    mobileTextField.text = _teacherInfo[@"t_mobile"];
    
    //QQ号
    qqTextField = [ZFQGeneralService textFieldWithPlaceholder:@"qq号" width:mobileTextField.frame.size.width];
    originFrame = qqTextField.frame;
    originFrame.origin = CGPointMake(mobileTextField.frame.origin.x, CGRectGetMaxY(mobileTextField.frame) + 10);
    qqTextField.frame = originFrame;
    [_myScrollView addSubview:qqTextField];
    qqTextField.delegate = self;
    qqTextField.text = _teacherInfo[@"t_qq"];
    
    //邮箱
    emailTextField = [ZFQGeneralService textFieldWithPlaceholder:@"邮箱" width:mobileTextField.frame.size.width + 20];
    originFrame = emailTextField.frame;
    originFrame.origin = CGPointMake(qqTextField.frame.origin.x, CGRectGetMaxY(qqTextField.frame) + 10);
    emailTextField.frame = originFrame;
    [_myScrollView addSubview:emailTextField];
    emailTextField.delegate = self;
    emailTextField.text = _teacherInfo[@"t_email"];
    
    //--------------职位信息------------
    UILabel *jobInfoLabel = [ZFQGeneralService labelWithTitle:@"职位信息" fontSize:14];
    originFrame = jobInfoLabel.frame;
    originFrame.origin = CGPointMake(contactLabel.frame.origin.x, CGRectGetMaxY(emailTextField.frame) + paddingV);
    jobInfoLabel.frame = originFrame;
    [_myScrollView addSubview:jobInfoLabel];
    
    //1.学院
    CGRect departmentFrame = CGRectMake(emailTextField.frame.origin.x, CGRectGetMaxY(jobInfoLabel.frame) + 10, emailTextField.frame.size.width + 20, textFieldHeight);
    departmentListView = [[DropDownListView alloc] initWithFrame:departmentFrame
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
    jobListView = [[DropDownListView alloc] initWithFrame:jobFrame
                                               dataSource:self
                                                 delegate:self
                                                      tag:103];
    jobListView.needOffset = YES;
    [_myScrollView addSubview:jobListView];
    
    //设置contentSize
    _myScrollView.contentSize = CGSizeMake(ZFQ_ScreenWidth, CGRectGetMaxY(jobListView.frame) + 100);
    _myScrollView.alwaysBounceVertical = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    preOffsetY = _myScrollView.contentOffset.y;
}

#pragma mark - 按钮/手势事件
- (void)tapAvatarBtnAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (buttonIndex < 2) {
        if (buttonIndex == 0) {         //拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            } else {
                [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            
        } else if (buttonIndex == 1){   //从相册选择
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        imagePicker.allowsEditing = YES;
        [imagePicker setEditing:YES animated:YES];
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - imagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *smallImg = [image portraintWithSize:avatarBtn.bounds.size];
    NSData *imgData = UIImagePNGRepresentation(smallImg);
    [avatarBtn setImage:smallImg forState:UIControlStateNormal];
    //获取cell
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        //上传图片
        [SVProgressHUD showZFQHUDWithStatus:@"正在上传"];
        NSString *postURL = [kHost stringByAppendingString:@"/uploadAvatar"];
        NSDictionary *param = @{@"idNum":[ZFQGeneralService accessId]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:postURL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imgData name:@"file" fileName:@"aaaa.png" mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            NSNumber *status = dic[@"status"];
            if (status.integerValue == 200) {
                [SVProgressHUD showZFQSuccessWithStatus:@"上传成功"];
            } else {
                [SVProgressHUD showZFQSuccessWithStatus:@"上传失败"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showZFQErrorWithStatus:@"上传失败"];
        }];
        
    }];
}

- (void)tapBackItemAction
{
    if (self.navigationController.viewControllers.count == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tapCancelItemAction
{
    if (self.cancelBlk) {
        self.cancelBlk(avatarBtn.imageView.image);
    }
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)tapCompleteItemAction
{
    //0.将图片保存到Documents中
    
    NSDictionary *teacherInfo = [self teacherInfoUsingEncoding:NO];
    ZFQTeacherEditController * __weak weakSelf = self;
    
    [Reachability isReachableWithHostName:kHost complition:^(BOOL isReachable) {
        if (reachable(isReachable)) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *postURL = [kHost stringByAppendingString:@"/updateTeacherInfo"];
            [manager POST:postURL parameters:teacherInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dic = responseObject;
                NSNumber *status = dic[@"status"];
                if (status.integerValue == 200) {
                    [SVProgressHUD showZFQSuccessWithStatus:@"已保存"];
                    [weakSelf dismissEditViewControllerWithTeacherInfo:teacherInfo];
                } else {
                    NSString *msg = dic[@"msg"];
                    [SVProgressHUD showZFQErrorWithStatus:msg];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showZFQErrorWithStatus:@"请求失败"];
            }];
        } else {
            [SVProgressHUD showZFQErrorWithStatus:@"网络不给力"];
        }
    }];
    
    
    //1.先上传数据到服务器，若成功，则把数据直接给teacherInfoVC
    //2.上传完成后再关闭该VC
}

- (void)dismissEditViewControllerWithTeacherInfo:(NSDictionary *)teacherInfo
{
    if (self.completionBlk != nil) {
        self.completionBlk(teacherInfo,avatarBtn.imageView.image);   //[self teacherInfoUsingEncoding:NO]
    }
    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
}

- (NSDictionary *)teacherInfoUsingEncoding:(BOOL)usingEcoding
{
    if (usingEcoding == YES) {
        
        NSDictionary *teacherInfo = @{
                                      @"t_name":nameTextField.text,
                                      @"idNum":teacherIDTextField.text,
                                      @"gender":genderDropListView.currentTitle,
                                      @"mobile":mobileTextField.text,
                                      @"qq":qqTextField.text,
                                      @"email":emailTextField.text,
                                      @"department":departmentListView.currentTitle,
                                      @"major":majorListView.currentTitle,
                                      @"job":jobListView.currentTitle
                                      };
        return teacherInfo;
    } else {
        
        NSDictionary *teacherInfo = @{
                                      @"t_name":nameTextField.text,
                                      @"t_id":teacherIDTextField.text,
                                      @"t_gender":genderDropListView.currentTitle,
                                      @"t_mobile":mobileTextField.text,
                                      @"t_qq":qqTextField.text,
                                      @"t_email":emailTextField.text,
                                      @"t_faculty":departmentListView.currentTitle,
                                      @"t_major":majorListView.currentTitle,
                                      @"t_job":jobListView.currentTitle
                                      };
        
        return teacherInfo;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [_myScrollView setContentOffset:CGPointMake(0, preOffsetY) animated:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    preOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    preOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    preOffsetY = scrollView.contentOffset.y;
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currFocusField = textField;
    return YES;
}

#pragma mark - 键盘通知事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    preOffsetY = _myScrollView.contentOffset.y;
    NSDictionary *info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    
    CGFloat result = (CGRectGetMaxY(currFocusField.frame) - _myScrollView.contentOffset.y) - (ZFQ_ScreenHeight - keyboardHeight);
    if (result > 0) {
        [_myScrollView setContentOffset:CGPointMake(0, _myScrollView.contentOffset.y+result+10) animated:YES];
    }
}

#pragma mark - getter
- (NSArray *)departments
{
    if (_departments == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ZFQDepartment" ofType:@"plist"];
        _departments = [NSArray arrayWithContentsOfFile:path];
    }
    return _departments;
}

- (NSDictionary *)departmentDic
{
    if (_departmentDic == nil) {
        _departmentDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFQMajor" ofType:@"plist"]];
    }
    return _departmentDic;
}

- (NSArray *)jobs
{
    if (_jobs == nil) {
        _jobs = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFQJob" ofType:@"plist"]];
    }
    return _jobs;
}

- (NSArray *)departmentInfo
{
    if (_departmentInfo == nil) {
        _departmentInfo = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFQDepartInfo" ofType:@"plist"]];
    }
    return _departmentInfo;
}

#pragma mark - DropDownListView delegate dataSource

- (void)dropDownListView:(DropDownListView *)listView chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    switch (listView.tag) {
        case 101:{              //学院
            if (currDepartmentKey != nil) {
                //刷新专业
                departIndex = index;
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

- (NSInteger)numberOfRowsInSection:(NSInteger)section dropDownListView:(DropDownListView *)listView
{
    switch (listView.tag) {     //性别
        case 100:
            return 2;
        case 101: {             //学院
            return self.departments.count;
        }
        case 102: {             //专业
            if (currDepartmentKey == nil) {
                return 0;
            }
            
            NSArray *array = [self.departmentDic objectForKey:currDepartmentKey];
            return array.count;
        }
        case 103: {
            return self.jobs.count;
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
            NSDictionary *dic = [self.departments objectAtIndex:index];
            currDepartmentKey = dic.allKeys.firstObject;
            
            return [dic objectForKey:currDepartmentKey];
        }
        case 102: {             //专业
            if (currDepartmentKey == nil) {
                return nil;
            }
            
            NSArray *array = [self.departmentDic objectForKey:currDepartmentKey];
            return [array objectAtIndex:index];
        }
        case 103: {             //职称
            return [self.jobs objectAtIndex:index];
        }
        default:
            return nil;
    }
}

- (NSInteger)defaultShowSection:(NSInteger)section dropDownListView:(DropDownListView *)listView
{
    switch (listView.tag) {
        case 100: {          //性别
            //获取
            NSString *tempGender = _teacherInfo[@"t_gender"];
            if (tempGender == nil || [tempGender isEqualToString:@""] || [tempGender isKindOfClass:[NSNull class]]) {
                return 0;
            }
            if ([tempGender isEqualToString:@"男"]) {
                return 0;
            } else {
                return 1;
            }
            break;
        }
            
        case 101:   {         //学院
            NSString *departName = _teacherInfo[@"t_faculty"];
            if (departName == nil || [departName isEqualToString:@""] || [departName isKindOfClass:[NSNull class]]) {
                return 0;
            }
            departIndex = [self indexOfDrowListTitle:departName];
            return departIndex;
        }
        case 102:  {         //专业
            NSString *majorName = _teacherInfo[@"t_major"];
            if (majorName == nil || [majorName isEqualToString:@""] || [majorName isKindOfClass:[NSNull class]]) {
                return 0;
            }
            NSDictionary *info = self.departmentInfo[departIndex];
            NSArray *array = info[@"list"];
            NSInteger index = 0;
            BOOL exist = NO;
            for (NSString *name in array) {
                if ([name isEqualToString:majorName]) {
                    exist = YES;
                    break;
                }
                index ++;
            }
            index = (exist == YES) ? index : 0;
            return index;
        }
        case 103: {          //职称
            NSString *jobName = _teacherInfo[@"t_job"];
            if (jobName == nil || [jobName isEqualToString:@""] || [jobName isKindOfClass:[NSNull class]]) {
                return 0;
            }
            NSInteger index = 0;
            BOOL exist = NO;
            for (NSString *tempName in self.jobs) {
                if ([jobName isEqualToString:tempName]) {
                    exist = YES;
                    break;
                }
                index ++;
            }
            index = (exist == YES) ? index : 0;
            return index;
        }
    }
    return 0;
}

- (NSInteger)indexOfDrowListTitle:(NSString *)title
{
    NSArray *array = self.departmentInfo;
    __block NSInteger index = 0;
    for (NSInteger index = 0; index < array.count; index ++) {
        NSString *tempStr = [array[index] objectForKey:[NSString stringWithFormat:@"dep%zi",index + 1]];
        if ([tempStr isEqualToString:title]) {
            return index;
        }
    }
    return index;
}

#pragma mark - 辅助函数

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
