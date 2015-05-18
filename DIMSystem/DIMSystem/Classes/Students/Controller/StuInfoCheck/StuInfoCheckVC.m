//
//  StuInfoCheckVC.m
//  DIMSystem
//
//  Created by qingyun on 15/4/7.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "StuInfoCheckVC.h"
#import "DMStudentCell.h"
#import "MJExtension.h"
#import "DMStudent.h"
#import "StuActionVC.h"

@interface StuInfoCheckVC ()
@end

@implementation StuInfoCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加left按钮返回
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_press"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.view.backgroundColor = [UIColor cyanColor];
    [self loadStudentInfo];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"DMStudentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"student"];
    
//    //添加操作视图
//    StuActionView *actionView = [[NSBundle mainBundle] loadNibNamed:@"StuActionView" owner:nil options:0][0];
//    actionView.bounds = self.tableView.bounds;
//    actionView.hidden = YES;
//    self.actionView = actionView;
//    [self.view addSubview:actionView];

}

/**
 *  懒加载
 */
- (NSArray *)studentsArray
{
    if (_studentsArray == nil) {
        _studentsArray = [NSArray array];
    }
    return _studentsArray;
}

#pragma mark - tabBarController.tabBar重现方法
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.navigationController.viewControllers.count > 1) {
        self.parentViewController.tabBarController.tabBar.hidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    
    if (self.navigationController.viewControllers.count < 2) {
        self.parentViewController.tabBarController.tabBar.hidden = NO;
    }
}

#pragma mark //返回按钮点击事件
- (void)backToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.studentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DMStudentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"student" forIndexPath:indexPath];
    DMStudent *student = self.studentsArray[indexPath.row];
    [cell setValuesWithStudnet:student];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark //cell的点击事件 弹出选择框
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取出模型数据
    DMStudent *student = self.studentsArray[indexPath.row];
    StuActionVC *actionVC = [[StuActionVC alloc] init];
    actionVC.studnet = student;

    [self.navigationController pushViewController:actionVC animated:YES];
}
#pragma mark //加载数据源
- (void)loadStudentInfo
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"StuInfo" withExtension:@"json"];
    NSData *stuData = [NSData dataWithContentsOfURL:url];
    
    //JSON 解析
    NSError *error;
    NSDictionary *stuInfo = [NSJSONSerialization JSONObjectWithData:stuData options:0 error:&error];
    NSArray *stuDicArray = stuInfo[@"data"];
    
    //将字典数组转化成模型数组
    
    NSArray *sourceArray = [DMStudent objectArrayWithKeyValuesArray:stuDicArray];
    
    //传递模型数组
    self.studentsArray = sourceArray;
    
    [self.tableView reloadData];
    
}


@end
