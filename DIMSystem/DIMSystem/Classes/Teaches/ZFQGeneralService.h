//
//  ZFQGeneralService.h
//  DIMSystem
//
//  Created by wecash on 15/4/9.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZFQGeneralService : NSObject

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

+ (NSString *)docFilePathWithName:(NSString *)docName;  //返回文件的路径，如果文件不存在，返回nil
+ (BOOL)deleteDocWithName:(NSString *)docName;

//--------获取accessId,用来判断是否登陆------
+ (NSString *)accessId;

@end
