//
//  ZFQAddTeacherController.m
//  DIMSystem
//
//  Created by wecash on 15/5/15.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQAddTeacherController.h"
#import "ZFQGeneralService.h"
#import "ZFQMecroDefine.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "commenConst.h"

@interface ZFQAddTeacherController () <UITextFieldDelegate>
{
    UIButton *submitBtn;
}
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *idNumTextField;
@property (nonatomic,strong) UITextField *pwdTextField;
@property (nonatomic,strong) UISwitch *mySwitch;
@end

@implementation ZFQAddTeacherController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加教师信息";
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _myScrollView.backgroundColor = [UIColor whiteColor];
    _myScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_myScrollView];
    
    CGFloat width = ZFQ_ScreenWidth;
    CGRect originFrame = CGRectZero;
    //姓名框
    CGFloat textFieldWidth = ZFQ_ScreenWidth/2 + 50;
    CGFloat textFieldHeight = 30;
    _nameTextField = [ZFQGeneralService textFieldWithPlaceholder:@"姓名" width:textFieldWidth];
    _nameTextField.center = CGPointMake(width/2 - 20, textFieldHeight/2 + 10);
    _nameTextField.delegate = self;
    _nameTextField.enablesReturnKeyAutomatically = YES;
    _nameTextField.tag = 302;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    [_myScrollView addSubview:_nameTextField];
    
    originFrame = _nameTextField.frame;
    _idNumTextField = [ZFQGeneralService textFieldWithPlaceholder:@"教工号" width:textFieldWidth];
    _idNumTextField.center = CGPointMake(width/2 - 20, textFieldHeight/2 + 10 + CGRectGetMaxY(originFrame));
    _idNumTextField.delegate = self;
    _idNumTextField.enablesReturnKeyAutomatically = YES;
    _idNumTextField.tag = 303;
    _idNumTextField.returnKeyType = UIReturnKeyNext;
    [_myScrollView addSubview:_idNumTextField];
    
    originFrame = _idNumTextField.frame;
    _pwdTextField = [ZFQGeneralService textFieldWithPlaceholder:@"初始密码" width:textFieldWidth];
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.center = CGPointMake(width/2 - 20, textFieldHeight/2 + 10 + CGRectGetMaxY(originFrame));
    _pwdTextField.delegate = self;
    _pwdTextField.enablesReturnKeyAutomatically = YES;
    _pwdTextField.tag = 304;
    [_myScrollView addSubview:_pwdTextField];

    //添加开关
    _mySwitch = [[UISwitch alloc] init];
    originFrame = _mySwitch.frame;
    _mySwitch.center = CGPointMake(originFrame.size.width/2 + CGRectGetMaxX(_pwdTextField.frame) + 8, _pwdTextField.center.y);
    [_myScrollView addSubview:_mySwitch];
    [_mySwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    
    //添加按钮
    submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1]];
    submitBtn.layer.cornerRadius = 4;
    [submitBtn addTarget:self action:@selector(tapSubmitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.bounds = CGRectMake(0, 0, width/2 + 50, 36);
    submitBtn.center = CGPointMake(width/2, CGRectGetMaxY(_pwdTextField.frame) + submitBtn.bounds.size.height/2 + 20);
    [_myScrollView addSubview:submitBtn];
    submitBtn.enabled = NO;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [_myScrollView addGestureRecognizer:tapGesture];
     
}

- (void)textChanged:(NSNotification *)notification
{
    BOOL b1 = [_nameTextField.text isEqualToString:@""];
    BOOL b2 = [_idNumTextField.text isEqualToString:@""];
    BOOL b3 = [_pwdTextField.text isEqualToString:@""];
    
    if (b1 || b2 || b3
        || _nameTextField.text == nil
        || _idNumTextField.text == nil
        || _pwdTextField.text == nil) {
        submitBtn.enabled = NO;
    } else {
        submitBtn.enabled = YES;
    }
}

- (void)tapSubmitBtnAction
{
    NSDictionary *param = @{
                            @"t_name":_nameTextField.text,
                            @"t_id":_idNumTextField.text,
                            @"t_pwd":_pwdTextField.text
                            };
    
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [Reachability isReachableWithHostName:kHost complition:^(BOOL isReachable) {
        if (reachable(isReachable)) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *urlStr = [kHost stringByAppendingString:@"/adminAddTeacherInfo"];
            [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dic = responseObject;
                NSNumber *status = dic[@"status"];
                if (status.integerValue == 200) {
                    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                } else {
                    NSString *msg = dic[@"msg"];
                    [SVProgressHUD showErrorWithStatus:msg];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    }];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)switchAction
{
    if (_mySwitch.isOn == YES) {
        _pwdTextField.secureTextEntry = NO;
    } else {
        _pwdTextField.secureTextEntry = YES;
    }
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 302) {
        [_idNumTextField becomeFirstResponder];
    } else if (textField.tag == 303) {
        [_pwdTextField becomeFirstResponder];
    }
    return YES;
}

- (void)dealloc
{
    NSLog(@"release add");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
