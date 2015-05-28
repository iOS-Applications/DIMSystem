//
//  ZFQAdminHomeController.m
//  DIMSystem
//
//  Created by wecash on 15/5/15.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQAdminHomeController.h"
#import "ZFQAddTeacherController.h"
#import "ZFQTeachersController.h"
#import "ZFQMecroDefine.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "commenConst.h"
#import "ZFQGeneralService.h"

NSString * const zfqAdminCellID = @"cell";

@interface ZFQAdminHomeController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZFQAdminHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"管理员";
    
    //添加tableView
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    //注册tableViewCell
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:zfqAdminCellID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kZFQDelNotification object:nil];
    
}

#pragma mark - tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zfqAdminCellID];
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"添加教师信息";
            } 
            break;
        }
        case 1: {
            cell.textLabel.text = @"删除教师信息";
            break;
        }
        case 2: {
            cell.textLabel.text = @"重置教师登陆密码";
            break;
        }
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZFQAddTeacherController *addVC = [[ZFQAddTeacherController alloc] init];
        [self.navigationController pushViewController:addVC animated:YES];
    } else if (indexPath.section == 1) {
        ZFQTeachersController *teachersVC = [[ZFQTeachersController alloc] init];
        teachersVC.showDeleteItem = YES;
        [self.navigationController pushViewController:teachersVC animated:YES];
    } else if (indexPath.section == 2) {
        [self showSettingPwdView];
    }
}

- (void)showSettingPwdView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置登陆密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alertView.delegate = self;
    UITextField *idNumTextField = [alertView textFieldAtIndex:0];
    idNumTextField.placeholder = @"教工号";
    UITextField *pwdTextField = [alertView textFieldAtIndex:1];
    pwdTextField.placeholder = @"新密码";
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    UITextField *idNumTextField = [alertView textFieldAtIndex:0];
    UITextField *pwdTextField = [alertView textFieldAtIndex:1];
    
    [SVProgressHUD showWithStatus:@"请稍后..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *postURL = [kHost stringByAppendingString:@"/updateTeacherPwd"];
    NSDictionary *param = @{
                            @"idNum":idNumTextField.text,
                            @"newPwd":pwdTextField.text
                            };
    [manager POST:postURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *status = dic[@"status"];
        if (status.integerValue == 200) {
            [SVProgressHUD showSuccessWithStatus:@"重置成功，请牢记密码"];
        } else {
            NSString *msg = dic[@"msg"];
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *idNumTextField = [alertView textFieldAtIndex:0];
    UITextField *pwdTextField = [alertView textFieldAtIndex:1];
    if (idNumTextField.text == nil || [idNumTextField.text isEqualToString:@""]) {
        return NO;
    }
    if (pwdTextField.text == nil || [pwdTextField.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
