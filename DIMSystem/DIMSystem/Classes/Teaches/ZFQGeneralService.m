//
//  ZFQGeneralService.m
//  DIMSystem
//
//  Created by wecash on 15/4/9.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQGeneralService.h"
#import "ZFQMecroDefine.h"
#import "commenConst.h"

@implementation ZFQGeneralService

+ (UILabel *)labelWithTitle:(NSString *)title
{
    return [[self class] labelWithTitle:title fontSize:17];
}

+ (UILabel *)labelWithTitle:(NSString *)title fontSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:size];
    [label sizeToFit];
    
    CGRect originFrame = label.frame;
    originFrame.size = CGSizeMake(originFrame.size.width, originFrame.size.height);
    label.frame = originFrame;
    
    return label;
}

+ (UILabel *)underLineLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:17];
    [label sizeToFit];
    
    CGRect originFrame = label.frame;
    originFrame.size = CGSizeMake(originFrame.size.width, originFrame.size.height);
    label.frame = originFrame;
    
    //添加下划线
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, originFrame.size.height - 1, originFrame.size.width, 1)];
    underLine.backgroundColor = [UIColor lightGrayColor];
    [label addSubview:underLine];
    
    return label;
}

+ (UILabel *)underLineLabelWithTitle:(NSString *)title width:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentLeft;
    
    [label sizeToFit];
    CGRect originFrame = label.frame;
    if (width < originFrame.size.width) {
        width = originFrame.size.width;
    }
    originFrame.size = CGSizeMake(width, 30);
    label.frame = originFrame;
    
    //添加下划线
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, originFrame.size.height - 1, originFrame.size.width, 1)];
    underLine.backgroundColor = [UIColor lightGrayColor];
    [label addSubview:underLine];
    
    return label;
}
//-------------------------------------------

+ (UITextField *)textFieldWithWidth:(CGFloat)width
{
    CGFloat textFieldHeight = 30;
    UITextField *textField = [[UITextField alloc] init];
    [[self class] setRoundCornerRadiusForView:textField];
    textField.frame = CGRectMake(0, 0, width, textFieldHeight);
    
    return textField;
}

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder width:(CGFloat)width
{
    CGFloat textFieldHeight = 30;
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(0, 0, width, 30);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSDictionary *attrDic = @{
                              NSFontAttributeName:[UIFont systemFontOfSize:14],
                              NSForegroundColorAttributeName:ZFQ_BorderColor
                              };
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:placeholder attributes:attrDic];
    textField.attributedPlaceholder = attrStr;
    
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, textFieldHeight - 1, width, 1)];
    underLine.backgroundColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:0.6];
    [textField addSubview:underLine];
    return textField;
}

+ (void)showEmotionOnView:(UIView *)view emotion:(NSString *)emotion title:(NSString *)title
{
    EmotionView  *emotionView = [[EmotionView alloc] init];
    [view addSubview:emotionView];
    
    emotionView.hidden = NO;
    emotionView.emotionStr = emotion;
    emotionView.title = title;
    
    emotionView.center = CGPointMake(ZFQ_ScreenWidth/2, (ZFQ_ScreenHeight - emotionView.frame.size.height)/2.0f);
}

+ (void)setRoundCornerRadiusForView:(UIView *)view
{
    view.layer.borderWidth = ZFQ_BorderWidth;
    view.layer.cornerRadius = ZFQ_CornerRadius;
    view.layer.borderColor = ZFQ_BorderColor.CGColor;
}

+ (NSString *)avatarURLString
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documentPath = [self documentURLString];
    NSString *avatarPath = [documentPath stringByAppendingPathComponent:@"avatar"];
    BOOL isDir = NO;
    BOOL isExisted = [manager fileExistsAtPath:avatarPath isDirectory:&isDir];
    if (!(isDir && isExisted)) {
        [manager createDirectoryAtPath:avatarPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return avatarPath;
}

//doc文件夹 ，不存在会创建
+ (NSString *)docDirPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *docDirPath = [[self documentURLString] stringByAppendingPathComponent:@"doc"];
    BOOL isDir = NO;
    BOOL result = [manager fileExistsAtPath:docDirPath isDirectory:&isDir];
    if (result == NO) {
        //创建doc文件夹
        result = [manager createDirectoryAtPath:docDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (result == YES) {
            return docDirPath;
        } else {
            return nil;
        }
    } else {
        return docDirPath;
    }

}

+ (NSString *)documentURLString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    return documentPath;
}

// 程序启动时运行
+ (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSLog(@"Documents directory%@", documentsDirectory);
    return documentsDirectory;
}

