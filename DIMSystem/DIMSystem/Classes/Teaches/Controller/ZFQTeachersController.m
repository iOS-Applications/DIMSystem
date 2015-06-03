//
//  ZFQTeachersController.m
//  DIMSystem
//
//  Created by wecash on 15/4/23.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQTeachersController.h"
#import "ZFQDepartmentHeaderView.h"
#import "ZFQMecroDefine.h"
#import "ZFQSearchController.h"
#import "ZFQTeacherInfoController.h"
#import "ZFQGeneralService.h"
#import "ZFQTeacherNameListController.h"

@interface ZFQTeachersController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *folds;   //保存每一个section是否展开的状态,初始值都是YES,表示都是折叠状态
    NSArray *departs;        //
    CGFloat keyboardHeight;
    
    ZFQSearchController *searchResultController;
    
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic,strong) UISearchBar *mySearchBar;

@end

@implementation ZFQTeachersController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showDeleteItem = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化folds
    departs = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZFQDepartInfo" ofType:@"plist"]];
    folds = [NSMutableArray arrayWithCapacity:departs.count];
    for (NSInteger i = 0; i < departs.count; i ++) {
        [folds addObject:@(YES)];
    }
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.sectionHeaderHeight = 44;
    _myTableView.tag = 1012;
    
    //添加searchBar
    _myTableView.tableHeaderView = self.mySearchBar;
    [self.view addSubview:_myTableView];
    
    ZFQTeachersController * __weak weakSelf = self;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.mySearchBar contentsController:self];
    searchResultController = [[ZFQSearchController alloc] initWithSearchDisplayController:searchDisplayController didSelectRow:^(UITableView *tableView, NSIndexPath *indexPath, NSString *idNum) {
        ZFQTeacherInfoController *teacherInfo = [[ZFQTeacherInfoController alloc] init];
        teacherInfo.showEditItem = NO;
        teacherInfo.showDeleteItem = weakSelf.showDeleteItem;
        teacherInfo.idNum = idNum;
        [weakSelf.navigationController pushViewController:teacherInfo animated:YES];
    }];
    
    self.title = @"选择";
    //修改搜索框背景颜色
    if (self.searchBarBcgColor != nil) {
        searchResultController.searchBarBcgColor = self.searchBarBcgColor;
    }
}

- (UIView *)headerView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZFQ_ScreenWidth, 44)];
    [headerView addSubview:self.mySearchBar];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"教师",@"专业"]];
    CGRect frame = segmentedControl.frame;
    frame.size.width = 70;
    segmentedControl.frame = frame;
    frame = segmentedControl.frame;
    segmentedControl.center = CGPointMake(_myTableView.frame.size.width - frame.size.width/2 - 8, 22);
    segmentedControl.selectedSegmentIndex = 0;
    [headerView addSubview:segmentedControl];
    
    //添加分割线
    CGFloat searchBarHeight = _mySearchBar.frame.size.height;
    CGFloat width = headerView.frame.size.width;
    CALayer *separatorLayer = [CALayer layer];
    separatorLayer.bounds = CGRectMake(0, searchBarHeight - 1, width, 1);
    separatorLayer.position = CGPointMake(width/2, searchBarHeight - 0.5);
    separatorLayer.backgroundColor = ZFQ_RGB(214, 214, 214, 1).CGColor;
    [headerView.layer addSublayer:separatorLayer];
    
    return headerView;
}

- (UISearchBar *)mySearchBar
{
    if (_mySearchBar == nil) {
        _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, _myTableView.frame.size.width, 44)];
        _mySearchBar.placeholder = @"输入关键字";
        _mySearchBar.searchBarStyle = UISearchBarStyleMinimal; //UISearchBarStyleProminent UISearchBarStyleMinimal
        _mySearchBar.scopeButtonTitles = @[@"按教师名",@"按专业名"];
        _mySearchBar.showsScopeBar = YES;
        
        //添加分割线
        CGFloat searchBarHeight = _mySearchBar.frame.size.height;
        CGFloat width = _mySearchBar.frame.size.width;
        CALayer *separatorLayer = [CALayer layer];
        separatorLayer.bounds = CGRectMake(0, searchBarHeight - 1, width, 1);
        separatorLayer.position = CGPointMake(width/2, searchBarHeight - 0.5);
        separatorLayer.backgroundColor = ZFQ_RGB(214, 214, 214, 1).CGColor;
        [_mySearchBar.layer addSublayer:separatorLayer];

    }
    return _mySearchBar;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - tableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZFQDepartmentHeaderView *headerView=[ZFQDepartmentHeaderView zfqHeaderViewWithTableView:tableView];
    
    ZFQTeachersController * __weak weakSelf = self;
    headerView.selectCompletionBlk = ^ (ZFQDepartmentHeaderView *zfqHeaderView) {
        ZFQTeachersController * __strong strongSelf = weakSelf;
        //修改fold中的值
        NSNumber *foldState = [strongSelf -> folds objectAtIndex:section];
        if (foldState.boolValue == NO) {
            [strongSelf->folds setObject:@(YES) atIndexedSubscript:section];
            zfqHeaderView.fold = YES;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
            [weakSelf.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [strongSelf->folds setObject:@(NO) atIndexedSubscript:section];
            zfqHeaderView.fold = NO;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
            [weakSelf.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    };
    NSDictionary *dic = departs[section];
    NSString *departName = [dic objectForKey:[NSString stringWithFormat:@"dep%zi",section + 1]];
    headerView.titleString = departName;
    NSNumber *foldState = folds[section];
    headerView.fold = foldState.boolValue;
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return departs.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1012) {
        //查询出相关专业的所有教师
        NSDictionary *dic = departs[indexPath.section];
        NSArray *array = [dic objectForKey:@"list"];
        NSString *major = array[indexPath.row];
        ZFQTeacherNameListController *listVC = [[ZFQTeacherNameListController alloc] init];
        listVC.major = major;
        listVC.showDelItem = self.showDeleteItem;
        [self.navigationController pushViewController:listVC animated:YES];
    } else {
        ZFQTeacherInfoController *teacherInfo = [[ZFQTeacherInfoController alloc] init];
        teacherInfo.showEditItem = NO;
        teacherInfo.showDeleteItem = self.showDeleteItem;
        teacherInfo.idNum = [ZFQGeneralService accessId];
        [self.navigationController pushViewController:teacherInfo animated:YES];
        [self.navigationController setNavigationBarHidden:NO];
    }
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = departs[section];
    NSNumber *sectionNum = folds[section];
    if (sectionNum.integerValue == 1) {
        return 0;
    } else {
        NSArray *array = [dic objectForKey:@"list"];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"a"];
    }
    NSDictionary *dic = departs[indexPath.section];
    NSArray *array = [dic objectForKey:@"list"];
    NSString *major = array[indexPath.row];
    cell.textLabel.text = major;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"realse teachers");
}


@end
