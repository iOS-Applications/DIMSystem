//
//  LoginViewController.h
//  DIMSystem
//
//  Created by wecash on 15/5/2.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet DLRadioButton *teacherBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPsdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)tapLoginAction:(id)sender;
- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender;

- (IBAction)dismissLoginViewController:(UIBarButtonItem *)sender;

- (instancetype)initWithLoginSuccessBlock:(void (^)(NSInteger loginType))successBlk;

@end
