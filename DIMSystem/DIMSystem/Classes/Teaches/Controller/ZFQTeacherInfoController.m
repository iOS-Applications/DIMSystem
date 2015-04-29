//
//  ZFQTeacherInfoController.m
//  DIMSystem
//
//  Created by wecash on 15/4/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "ZFQTeacherInfoController.h"
#import "ZFQGeneralService.h"
#import "UIBarButtonItem+DIM.h"
#import "ZFQMecroDefine.h"
#import "ZFQTeacherEditController.h"
#import "ZFQTeacherHomeController.h"
#import "UIImage+CropPortraint.h"
#import <MessageUI/MessageUI.h>
#import "SVProgressHUD.h"
#import "Teacher.h"
#import "SQBBaseView.h"

@interface ZFQTeacherInfoController () <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UIImageView *avatar;
    UILabel *nameLabel;
    UILabel *genderLabel;
    UILabel *idNumLabel;
    
    UILabel *mobileLabel;
    UILabel *qqLabel;
    UILabel *emailLabel;
    
    UILabel *departmentLabel;
    UILabel *majorLabel;
    UILabel *jobLabel;
    
//    NSMutableDictionary *teacherInfo;
}

@property (nonatomic,strong,readwrite) NSMutableDictionary *teacherInfo;

@end

@implementation ZFQTeacherInfoController

