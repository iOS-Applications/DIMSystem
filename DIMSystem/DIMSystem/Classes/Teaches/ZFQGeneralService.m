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
    underLine.backgroundColor = [UIColor lightGrayColor];
    [textField addSubview:underLine];
    return textField;
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

+ (NSString *)accessId
{
    NSString *accessId = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessId];
    return accessId;
}
@end
