//
//  StuActionVC.m
//  DIMSystem
//
//  Created by QQ on 15/4/16.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "StuActionVC.h"
#import "DMStudent.h"
#import <MessageUI/MessageUI.h>
#import "StuDetailVC.h"

@interface StuActionVC () <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic , strong) UIWebView *webView;

@end

@implementation StuActionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameButton setTitle:self.studnet.stu_name forState:UIControlStateNormal];
}
- (IBAction)carryOutTask:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1:
            //打电话
            [self callStudent];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        case 2:
            //发信息
            [self sendMessageToStudent];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        case 3:
            //发邮件
            [self sendEmailToStudent];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        case 4:
            //更多资料
            [self displayDetailInfo];
            break;
        case 5:
            //添加到项目
            [self addStudentToProject];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        default:
            break;
    }
    
}

#pragma  mark //与学生的一些交互
/**
 *  打电话
 */
- (void)callStudent
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.studnet.stu_phone]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

/**
 *  发信息
 */
- (void)sendMessageToStudent
{
    //判断用户是否能发送短信
    if (![MFMessageComposeViewController canSendText]) {
        //设置提示框
        return;
    }
    
    //实例化一个控制器
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    
    //收件人
    NSString *phoneNum = self.studnet.stu_phone;
    messageVC.recipients = @[phoneNum];
    
    //设置代理
    messageVC.messageComposeDelegate = self;
    
    //显示短信控制器
    [self presentViewController:messageVC animated:YES completion:nil];
}

/**
 *  发邮件
 */
- (void)sendEmailToStudent
{
    //先判断是否能发送邮件
    if (![MFMailComposeViewController canSendMail]) {
        //提示用户设置邮箱
#warning TODO
        return;
    }
    
    //实例化邮箱控制器
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    
    //主题 XXX的工作报告
    [mailVC setSubject:@"我的工作报告"];
    
    //收件人
    NSString *mailNum = self.studnet.stu_email;
    [mailVC setToRecipients:@[mailNum]];
    
    //正文
    [mailVC setMessageBody:@"这是我的工作报告" isHTML:YES];
    
    [mailVC setMailComposeDelegate:self];
    
}

/**
 *  详细信息
 */
- (void)displayDetailInfo
{
    StuDetailVC *detailInfoVC = [[StuDetailVC alloc] init];
    
//    NSLog(@"%@",self.navigationController.viewControllers[0]);
    
    UIViewController *superVC = self.navigationController.viewControllers[0];
    [superVC.navigationController pushViewController:detailInfoVC animated:YES];
}

/**
 *  添加到项目
 */
- (void)addStudentToProject
{
    
}
#pragma mark //MFMessageComposeViewControllerDelegate

/**
 短信发送结果
 MessageComposeResultCancelled,     取消
 MessageComposeResultSent,          发送
 MessageComposeResultFailed         失败
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%d", result);
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark // 邮件代理方法
/**
 MFMailComposeResultCancelled,      取消
 MFMailComposeResultSaved,          保存邮件
 MFMailComposeResultSent,           已经发送
 MFMailComposeResultFailed          发送失败
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 根据不同状态提示用户
    NSLog(@"%d", result);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark // 点击其他地方返回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
