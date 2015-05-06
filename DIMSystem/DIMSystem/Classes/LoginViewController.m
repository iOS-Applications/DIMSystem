//
//  LoginViewController.m
//  DIMSystem
//
//  Created by wecash on 15/5/2.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapLoginAction:(id)sender
{
    NSString *name = self.userNameTextField.text;
    NSString *psd = self.userNameTextField.text;
    DLRadioButton *currSelectBtn = self.teacherBtn.selectedButton;

    if ([currSelectBtn.currentTitle isEqualToString:@"教师"]) {
        
    } else {
        
    }
    //post请求
    
    //得到结果,保存当前的username到NSUSerDefault
}

- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (IBAction)dismissLoginViewController:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
