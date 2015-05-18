//
//  ZFQTeacherNameListController.h
//  DIMSystem
//
//  Created by wecash on 15/5/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFQTeacherNameListController : UIViewController

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSString *major;
@property (nonatomic) BOOL showDelItem; //是否显示删除按钮，默认是NO

@end
