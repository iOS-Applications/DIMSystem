//
//  ZFQTeacherHomeController.m
//  DIMSystem
//
//  Created by wecash on 15/4/22.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQTeacherHomeController.h"
#import "ZFQTeacherInfoController.h"
#import "ZFQDocumentsController.h"
#import "ZFQTeachersController.h"
#import "ZFQGeneralService.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "commenConst.h"

#import <MobileCoreServices/MobileCoreServices.h>

NSString * const cellID = @"cellID";

@interface ZFQTeacherHomeController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation ZFQTeacherHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"内页-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"内页-返回-press"] forState:UIControlStateNormal];
    backBtn.bounds = CGRectMake(0, 0, 30, 30);
    [backBtn addTarget:self action:@selector(tapBackItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //添加tableView
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    //注册tableViewCell
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    self.title = @"查看";
    [ZFQGeneralService documentsDirectory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_myTableView deselectRowAtIndexPath:[_myTableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"查看个人信息";
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"查看教学资料";
            }
            break;
        }
        case 1: {
            cell.textLabel.text = @"查看其他教师信息";
            break;
        }
        case 2: {
            cell.textLabel.text = @"修改登录密码";
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
        return 2;
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
        if (indexPath.row == 0) {
            ZFQTeacherInfoController *teahcerInfoVC = [[ZFQTeacherInfoController alloc] init];
            teahcerInfoVC.idNum = [ZFQGeneralService accessId];
            [self.navigationController pushViewController:teahcerInfoVC animated:YES];
        } else {
            ZFQDocumentsController *docVC = [[ZFQDocumentsController alloc] init];
            [self.navigationController pushViewController:docVC animated:YES];
        }
    } else if (indexPath.section == 1) {
        ZFQTeachersController *teachersVC = [[ZFQTeachersController alloc] init];
        [self.navigationController pushViewController:teachersVC animated:YES];
    } else if (indexPath.section == 2) {
        [self showSettingPwdView];
    }
}

- (void)showSettingPwdView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入新密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSString *newPwd = [alertView textFieldAtIndex:0].text;
        [SVProgressHUD showWithStatus:@"请稍后..."];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *postURL = [kHost stringByAppendingString:@"/updateTeacherPwd"];
        NSDictionary *param = @{@"idNum":[ZFQGeneralService accessId],@"newPwd":newPwd};
        [manager POST:postURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            NSNumber *status = dic[@"status"];
            if (status.integerValue == 200) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            } else {
                NSString *msg = dic[@"msg"];
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [_myTableView deselectRowAtIndexPath:[_myTableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *pattern = @"^\\w{6,}$";
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    NSInteger num = [expression numberOfMatchesInString:textField.text
                                                options:NSMatchingReportCompletion
                                                  range:NSMakeRange(0, textField.text.length)];
    
    if (num == 0) {
        return NO;
    }
    return YES;
}

- (void)tapBackItemAction
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