//获取doc文件夹下的文件的路径，如果doc文件夹不存在，会自动创建
+ (NSString *)docFilePathWithName:(NSString *)docName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *idNumDirPath = [self idNumPath];
    if (idNumDirPath == nil) {
        return nil;
    }
    NSString *docDirPath = [idNumDirPath stringByAppendingPathComponent:@"doc"];
    BOOL isDir = NO;
    BOOL result = [manager fileExistsAtPath:docDirPath isDirectory:&isDir];
    if (result == NO) {
        //创建文件夹
        result = [manager createDirectoryAtPath:docDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (result == YES) {
            //拼接字符串
            return [docDirPath stringByAppendingPathComponent:docName];
        } else {
            return nil;
        }
    } else {
        return [docDirPath stringByAppendingPathComponent:docName];
    }
}

+ (BOOL)docFileIsExist:(NSString *)docName
{
    NSString *docFilePath = [self docFilePathWithName:docName];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL result = [manager fileExistsAtPath:docFilePath isDirectory:&isDir];
    if (result == YES && isDir == NO) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)idNumPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *idDirPath = [[self documentURLString] stringByAppendingPathComponent:[ZFQGeneralService accessId]];
    BOOL isDir = NO;
    BOOL result = [manager fileExistsAtPath:idDirPath isDirectory:&isDir];
    if (result == NO) {
        //创建文件夹
        result = [manager createDirectoryAtPath:idDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (result == YES) {
            //拼接字符串
            return idDirPath;
        } else {
            return nil;
        }
    } else {
        return idDirPath;
    }
}

+ (UIImage *)avatarFileWithName:(NSString *)idNumName
{
    if (idNumName == nil || [idNumName isEqualToString:@""]) {
        return nil;
    }
    NSString *idNumPath = [[self idNumPath] stringByAppendingPathComponent:@"avatar"];
    BOOL isDir = NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:idNumPath isDirectory:&isDir] && isDir) {
        //获取idNum文件夹下第一个文件
        NSError* error = nil;
        NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:idNumPath
                                                                             error:&error];
        for (NSString *path in files) {
            if ([path rangeOfString:idNumName].length > 0 ) {
                NSString *imgPath = [idNumPath stringByAppendingPathComponent:path];
                UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
                if (img != nil)
                {
                    return img;
                }
            }
        }
//        if (error == nil)
//        {
//            if (files.count > 0)
//            {
//                NSString *path = files[0];
//                NSString *imgPath = [idNumPath stringByAppendingPathComponent:path];
//                UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
//                if (img != nil)
//                {
//                    return img;
//                }
//            }
//            
//        }
    }
    return nil;
}

+ (NSString *)avatarPathWithName:(NSString *)idNum
{
    if (idNum == nil || [idNum isEqualToString:@""]) {
        return nil;
    }
    NSString *idNumPath = [[self idNumPath] stringByAppendingPathComponent:@"avatar"];
    //创建idNum文件夹
    BOOL isDir = NO;
    NSString *avatarPath = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:idNumPath isDirectory:&isDir]) {
        if (isDir) {
            //在文件夹idNum创建名为idNum的文件
            NSString *avatarName = [idNum stringByAppendingString:@".png"];
            avatarPath = [idNumPath stringByAppendingPathComponent:avatarName];

            BOOL result = [manager createFileAtPath:avatarPath contents:nil attributes:nil];
            if (result == NO) {
                avatarPath = nil;
            }
        } else {
            //创建idNum文件夹
            BOOL result = [manager createDirectoryAtPath:idNumPath withIntermediateDirectories:NO attributes:nil error:nil];
            if (result == YES) {
                //在文件夹idNum创建名为idNum的文件
                NSString *avatarName = [idNum stringByAppendingString:@".png"];
                avatarPath = [idNumPath stringByAppendingPathComponent:avatarName];

                result = [manager createFileAtPath:avatarPath contents:nil attributes:nil];
                if (result == NO) {
                    avatarPath = nil;
                }
            }
        }
    } else {
        //创建idNum文件夹
        BOOL result = [manager createDirectoryAtPath:idNumPath withIntermediateDirectories:NO attributes:nil error:nil];
        if (result == YES) {
            //在文件夹idNum创建名为idNum的文件
            NSString *avatarName = [idNum stringByAppendingString:@".png"];
            avatarPath = [idNumPath stringByAppendingPathComponent:avatarName];
            result = [manager createFileAtPath:avatarPath contents:nil attributes:nil];
            if (result == NO) {
                avatarPath = nil;
            }
        }
    }
    return avatarPath;
}

+ (BOOL)deleteDocWithName:(NSString *)docName
{
    NSString *filePath = [self docFilePathWithName:docName];
    if (filePath != nil) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *error;
        BOOL result = [manager removeItemAtPath:filePath error:&error];
        return  result;
    } else {
        return YES;
    }
}

+ (NSString *)accessId
{
    NSString *accessId = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessId];
    return accessId;
}

+ (void)logout
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kAccessId];
}
@end
