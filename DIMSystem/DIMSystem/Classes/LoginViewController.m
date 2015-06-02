//
//  LoginViewController.m
//  DIMSystem
//
//  Created by wecash on 15/5/2.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "commenConst.h"
#import "SVProgressHUD+ZFQCustom.h"
#import "ZFQMecroDefine.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic,copy) void (^successBlk)(NSInteger loginType);

@end

@implementation LoginViewController

- (instancetype)initWithLoginSuccessBlock:(void (^)(NSInteger loginType))successBlk
{
    self = [super init];
    if (self) {
        if (successBlk) {
            self.successBlk = successBlk;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.teacherBtn.circleStrokeWidth = 2;
    self.teacherBtn.circleRadius = 8;
    self.teacherBtn.indicatorRadius = 3;
    self.teacherBtn.circleColor = [UIColor grayColor];
    self.teacherBtn.selected = YES;
    
    DLRadioButton *adminBtn = self.teacherBtn.otherButtons.firstObject;
    adminBtn.circleStrokeWidth = 2;
    adminBtn.circleRadius = 8;
    adminBtn.indicatorRadius = 3;
    adminBtn.circleColor = [UIColor grayColor];
    
    self.loginBtn.layer.cornerRadius = 4;
    
    self.userNameTextField.tag = 101;
    self.userPsdTextField.tag = 102;
    self.userNameTextField.delegate = self;
    self.userPsdTextField.delegate = self;
    
    self.loginBtn.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)tapLoginAction:(id)sender
{
    [self login];
}

- (void)login
{
    NSString *name = self.userNameTextField.text;
    NSString *pwd = self.userPsdTextField.text;
    DLRadioButton *currSelectBtn = self.teacherBtn.selectedButton;
    
    NSDictionary *param = nil;
    NSInteger loginType = 1;
    if ([currSelectBtn.currentTitle isEqualToString:@"教师"]) {
        loginType = 1;
        param = @{@"idNum":name,@"pwd":pwd,@"login_type":@(1)};
    } else {
        loginType = 2;
        param = @{@"idNum":name,@"pwd":pwd,@"login_type":@(2)};
    }
    
    //判断网络是否可用
    LoginViewController * __weak weakSelf = self;
    [Reachability isReachableWithHostName:kHost complition:^(BOOL isReachable) {
        if (reachable(isReachable)) {  //isReachable == YES
            [SVProgressHUD showZFQHUDWithStatus:@"请稍后..."];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            //post请求
            NSString *loginURL = [NSString stringWithFormat:@"%@/login",kHost];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
            [manager POST:loginURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dic = responseObject;
                NSNumber *status = dic[@"status"];
                if (status.integerValue != 200) {
                    NSString *msg = dic[@"msg"];
                    [SVProgressHUD showZFQErrorWithStatus:msg];
                } else {
                    
                    if (loginType == 1) {   //教师登陆
                        //登陆成功，保存access_id
                        NSString *accessId = dic[@"access_id"];
                        [[NSUserDefaults standardUserDefaults] setObject:accessId forKey:kAccessId];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [SVProgressHUD dismiss];
                        
                        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:^{
                            weakSelf.successBlk(1);
                        }];
                    } else {      //管理员登陆
                        [SVProgressHUD dismiss];
                        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:^{
                            weakSelf.successBlk(2);
                        }];
                    }
   
                }
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showZFQErrorWithStatus:error.localizedDescription];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        } else {
            [SVProgressHUD showZFQErrorWithStatus:@"网络不给力"];
        }
    }];
    
}

- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (IBAction)dismissLoginViewController:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 101) {
        [self.userPsdTextField becomeFirstResponder];
    } else {
        [textField endEditing:YES];
        [self login];
    }
    return YES;
}

- (void)textFieldDidChange:(NSNotification *)notification
{
    if (self.userNameTextField.text != nil && self.userPsdTextField.text != nil
        && ![self.userNameTextField.text isEqualToString:@""] && ![self.userPsdTextField.text isEqualToString:@""]) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
@end
