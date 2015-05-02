//
//  SVProgressHUD+ZFQCustom.h
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (ZFQCustom)

+ (void)showZFQHUDWithStatus:(NSString *)status;
+ (void)showZFQErrorWithStatus:(NSString *)string;

@end
