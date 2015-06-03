//
//  ZFQTeachersController.h
//  DIMSystem
//
//  Created by wecash on 15/4/23.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFQTeachersController : UIViewController 

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic) BOOL showDeleteItem;                  //是否显示删除按钮 默认是NO
@property (nonatomic,strong) UIColor *searchBarBcgColor;    //搜索框背景色 默认是nil

@end
