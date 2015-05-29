//
//  StuDetailVC.m
//  DIMSystem
//
//  Created by QQ on 15/4/17.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "StuDetailVC.h"
#import "StuDetailCell.h"
#import "DMStudent.h"

@interface StuDetailVC ()
@property (nonatomic, strong) NSArray *keyArray;
@end

@implementation StuDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.title = @"个人资料";
    //设置返回按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"StuDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"StuDetailCell"];
    
}

#pragma mark //在此页跳转到StuProjectVC界面
- (void)goBack
{
    UIViewController *superVC = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:superVC animated:YES];
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
    DMStudent *student = self.studnet;
    NSString *valueContent = [[NSString alloc] init];
    switch (indexPath.row) {
        case 0:
            valueContent = student.stu_name;
            break;
        case 1:
            valueContent = student.stu_num;
            break;
        case 2:
            valueContent = student.stu_age;
            break;
        case 3:
            valueContent = student.stu_sex;
            break;
        case 4:
            valueContent = student.stu_depart;
            break;
        case 5:
            valueContent = student.stu_major;
            break;
        case 6:
            valueContent = student.stu_class;
            break;
        case 7:
            valueContent = student.stu_post;
            break;
        case 8:
            valueContent = student.stu_address;
            break;
        case 9:
            valueContent = student.stu_phone;
            break;
        case 10:
            valueContent = student.stu_email;
            break;
        case 11:
            valueContent = student.stu_remarks;
            break;
        default:
            break;
    }
    
    [cell.valueButton setTitle:valueContent forState:UIControlStateNormal];
    return cell;
}

#pragma mark //UITableViewDataSource
@end
