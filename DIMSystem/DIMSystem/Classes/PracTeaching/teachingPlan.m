//
//  PracMyKeYan.m
//  DIMSystem
//
//  Created by qingyun on 15/4/16.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "teachingPlan.h"
#import "WDGeneralService.h"
#import "WDDocumentCellTableViewCell.h"
#import "WDDocument.h"

#import <QuickLook/QuickLook.h>

NSString * const wdDocCellID = @"zfqDocCellID";


@interface teachingPlan ()<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource>

@property (nonatomic,strong) NSMutableArray *docs;

@end

@implementation teachingPlan

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"培养计划";
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    //注册cell
    [_myTableView registerClass:[WDDocumentCellTableViewCell class] forCellReuseIdentifier:wdDocCellID];
    
    //加载数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WDDocs" ofType:@"json"];
    NSData *datas = [NSData dataWithContentsOfFile:filePath];
    _docs = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableContainers error:NULL];
    
    [WDGeneralService documentsDirectory];
}

#pragma mark - tableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _docs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDDocumentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:wdDocCellID];
    [cell bindModel:[[WDDocument alloc] initWithDocInfo:_docs[indexPath.row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    [self.navigationController pushViewController:previewController animated:YES];
}

//#pragma mark - QLPreviewDatasource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSDictionary *dic = _docs[_myTableView.indexPathForSelectedRow.row];
    return [[WDDocument alloc] initWithDocInfo:dic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
