//
//  ZFQTeachersController.m
//  DIMSystem
//
//  Created by wecash on 15/4/23.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQTeachersController.h"
#import "ZFQDepartmentHeaderView.h"

@interface ZFQTeachersController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *folds;   //保存每一个section是否展开的状态,初始值都是YES,表示都是折叠状态
    NSArray *departs; //    
}
@end

@implementation ZFQTeachersController

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
    
    [self.view addSubview:_myTableView];
    
    self.title = @"选择";
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



@end
