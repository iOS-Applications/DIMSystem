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
#import "ZFQGeneralService.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import <QuickLook/QuickLook.h>
#import "SVProgressHUD+ZFQCustom.h"
#import "commenConst.h"
#import "ZFQMecroDefine.h"
#import "EmotionView.h"

NSString * const zfqDocCellID = @"zfqDocCellID";

@interface ZFQDocumentsController () <UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate> 
{
    NSArray *docs;     //保存文档信息list
}
@end

@implementation ZFQDocumentsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"文档";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    //注册cell
    [_myTableView registerClass:[ZFQDocumentCellTableViewCell class] forCellReuseIdentifier:zfqDocCellID];
    
    //加载数据
    ZFQDocumentsController * __weak weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [Reachability isReachableWithHostName:kHost complition:^(BOOL isReachable) {
        if (isReachable) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *getURL = [kHost stringByAppendingString:@"/teacherDocs"];
            NSDictionary *param = @{@"idNum":[ZFQGeneralService accessId]};
            [manager GET:getURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dic = responseObject;
                NSNumber *status = dic[@"status"];
                if (status.integerValue == 200) {
                    docs = dic[@"files"];
                    if (docs.count == 0) {
                        [weakSelf showPlaceHolderView];
                    }
                    [weakSelf.myTableView reloadData];
                    [SVProgressHUD dismiss];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    }];
    
}

- (void)showPlaceHolderView
{
    _myTableView.hidden = YES;
    [self showEmotionViewWithEmotion:@"⊙﹏⊙" title:@"您还没有教学资料"];
}

- (void)showEmotionViewWithEmotion:(NSString *)emotion title:(NSString *)title
{
    EmotionView  *emotionView = [[EmotionView alloc] init];
    [self.view addSubview:emotionView];
    
    emotionView.hidden = NO;
    emotionView.emotionStr = emotion;
    emotionView.title = title;
    
    emotionView.center = CGPointMake(ZFQ_ScreenWidth/2, (ZFQ_ScreenHeight - emotionView.frame.size.height)/2.0f);
}

#pragma mark - tableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return docs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFQDocumentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zfqDocCellID];
    [cell bindModel:[[ZFQDocument alloc] initWithDocInfo:docs[indexPath.row]]];
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
    previewController.delegate = self;

    NSDictionary *dic = docs[_myTableView.indexPathForSelectedRow.row];
    ZFQDocument *doc = [[ZFQDocument alloc] initWithDocInfo:dic];
    if ([QLPreviewController canPreviewItem:doc]) {
        [self.navigationController pushViewController:previewController animated:YES];
    } else {
        [SVProgressHUD showZFQErrorWithStatus:@"该文件不存在"];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

//#pragma mark - QLPreviewDatasource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSDictionary *dic = docs[_myTableView.indexPathForSelectedRow.row];
    return [[ZFQDocument alloc] initWithDocInfo:dic];
}

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item
{
    ZFQDocument *doc = item;
    if (doc.previewItemURL == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
