//
//  ZFQTeacherViewController.h
//  DIMSystem
//
//  Created by wecash on 15/4/7.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//


#import <UIKit/UIKit.h>
@class DropDownListView;

@interface ZFQTeacherEditController : UIViewController
{
    UITextField *nameTextField;
    DropDownListView *genderDropListView;
    UITextField *teacherIDTextField;
    UITextField *mobileTextField;
    UITextField *qqTextField;
    UITextField *emailTextField;
    DropDownListView *departmentListView;
    DropDownListView *jobListView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic,strong) NSDictionary *teacherInfo;
//修改数据成功后的回调
@property (nonatomic,copy) void (^completionBlk)(NSDictionary *teacherInfo);


@end
