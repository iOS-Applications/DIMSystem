//
//  StuProjectVC.m
//  DIMSystem
//
//  Created by qingyun on 15/4/7.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "StuProjectVC.h"
#import "StuProjectClassCell.h"
#import "DMStudent.h"
#import "DMStudentCell.h"
#import "DMStuProject.h"
#import "MJExtension.h"
#import "ProjectHeaderView.h"
#import "StuActionVC.h"

@interface StuProjectVC ()
/**
 *  项目数组
 */
@property (nonatomic,strong) NSArray *projectsArray;

/**
 *  参与项目的学生数组
 */
@property (nonatomic,strong) NSMutableArray *stuCountArray;

/**
 *  标识每个section Button的状态
 */
@property (nonatomic,strong) NSMutableArray *statesArray;

@end

@implementation StuProjectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加left按钮返回
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_press"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"DMStudentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"student"];
    
    //注册项目类别cell
    [self.tableView registerNib:[UINib nibWithNibName:@"StuProjectClassCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"projectClassCell"];
    //注册headerView
    [self.tableView registerNib:[UINib nibWithNibName:@"ProjectHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"headerView"];
    
    //加载数据源
    [self loadProjectsInfo];
    
}

//懒加载
- (NSArray *)projectsArray
{
    if (_projectsArray == nil) {
        _projectsArray = [NSArray array];
    }
    return _projectsArray;
}
- (NSMutableArray *)stuCountArray
{
    if (_stuCountArray == nil) {
        _stuCountArray = [NSMutableArray array];
    }
    return _stuCountArray;
}
- (NSMutableArray *)statesArray
{
    if (_statesArray == nil) {
        _statesArray = [NSMutableArray array];
    }
    return _statesArray;
}

#pragma mark //返回按钮点击事件
- (void)backToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    return self.projectsArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section >= 1) {
        NSInteger stuNum = [self.stuCountArray[section - 1] integerValue];
        return stuNum;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        StuProjectClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectClassCell" forIndexPath:indexPath];
        return cell;
    }
    
    DMStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"student" forIndexPath:indexPath];
    DMStuProject *project = self.projectsArray[indexPath.section - 1];
    DMStudent *student = project.pro_stu[indexPath.row];
    [cell setValuesWithStudnet:student];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }else {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section >= 1) {
        return 50;
    }else {
        return 0;
    }
}

/**
 *  自定义headerView
 */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section >= 1) {
        DMStuProject *project = self.projectsArray[section - 1];
        ProjectHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        
        //取出button的state判断用哪张图标 当self.tableView reloadData 时候 调用该方法le
        NSInteger currentState = [self.statesArray[section - 1] integerValue];
        if (currentState) {
            [headerView.headerButton setImage:[UIImage imageNamed:@"project_down"] forState:UIControlStateNormal];
        } else {
            [headerView.headerButton setImage:[UIImage imageNamed:@"project_left"] forState:UIControlStateNormal];
        }
        [headerView.headerButton setTitle:project.PraPrj_title forState:UIControlStateNormal];
        //**************************//想到了button的其他传参方式
        headerView.headerButton.titleLabel.tag = section;
        
        [headerView.headerButton addTarget:self action:@selector(showStudents:) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
    }else {
        return nil;
    }

}
#pragma mark //headerView 点击事件
- (void)showStudents:(UIButton *)button
{
    NSInteger currentSection = button.titleLabel.tag - 1;
    
    NSInteger state = [self.statesArray[currentSection] integerValue];
    
    if (state) {//收起
        //获取当前section下标
        [self.stuCountArray replaceObjectAtIndex:currentSection withObject:@(0)];
        [self.statesArray replaceObjectAtIndex:currentSection withObject:@(0)];
        [self.tableView reloadData];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //放在前面刷新后就不会显示效果了
//            [button setImage:[UIImage imageNamed:@"project_left"] forState:UIControlStateNormal];
//        });

    }else{
        
        //获得当前section对应项目的学生个数
        DMStuProject *project = self.projectsArray[currentSection];
        NSInteger stuNum = project.pro_stu.count;
        [self.stuCountArray replaceObjectAtIndex:currentSection withObject:@(stuNum)];
        [self.statesArray replaceObjectAtIndex:currentSection withObject:@(1)];
        
        [self.tableView reloadData];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //放在前面刷新后就不会显示效果了
//            [button setImage:[UIImage imageNamed:@"project_down"] forState:UIControlStateNormal];
//        });
        
    }
}

#pragma mark //cell的点击事件 弹出选择框
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ;
    }
    //取出模型数据
    DMStuProject *project = self.projectsArray[indexPath.section - 1];
    DMStudent *student = project.pro_stu[indexPath.row];
    StuActionVC *actionVC = [[StuActionVC alloc] init];
    actionVC.studnet = student;
    actionVC.addButton.hidden = YES;
    [self.navigationController pushViewController:actionVC animated:YES];
    
}

#pragma mark //加载数据源
- (void)loadProjectsInfo
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Projects" withExtension:@"json"];
    NSData *stuData = [NSData dataWithContentsOfURL:url];
    
    //JSON 解析
    NSError *error;
    NSDictionary *stuInfo = [NSJSONSerialization JSONObjectWithData:stuData options:0 error:&error];
    NSArray *proDicArray = stuInfo[@"data"];
    
    //将字典数组转化成模型数组
    
    NSArray *sourceArray = [DMStuProject objectArrayWithKeyValuesArray:proDicArray];
    
    //传递模型数组
    self.projectsArray = sourceArray;
    
    for (int i = 0 ; i < sourceArray.count ; i ++) {
        [self.stuCountArray addObject:@(0)];
        [self.statesArray addObject:@(0)];
    }
    
    [self.tableView reloadData];
    
}

@end
