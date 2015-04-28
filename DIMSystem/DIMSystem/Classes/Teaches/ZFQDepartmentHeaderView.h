//
//  ZFQDepartmentHeaderView.h
//  
//
//  Created by zfq on 14-10-31.
//  Copyright (c) 2014年 zfq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFQDepartmentHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) NSString *detailString;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic) BOOL fold;
@property (nonatomic,copy) void (^selectCompletionBlk)(ZFQDepartmentHeaderView *zfqHeaderView); //返回值YES,表示折叠，返回NO,表示展开

+ (instancetype)zfqHeaderViewWithTableView:(UITableView *)tableView;

@end