/*
 - (void)loadView
 {
 self.view = [[SQBBaseView alloc] initWithFrame:[UIScreen mainScreen].bounds];
 }
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //请求网络，完成后解析出json数据,这个解析出的为一个字典
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    ZFQTeacherInfoController * __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //这是json解析的结果
        NSDictionary *info = @{
                               @"data":@{
                                       @"name":@"张三",
                                       @"gender":@"男",
                                       @"idNum":@"201100834128",
                                       @"mobile":@"13141187980",
                                       @"qq":@"1586687169",
                                       @"email":@"1586687169@qq.com",
                                       @"department":@"计算机学院",
                                       @"major":@"软件工程",
                                       @"job":@"讲师"
                                       },
                               @"status":@(200),
                               @"msg":@""
                               };
        weakSelf.teacherInfo = info[@"data"];
        Teacher *teacher = [Teacher teacherFromInfo:info];
        //显示subView
        [self addSubViewWithTeacher:teacher];
        //让编辑按钮可用
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        [SVProgressHUD dismiss];
    });
    
    //设置编辑按钮
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(tapEditItemAction:)];
    editItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = editItem;
}

- (void)addSubViewWithTeacher:(Teacher *)teacher
{
    CGRect originFrame = CGRectZero;
    //-------个人信息----------
    UILabel *infoLabel = [ZFQGeneralService labelWithTitle:@"个人信息" fontSize:14];
    originFrame = infoLabel.frame;
    originFrame.origin = CGPointMake(20, 10);
    infoLabel.frame = originFrame;
    [_myScrollView addSubview:infoLabel];
    
    //1.头像
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10 + CGRectGetMaxY(infoLabel.frame), 50, 50)];
    avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    avatar.layer.borderWidth = 1;
    avatar.layer.cornerRadius = 25.f;
    if (teacher.avatarData != nil && teacher.avatarData.length > 0) {
        avatar.image = [[UIImage alloc] initWithData:teacher.avatarData];
    } else {
        avatar.image = [UIImage imageNamed:@"avatar_default"];
    }
    avatar.layer.masksToBounds = YES;
    [_myScrollView addSubview:avatar];
    
    originFrame = CGRectZero;
    CGFloat padding = 10.f;
    
    //2.姓名框
    CGFloat labelWidth = ZFQ_ScreenWidth/2 - 50;
    CGFloat labelHeight = 30;
    nameLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.name width:labelWidth];
    originFrame = nameLabel.frame;
    originFrame.origin = CGPointMake(CGRectGetMaxX(avatar.frame) + 20, CGRectGetMaxY(avatar.frame) - originFrame.size.height - 20);
    nameLabel.frame = originFrame;
    [_myScrollView addSubview:nameLabel];
    
    //3.性别
    UILabel *genderTitleLabel = [ZFQGeneralService labelWithTitle:@"性别:"];
    originFrame = genderTitleLabel.frame;
    genderTitleLabel.center = CGPointMake(CGRectGetMaxX(nameLabel.frame) + padding + originFrame.size.width/2, nameLabel.center.y);
    [_myScrollView addSubview:genderTitleLabel];
    
    CGRect genderLabelrame = CGRectMake(CGRectGetMaxX(genderTitleLabel.frame), CGRectGetMinY(nameLabel.frame), labelWidth/2-10, labelHeight);
    genderLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.gender width:genderLabelrame.size.width];
    genderLabel.frame = genderLabelrame;
    [_myScrollView addSubview:genderLabel];
    
    //4.教工号
    idNumLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.idNum width:nameLabel.frame.size.width + 40];
    originFrame = idNumLabel.frame;
    CGFloat centerY = CGRectGetMaxY(nameLabel.frame) + 10 + idNumLabel.frame.size.height/2;
    idNumLabel.center = CGPointMake(nameLabel.frame.origin.x + originFrame.size.width/2, centerY);
    [_myScrollView addSubview:idNumLabel];
    
    CGFloat paddingV = 40;
    //-----------联系方式---------
    UILabel *contactLabel = [ZFQGeneralService labelWithTitle:@"联系方式" fontSize:14];
    originFrame = contactLabel.frame;
    originFrame.origin = CGPointMake(avatar.frame.origin.x, CGRectGetMaxY(idNumLabel.frame) + paddingV);
    contactLabel.frame = originFrame;
    [_myScrollView addSubview:contactLabel];
    
    //1.手机号
    mobileLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.mobile width:idNumLabel.frame.size.width];
    originFrame = mobileLabel.frame;
    originFrame.origin = CGPointMake(idNumLabel.frame.origin.x, CGRectGetMaxY(contactLabel.frame) + 10);
    mobileLabel.frame = originFrame;
    [_myScrollView addSubview:mobileLabel];
    
    //1.1添加打电话按钮
    CGSize callBtnSize = CGSizeMake(40, 36); //30, 22
    UIImage *callNormalImg = [UIImage arrowImgWithSize:callBtnSize lineColor:ZFQ_RGB(27, 152, 247, 1)];
    UIImage *callPressedImg = [UIImage arrowImgWithSize:callBtnSize lineColor:ZFQ_RGB(27, 152, 247, 0.1)];
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setImage:callNormalImg forState:UIControlStateNormal];
    [callBtn setImage:callPressedImg forState:UIControlStateHighlighted];
    callBtn.bounds = CGRectMake(0, 0, callBtnSize.width, callBtnSize.height);
    callBtn.center = CGPointMake(ZFQ_ScreenWidth - 10 - callBtnSize.width/2, mobileLabel.center.y);
    [_myScrollView addSubview:callBtn];
    [callBtn addTarget:self action:@selector(tapCallBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //2.QQ号
    qqLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.qq width:mobileLabel.frame.size.width];
    originFrame = qqLabel.frame;
    originFrame.origin = CGPointMake(mobileLabel.frame.origin.x, CGRectGetMaxY(mobileLabel.frame) + 10);
    qqLabel.frame = originFrame;
    [_myScrollView addSubview:qqLabel];
    
    //3.邮箱
    emailLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.email width:mobileLabel.frame.size.width];
    originFrame = emailLabel.frame;
    originFrame.origin = CGPointMake(qqLabel.frame.origin.x, CGRectGetMaxY(qqLabel.frame) + 10);
    emailLabel.frame = originFrame;
    [_myScrollView addSubview:emailLabel];
    //3.1添加发邮件按钮
    UIImage *emailNormalImg = [UIImage emailImgWithSize:callBtnSize lineColor:ZFQ_RGB(27, 152, 247, 1)];
    UIImage *emailPressedImg = [UIImage emailImgWithSize:callBtnSize lineColor:ZFQ_RGB(27, 152, 247, 0.1)];
    UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emailBtn setImage:emailNormalImg forState:UIControlStateNormal];
    [emailBtn setImage:emailPressedImg forState:UIControlStateHighlighted];
    emailBtn.bounds = CGRectMake(0, 0, callBtnSize.width, callBtnSize.height);
    emailBtn.center = CGPointMake(ZFQ_ScreenWidth - 10 - callBtnSize.width/2, emailLabel.center.y);
    [_myScrollView addSubview:emailBtn];
    [emailBtn addTarget:self action:@selector(tapEmailBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //--------------职位信息------------
    UILabel *jobInfoLabel = [ZFQGeneralService labelWithTitle:@"职位信息" fontSize:14];
    originFrame = jobInfoLabel.frame;
    originFrame.origin = CGPointMake(contactLabel.frame.origin.x, CGRectGetMaxY(emailLabel.frame) + paddingV);
    jobInfoLabel.frame = originFrame;
    [_myScrollView addSubview:jobInfoLabel];
    
    //1.学院
    CGRect departmentFrame = CGRectMake(emailLabel.frame.origin.x, CGRectGetMaxY(jobInfoLabel.frame) + 10, emailLabel.frame.size.width + 20, labelHeight);
    departmentLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.department width:departmentFrame.size.width];
    departmentLabel.frame = departmentFrame;
    [_myScrollView addSubview:departmentLabel];
    //2.专业
    CGRect majorFrame = departmentFrame;
    majorFrame.origin.y = CGRectGetMaxY(departmentFrame) + 10;
    majorLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.major width:majorFrame.size.width];
    majorLabel.frame = majorFrame;
    [_myScrollView addSubview:majorLabel];
    //3.职位
    CGRect jobFrame = majorFrame;
    jobFrame.origin.y = CGRectGetMaxY(majorFrame) + 10;
    jobLabel = [ZFQGeneralService underLineLabelWithTitle:teacher.job width:jobFrame.size.width];
    jobLabel.frame = jobFrame;
    [_myScrollView addSubview:jobLabel];
    
    //设置contentSize
    _myScrollView.contentSize = CGSizeMake(ZFQ_ScreenWidth, CGRectGetMaxY(jobLabel.frame) + 100);
    _myScrollView.alwaysBounceVertical = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //1.停止网络请求...
    //2.dismiss HUD
    [SVProgressHUD dismiss];
}

- (void)tapEditItemAction:(UIBarButtonItem *)item
{
    ZFQTeacherEditController *teacherVC = [[ZFQTeacherEditController alloc] init];
    ZFQTeacherInfoController * __weak weakSelf = self;
    teacherVC.teacherInfo = self.teacherInfo;
    teacherVC.completionBlk = ^(NSDictionary *myTeacherInfo) {
        //设置信息
        [weakSelf settingTeacherInfo:myTeacherInfo];
        weakSelf.teacherInfo = [myTeacherInfo mutableCopy];
    };
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:teacherVC];
    [self presentViewController:naVC animated:NO completion:nil];
}

- (void)settingTeacherInfo:(NSDictionary *)myTeacherInfo
{
    NSData *avatarData = myTeacherInfo[@"avatar"];
    if ([avatarData isKindOfClass:[NSNull class]] == NO) {
        if (avatarData != nil && avatarData.length > 0) {
            avatar.image = [[UIImage alloc] initWithData:avatarData];
        }
    }
   
    
    nameLabel.text = myTeacherInfo[@"name"];
    genderLabel.text = myTeacherInfo[@"gender"];
    idNumLabel.text = myTeacherInfo[@"idNum"];
    
    mobileLabel.text = myTeacherInfo[@"mobile"];
    qqLabel.text = myTeacherInfo[@"qq"];
    emailLabel.text = myTeacherInfo[@"email"];
    
    departmentLabel.text = myTeacherInfo[@"department"];
    majorLabel.text = myTeacherInfo[@"major"];
    jobLabel.text = myTeacherInfo[@"job"];
}

#pragma mark - 打电话/发短信
- (void)tapCallBtnAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打电话",@"发短信", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 2) {
        if (buttonIndex == 0) {     //打电话
            NSString *str = [NSString stringWithFormat:@"tel://%@",mobileLabel.text];
            NSURL *mobileURL = [NSURL URLWithString:str];
            if ([[UIApplication sharedApplication] canOpenURL:mobileURL] == YES) {
                [[UIApplication sharedApplication] openURL:mobileURL];
            } else {
                [self showAlertViewWithTitle:@"设备不支持打电话"];
            }
            
        } else if (buttonIndex == 1){   //发短信
            if ([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *mmVC = [[MFMessageComposeViewController alloc] init];
                mmVC.recipients = @[mobileLabel.text];
                mmVC.messageComposeDelegate = self;
                [self presentViewController:mmVC animated:YES completion:nil];
            } else {
                [self showAlertViewWithTitle:@"设备不支持发短信"];
            }
        }
        
    }
}

- (void)showAlertViewWithTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:title
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString *alertMsg = nil;
    if (result == MessageComposeResultSent) {
        alertMsg = @"已发送";
    } else if (result == MessageComposeResultFailed) {
        alertMsg = @"发送失败";
    }
    
    if (alertMsg != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 202;
        [alertView show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
#pragma mark - 发邮件
- (void)tapEmailBtnAction
{
    if ([MFMailComposeViewController canSendMail] == NO) {
        //如果不能发送邮箱就打开邮件App
        NSString *param = [NSString stringWithFormat:@"mailto:%@&subject=zhuti",emailLabel.text];
        NSString *emailURL = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailURL]];
    } else {
        //显示email界面
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        //设置收件人
        if (emailLabel.text != nil) {
            NSArray *toRecipients = @[emailLabel.text];
            [mailVC setToRecipients:toRecipients];
        }
        [self presentViewController:mailVC animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error != nil) {
        NSLog(@"发送邮件出错:%@",error);
    }
    
    NSString *alertMsg = nil;
    if (result == MFMailComposeResultSent) {
        alertMsg = @"已发送，请查收";
    } else if (result == MFMailComposeResultFailed) {
        alertMsg = @"发送失败";
    }
    
    if (alertMsg != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 201;
        [alertView show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 201 || alertView.tag == 202) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
