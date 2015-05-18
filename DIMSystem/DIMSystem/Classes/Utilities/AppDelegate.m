//
//  AppDelegate.m
//  DIMSystem
//
//  Created by qingyun on 15/4/5.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "commenConst.h"
#import "ZFQGeneralService.h"

@interface AppDelegate () <UIAlertViewDelegate>
{
    NSURL *docURL;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设置SVD颜色
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    docURL = url;
    
    NSString *fileName = [url.path pathComponents].lastObject;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否上传" message:fileName delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"立即上传",nil];
    [alertView show];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"请稍后..."];
        //上传
        NSString *urlStr = [kHost stringByAppendingString:@"/uploadTeacherDocs"];
        NSString *idNum = [ZFQGeneralService accessId];
        NSDictionary *param = @{@"idNum":idNum};
    
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST"
                                                                        URLString:urlStr
                                                                       parameters:param
                                                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                            [formData appendPartWithFileURL:docURL name:@"doc" error:nil];
                                                        }
                                                                            error:nil];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        NSInputStream *inputStream = [NSInputStream inputStreamWithURL:docURL];
//        [operation setInputStream:inputStream];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            CGFloat progress = totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
            [SVProgressHUD showProgress:progress];
        }];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        [operation start];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    NSLog(@"become active");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
