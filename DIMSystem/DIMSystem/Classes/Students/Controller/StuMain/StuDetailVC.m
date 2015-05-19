//
//  StuDetailVC.m
//  DIMSystem
//
//  Created by QQ on 15/4/17.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "StuDetailVC.h"
#import "StuDetailCell.h"

@interface StuDetailVC ()
@property (nonatomic, strong) NSArray *keyArray;
@end

@implementation StuDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置返回按钮
#warning TODO
    UITabBarItem *lefItem = [[UITabBarItem alloc] init];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"StuDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StuDetailCell"];
    
}

/**
 *  懒加载
 */
- (NSArray *)keyArray
{
    if (_keyArray == nil) {
        _keyArray = [[NSArray alloc] initWithObjects:@"姓名:", @"学号:", @"年龄:", @"性别:", @"院系:", @"专业:", @"班级:", @"职务:", @"籍贯:", @"电话:", @"邮箱:", @"备注:", nil];
    }
    return _keyArray;
}
#pragma mark //UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StuDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StuDetailCell" forIndexPath:indexPath];
    NSString * keyStr = self.keyArray[indexPath.row];
    
    [cell.keyButton setTitle:keyStr forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark //UITableViewDataSource
@end
