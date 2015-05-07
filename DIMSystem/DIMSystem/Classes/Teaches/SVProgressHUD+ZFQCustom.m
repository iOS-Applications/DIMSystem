//
//  SVProgressHUD+ZFQCustom.m
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "SVProgressHUD+ZFQCustom.h"

@implementation SVProgressHUD (ZFQCustom)

+ (void)showZFQHUDWithStatus:(NSString *)status
{
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showZFQErrorWithStatus:(NSString *)string
{
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showErrorWithStatus:string];
}

+ (void)showZFQSuccessWithStatus:(NSString *)string
{
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showSuccessWithStatus:string];
}
@end
