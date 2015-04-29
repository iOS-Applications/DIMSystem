//
//  ZFQSearchController.m
//  DIMSystem
//
//  Created by wecash on 15/4/29.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQSearchController.h"

NSString * const zfqSearchCellID = @"cell";

@interface ZFQSearchController() <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat width;
    CGFloat height;
    UIViewController *contentController;
}
@property (nonatomic,strong) NSMutableArray *results;
@end
@implementation ZFQSearchController



- (instancetype)initWithController:(UIViewController *)controller searchBar:(UISearchBar *)searchBar
{
    self = [super init];
    if (self) {
        width = controller.view.frame.size.width;
        height = controller.view.frame.size.height;
        
//        UIViewController * __weak weakController = contentController;
//        UIViewController * __strong strongController = weakController;
        contentController = controller;
        searchBar.delegate = self;
        //添加键盘观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarFrameDidChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    return self;
}

- (UITableView *)resultTableView
{
    if (_resultTableView == nil) {
        CGRect resultFrame = CGRectMake(0, 64, width, height - 64 - 210);
        _resultTableView = [[UITableView alloc] initWithFrame:resultFrame style:UITableViewStylePlain];
        _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _resultTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _resultTableView.tag = 123;
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        //设置tableViewfooterView,为了让内容可见
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
//        _resultTableView.tableFooterView = footerView;
    }
    return _resultTableView;
}

- (NSMutableArray *)results
{
    if (_results == nil) {
        _results = [[NSMutableArray alloc] init];
    }
    
    return _results;
}

- (void)keyboarFrameDidChanged:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    CGRect originFrame = _resultTableView.frame;
    originFrame.size.height = height - 64 - keyboardHeight;
    _resultTableView.frame = originFrame;
}
#pragma mark - searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //隐藏导航栏
    [contentController.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    //添加搜索结果视图
    if (self.resultTableView.superview == nil) {
        [contentController.view addSubview:self.resultTableView];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [contentController.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar endEditing:YES];
    
    //remove resultTableView
    [self.resultTableView removeFromSuperview];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSArray *array = @[
                       @{
                           @"name":@"张三",
                           @"idNum":@"401106"
                        },
                       @{
                           @"name":@"李四",
                           @"idNum":@"401107"
                        },
                       @{
                           @"name":@"王二",
                           @"idNum":@"401109"
                        },
                       @{
                           @"name":@"麻子",
                           @"idNum":@"401110"
                        },
                       @{
                           @"name":@"哈哈",
                           @"idNum":@"401111"
                           }
                       ];
    
    self.results = [array copy];
    //发起请求
//    NSArray *arrray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:<#(NSURL *)#>] options:<#(NSJSONReadingOptions)#> error:<#(NSError *__autoreleasing *)#>]
    [self.resultTableView reloadData];
}
#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self results].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zfqSearchCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zfqSearchCellID];
    }
    NSDictionary *dic = [self results][indexPath.row];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中");
}

- (void)dealloc
{
    NSLog(@"realse search");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}
@end




