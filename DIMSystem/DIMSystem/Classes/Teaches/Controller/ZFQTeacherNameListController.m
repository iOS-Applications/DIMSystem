//
//  ZFQTeacherNameListController.m
//  DIMSystem
//
//  Created by wecash on 15/5/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQTeacherNameListController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "commenConst.h"
#import "ZFQTeacherInfoController.h"
#import "ZFQGeneralService.h"

@interface ZFQTeacherNameListController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *result;
}
@end

@implementation ZFQTeacherNameListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showDelItem = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"教师列表";
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
    [self loadRequest];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_myTableView deselectRowAtIndexPath:_myTableView.indexPathForSelectedRow animated:YES];
}

- (void)loadRequest
{
    NSString *url = [kHost stringByAppendingString:@"/searchTeacherInfoByMajor"];
    NSDictionary *param = @{@"major":self.major};
    
    [SVProgressHUD showWithStatus:@"请稍后..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *status = dic[@"status"];
        if (status.integerValue == 200) {
            result = dic[@"data"];
            if (result.count == 0) {
                _myTableView.hidden = YES;
                [ZFQGeneralService showEmotionOnView:self.view emotion:@"⊙﹏⊙" title:@"无结果"];
                [SVProgressHUD dismiss];
            } else {
                [_myTableView reloadData];
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return result == nil ? 0 : result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = result[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

#pragma mark tableVie delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFQTeacherInfoController *teacherInfo = [[ZFQTeacherInfoController alloc] init];
    teacherInfo.showEditItem = NO;
    teacherInfo.showDeleteItem = self.showDelItem;
    NSDictionary *dic = result[indexPath.row];
    teacherInfo.idNum = dic[@"idNum"];
    
    [self.navigationController pushViewController:teacherInfo animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
