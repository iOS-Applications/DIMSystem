//
//  ZFQSearchController.h
//  DIMSystem
//
//  Created by wecash on 15/4/29.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZFQSearchController : NSObject <UISearchBarDelegate>

@property (nonatomic,strong) UITableView *resultTableView;

- (instancetype)initWithController:(UIViewController *)controller;
- (instancetype)initWithController:(UIViewController *)controller searchBar:(UISearchBar *)searchBar;

@end
