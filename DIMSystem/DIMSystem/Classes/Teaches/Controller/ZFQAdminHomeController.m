//
//  ZFQAdminHomeController.m
//  DIMSystem
//
//  Created by wecash on 15/5/15.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQAdminHomeController.h"
#import "ZFQAddTeacherController.h"
#import "ZFQTeachersController.h"
#import "ZFQMecroDefine.h"

NSString * const zfqAdminCellID = @"cell";

@interface ZFQAdminHomeController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZFQAdminHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"管理员";
    
    //添加tableView
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    //注册tableViewCell
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:zfqAdminCellID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kZFQDelNotification object:nil];
    
}

#pragma mark - tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zfqAdminCellID];
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"添加教师信息";
            } 
            break;
        }
        case 1: {
            cell.textLabel.text = @"删除教师信息";
            break;
        }
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZFQAddTeacherController *addVC = [[ZFQAddTeacherController alloc] init];
        [self.navigationController pushViewController:addVC animated:YES];
    } else if (indexPath.section == 1) {
        ZFQTeachersController *teachersVC = [[ZFQTeachersController alloc] init];
        teachersVC.showDeleteItem = YES;
        
//        NSNotification *notification = [NSNotification notificationWithName:kZFQDelNotification object:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//
        
        [self.navigationController pushViewController:teachersVC animated:YES];
//        ZFQTeacherInfoController *infoVC = [[ZFQTeacherInfoController alloc] init];
//        infoVC.showDeleteItem = YES;
//        infoVC.showEditItem = NO;
//        infoVC.idNum =
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
