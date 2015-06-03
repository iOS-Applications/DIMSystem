//
//  ZFQSearchController.h
//  DIMSystem
//
//  Created by wecash on 15/4/29.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZFQSearchController : NSObject <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchDisplayController *mySearchDisplayController;
    NSArray *results;
}

@property (nonatomic,copy) void (^didSelectRow)(UITableView *tableView , NSIndexPath *indexPath,NSString *idNum);
@property (nonatomic,strong) UIColor *searchBarBcgColor;    //搜索框背景色 默认是nil


- (instancetype)initWithSearchDisplayController:(UISearchDisplayController *)searchDisplayController
                                   didSelectRow:(void (^)(UITableView *tableView , NSIndexPath *indexPath, NSString *idNum))didSelectRow;

@end