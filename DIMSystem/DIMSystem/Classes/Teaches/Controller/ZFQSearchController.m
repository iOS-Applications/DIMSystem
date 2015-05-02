//
//  ZFQSearchController.m
//  DIMSystem
//
//  Created by wecash on 15/4/29.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQSearchController.h"
#import "ZFQTeacherInfoController.h"

NSString * const zfqSearchCellID = @"cell";

/*
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
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    //发起请求
//    NSArray *arrray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:<#(NSURL *)#>] options:<#(NSJSONReadingOptions)#> error:<#(NSError *__autoreleasing *)#>]
    [self.resultTableView reloadData];
}
*/

@implementation ZFQSearchController

- (instancetype)initWithSearchDisplayController:(UISearchDisplayController *)searchDisplayController
                                   didSelectRow:(void (^)(UITableView *tableView , NSIndexPath *indexPath))didSelectRow
{
    self = [super init];
    if (self) {
        self.didSelectRow = didSelectRow;
        mySearchDisplayController = searchDisplayController;
        mySearchDisplayController.delegate = self;
        mySearchDisplayController.searchResultsDataSource = self;
        mySearchDisplayController.searchResultsDelegate = self;
        mySearchDisplayController.searchBar.delegate = self;
    }
    return self;
}

- (instancetype)initWithDidSelectRow:(void (^)(UITableView *tableView , NSIndexPath *indexPath))didSelectRow
{
    self = [super init];
    if (self) {
        self.didSelectRow = didSelectRow;
    }
    return self;
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zfqSearchCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zfqSearchCellID];
    }
//    NSDictionary *dic = [self results][indexPath.row];
//    cell.textLabel.text = dic[@"name"];
    cell.textLabel.text = @"aa";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRow) {
        self.didSelectRow(tableView,indexPath);
    }
}

#pragma mark - UISearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //开始请求 及显示等待动画
    
    //刷新数据
    [mySearchDisplayController.searchResultsTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //取消请求 及等待动画
}
- (void)dealloc
{
    NSLog(@"release search");
}

@end







