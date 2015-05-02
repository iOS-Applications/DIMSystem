//
//  ZFQTeacherInfoController.h
//  DIMSystem
//
//  Created by wecash on 15/4/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFQTeacherInfoController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic,strong,readonly) NSMutableDictionary *teacherInfo;

@property (nonatomic) BOOL showEditItem;      //是否显示编辑按钮，默认是YES
@property (nonatomic) NSString *idNum;        //教工号,

@end