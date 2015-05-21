//
//  ZFQDocumentsController.m
//  DIMSystem
//
//  Created by wecash on 15/4/30.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQDocumentsController.h"
#import "ZFQDocumentCell.h"
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

@interface ZFQDocumentsController () <UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *docs;     //保存文档信息list
    NSInteger deleteRow;   //要删除的行的索引
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
    [_myTableView registerClass:[ZFQDocumentCell class] forCellReuseIdentifier:zfqDocCellID];
    
    //加载数据
    ZFQDocumentsController * __weak weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [Reachability isReachableWithHostName:kHost complition:^(BOOL isReachable) {
        if (1) {  //isReachable
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *getURL = [kHost stringByAppendingString:@"/teacherDocs"];
            NSDictionary *param = @{@"idNum":[ZFQGeneralService accessId]};  //[ZFQGeneralService accessId]
            [manager GET:getURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dic = responseObject;
                NSNumber *status = dic[@"status"];
                if (status.integerValue == 200) {
                    docs = [[NSMutableArray alloc] initWithArray:dic[@"files"]];
                    if (docs.count == 0) {
                        [weakSelf showPlaceHolderView];
                    }
                    [weakSelf.myTableView reloadData];
                    [SVProgressHUD dismiss];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    }];
    
    //打印document路径
    [ZFQGeneralService documentsDirectory];
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
    ZFQDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:zfqDocCellID];
    [cell bindModel:[[ZFQDocument alloc] initWithDocInfo:docs[indexPath.row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //先判断本地是否有这个文件，
    
    //没有就去下载
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = docs[_myTableView.indexPathForSelectedRow.row];
    ZFQDocument *doc = [[ZFQDocument alloc] initWithDocInfo:dic];

    //获取当前cell
    ZFQDocumentCell *cell = (ZFQDocumentCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isExist) {
        if ([QLPreviewController canPreviewItem:doc]) {
            [self.navigationController pushViewController:previewController animated:YES];
            return;
        } else {
            [SVProgressHUD showErrorWithStatus:@"不支持的文件类型"];
            return;
        }
    }

    //去下载
    NSDictionary *docInfo = docs[indexPath.row];
    NSString *fileName = docInfo[@"file_name"];
    NSString *idNum = [ZFQGeneralService accessId];
    
    [Reachability isReachableWithHostName:kHost complition:^(BOOL isReachable) {
        if (reachable(isReachable)) {  //isReachable
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/downloadTeacherDocs?idNum=%@&fileName=%@",kHost,idNum,fileName];
            NSString *encodingStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:encodingStr];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPMethod:@"GET"];
            [request setTimeoutInterval:30];
            [request setValue:@"utf-8" forHTTPHeaderField:@"Accept-Encoding"];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            //获取要写的文件路径
            NSString *destPath = [ZFQGeneralService docFilePathWithName:fileName];
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:destPath append:NO];
            
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                //设置进度
                CGFloat progress = totalBytesRead/(CGFloat)totalBytesExpectedToRead;
                [cell settingProgress:progress];
            }];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                    [SVProgressHUD showSuccessWithStatus:@"下载成功"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"下载失败"];
            }];
            [operation start];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    }];     //end Reachability
        

}

#pragma mark 滑动删除代理
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleteRow = indexPath.row;
    NSString *title = @"确定删除?会连同删除服务器端的文件";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:deleteRow inSection:0];
    
    if (buttonIndex == 0) {
        NSDictionary *docInfo = docs[indexPath.row];
        NSString *fileName = docInfo[@"file_name"];
        
        //设置cell状态
        ZFQDocumentCell *cell = (ZFQDocumentCell *)[_myTableView cellForRowAtIndexPath:indexPath];
        [cell setttingAlert:@"正在删除"];

        //先从服务器端删除
        ZFQDocumentsController * __weak weakSelf = self;
        
        NSString *postURL = [kHost stringByAppendingString:@"/deleteTeacherDocs"];
        NSDictionary *param = @{@"idNum":[ZFQGeneralService accessId],@"fileName":fileName};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:postURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            NSNumber *status = dic[@"status"];
            if (status.integerValue == 200) {
                [ZFQGeneralService deleteDocWithName:fileName];
                //删除cell
                [docs removeObjectAtIndex:deleteRow];
                [weakSelf.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                //把本地数据删除
                [ZFQGeneralService deleteDocWithName:fileName];
                [SVProgressHUD showSuccessWithStatus:@"已成功删除"];
            }else {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }];
        
    }
}

#pragma mark - QLPreviewDatasource
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

#pragma mark - 处理共享文件
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
