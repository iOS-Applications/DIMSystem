//
//  ZFQSearchController.m
//  DIMSystem
//
//  Created by wecash on 15/4/29.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQSearchController.h"
#import "ZFQTeacherInfoController.h"
#import "AFNetworking.h"
#import "commenConst.h"
#import "SVProgressHUD.h"

NSString * const zfqSearchCellID = @"cell";
@interface ZFQSearchController()
{
    AFHTTPRequestOperation *operation;
    NSInteger scopeIndex;
}

@end
@implementation ZFQSearchController

- (instancetype)initWithSearchDisplayController:(UISearchDisplayController *)searchDisplayController
                                   didSelectRow:(void (^)(UITableView *tableView , NSIndexPath *indexPath, NSString *idNum))didSelectRow
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

- (instancetype)initWithDidSelectRow:(void (^)(UITableView *tableView , NSIndexPath *indexPath, NSString *idNum))didSelectRow
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
    return results == nil ? 0 : results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zfqSearchCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:zfqSearchCellID];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    NSDictionary *dic = results[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    cell.detailTextLabel.text = dic[@"major"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRow) {
        NSDictionary *dic = results[indexPath.row];
        NSString *idNum = dic[@"idNum"];
        self.didSelectRow(tableView,indexPath,idNum);
    }
}

#pragma mark - UISearchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //修改颜色
    if (self.searchBarBcgColor != nil) {
        [self settingBcgColor:searchBar];
    }
}

- (void)settingBcgColor:(UIView *)searchBar
{
    NSArray *subViews = searchBar.subviews;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField  *textField = (UITextField *)subView;
            textField.textColor = self.searchBarBcgColor;
            return;
        } else {
            [self settingBcgColor:subView];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    if (key == nil || [key isEqualToString:@""]) {
        return;
    }
    //开始请求 及显示等待动画
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [kHost stringByAppendingString:@"/searchTeacherInfo"];
    NSDictionary *dic = @{@"searchKey":key,@"searchType":@(scopeIndex)};
    operation = [manager GET:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *status = dic[@"status"];
        if (status.integerValue == 200) {
            results = dic[@"data"];
            //刷新数据
            [mySearchDisplayController.searchResultsTableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
 
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //取消请求 及等待动画
    [operation cancel];
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    scopeIndex = selectedScope;
}
- (void)dealloc
{
    NSLog(@"release search");
}

@end







