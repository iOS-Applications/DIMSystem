//
//  ViewController.m
//  DIMSystem
//
//  Created by qingyun on 15/4/5.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ViewController.h"
#import "UIBarButtonItem+DIM.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "PracProjectsOfItem.h"
#import "PracShiXun.h"
#import "pracScientific.h"
#import "NewsSchoolViewController.h"
#import "PracTabBarVC.h"
#import "StuTabBarVC.h"
#import "ZFQTeacherEditController.h"
#import "ZFQTeacherInfoController.h"
#import "ZFQTeacherHomeController.h"
#import "ZFQGeneralService.h"
#import "LoginViewController.h"
#import "ZFQAdminHomeController.h"
#import "SVProgressHUD.h"

@interface ViewController () <UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:11/255.0 green:81/255.0 blue:144/255.0 alpha:1.0]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"设置入口" HighegIcon:@"设置入口-press" Target:self action:@selector(showActionSheet:forEvent:)];
    
    self.view.backgroundColor = [UIColor colorWithRed:62/255.0 green:170/255.0 blue:217/255.0 alpha:1.0];

}
-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:nil];
    
    NSString *accessId = [ZFQGeneralService accessId];
    if (accessId == nil || [accessId isEqualToString:@""] || [accessId isKindOfClass:[NSNull class]]) {
        //表示未登陆
        [actionSheet destructiveButtonWithTitle:@"注册登录" block:^{
            LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^(NSInteger loginType) {
                if (loginType == 2) {
                    ZFQAdminHomeController *adminVC = [[ZFQAdminHomeController alloc] init];
                    [self.navigationController pushViewController:adminVC animated:YES];
                }
            }];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }];
        
        [actionSheet addButtonWithTitle:@"修改个人资料" block:^{
            NSLog(@"pushed hoge1 button");
            
            
        }];
        [actionSheet addButtonWithTitle:@"应用设置" block:^{
            NSLog(@"pushed hoge2 button");
            
        }];

    } else {
        [actionSheet addButtonWithTitle:@"注销登录" block:^{
            [ZFQGeneralService logout];
            [SVProgressHUD showSuccessWithStatus:@"注销成功"];
        }];
    }
    
    
    actionSheet.cornerRadius = 5;
    
    [actionSheet showWithTouch:event];
}

//实践教学模块
- (IBAction)PracTeaching:(id)sender {
    
    PracTabBarVC *stuTabBarVC = [[PracTabBarVC alloc] init];
    stuTabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:stuTabBarVC animated:YES completion:nil];
}

//教师信息模块
- (IBAction)teachersInfo:(id)sender
{
    NSString *accessId = [ZFQGeneralService accessId];
    if (accessId == nil || [accessId isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有登录，请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 457;
        [alertView show];
    } else {
        ZFQTeacherHomeController *homeVC = [[ZFQTeacherHomeController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}

//学生信息模块
- (IBAction)studentsInfo:(id)sender {
    
    StuTabBarVC *stuTabBarVC = [[StuTabBarVC alloc] init];
    stuTabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:stuTabBarVC animated:YES completion:nil];
}

//校园新闻
- (IBAction)newsOfScholl:(id)sender {
    NewsSchoolViewController *newsVc = [[NewsSchoolViewController alloc] init];
    [self.navigationController pushViewController:newsVc animated:YES];
    
}

//实验室信息
- (IBAction)laboratoryInfo:(id)sender {
    
}

//学术资源
- (IBAction)scholarismResource:(id)sender {
}

#pragma mark - UIAletView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 457) {
        //登录
        LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^(NSInteger loginType){
            if (loginType == 2) {
                ZFQAdminHomeController *adminVC = [[ZFQAdminHomeController alloc] init];
                [self.navigationController pushViewController:adminVC animated:YES];
            }
        }];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
   
}
@end
