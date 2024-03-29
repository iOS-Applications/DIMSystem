//
//  ZFQGeneralService.h
//  DIMSystem
//
//  Created by wecash on 15/4/9.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WDGeneralService : NSObject

+ (UILabel *)labelWithTitle:(NSString *)title;
+ (UILabel *)labelWithTitle:(NSString *)title fontSize:(CGFloat)size;
+ (UILabel *)underLineLabelWithTitle:(NSString *)title;     //下划线Label
+ (UILabel *)underLineLabelWithTitle:(NSString *)title width:(CGFloat)width;     //下划线Label

+ (UITextField *)textFieldWithWidth:(CGFloat)width;
+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder width:(CGFloat)width;


+ (void)setRoundCornerRadiusForView:(UIView *)view;

+ (NSString *)avatarURLString;
+ (NSString *)documentURLString;

+ (NSString *)documentsDirectory;

@end
