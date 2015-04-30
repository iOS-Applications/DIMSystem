//
//  ZFQDocumentsController.m
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQDocumentsController.h"
#import "ZFQDocumentCellTableViewCell.h"
#import "ZFQDocument.h"

NSString * const zfqDocCellID = @"zfqDocCellID";

@interface ZFQDocumentsController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *docs;     //保存文档信息list
}
@end

@implementation ZFQDocumentsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    //注册cell
    [_myTableView registerClass:[ZFQDocumentCellTableViewCell class] forCellReuseIdentifier:zfqDocCellID];
    
    //加载数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ZFQDocs" ofType:@"json"];
    NSData *datas = [NSData dataWithContentsOfFile:filePath];
    docs = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableContainers error:NULL];
}

#pragma mark - tableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFQDocumentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zfqDocCellID];
    [cell bindModel:[[ZFQDocument alloc] initWithDocInfo:docs[indexPath.row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
