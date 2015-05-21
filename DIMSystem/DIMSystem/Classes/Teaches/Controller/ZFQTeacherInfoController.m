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
#import "Teacher.h"
#import "SQBBaseView.h"
#import "SVProgressHUD+ZFQCustom.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "commenConst.h"
#import "ZFQTeachersController.h"

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
    
    BOOL avatarIsNil;   //该教师是否没有头像，默认为YES,表示使用默认的
}

@property (nonatomic,strong,readwrite) NSMutableDictionary *teacherInfo;

@end

@implementation ZFQTeacherInfoController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _showEditItem = YES;
        _showDeleteItem = NO;
        avatarIsNil = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.idNum == nil || [self.idNum isKindOfClass:[NSNull class]] || [self.idNum isEqualToString:@""]) {
        //加载当前登录的老师的信息
        [SVProgressHUD showZFQHUDWithStatus:@"您尚未登陆，请登陆"];
    } else {
        //加载教工号为idNum的老师的信息
        [SVProgressHUD showZFQHUDWithStatus:@"正在加载..."];
        ZFQTeacherInfoController * __weak weakSelf = self;
        [Reachability isReachableWithHostName:kHost complition:^(BOOL isReachable) {
            if (reachable(isReachable)) {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSDictionary *param = @{@"idNum":weakSelf.idNum};
                NSString *getURL = [kHost stringByAppendingString:@"/teacherInfo"];
                [manager GET:getURL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dic = responseObject;
                    weakSelf.teacherInfo = dic[@"data"];
                    Teacher *teacher = [Teacher teacherFromInfo:dic];
                    //显示subView
                    [self addSubViewWithTeacher:teacher];
                    //让编辑按钮可用
                    weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                    [SVProgressHUD dismiss];
                    
                    //下载头像,获取idNum
                    [self downloadAvatarWithIdNum:weakSelf.idNum];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showZFQErrorWithStatus:@"请求失败"];
                }];
            } else {
                [SVProgressHUD showZFQErrorWithStatus:@"网络不给力"];
            }
        }];
    }

    if (self.showEditItem == YES) {
        //设置编辑按钮
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(tapEditItemAction:)];
        editItem.enabled = NO;
        self.navigationItem.rightBarButtonItem = editItem;
    } else {
        if (self.showDeleteItem == YES) {
            //设置删除按钮
            UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(tapDeleteItemAction)];
            self.navigationItem.rightBarButtonItem = deleteItem;
        }
    }
}

- (void)downloadAvatarWithIdNum:(NSString *)idNum
{
    //下载头像
    NSString *urlStr = [NSString stringWithFormat:@"%@/avatar?idNum=%@",kHost,[ZFQGeneralService accessId]];
    NSString *encodingStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodingStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30];
    [request setValue:@"utf-8" forHTTPHeaderField:@"Accept-Encoding"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //获取要写的文件路径
    if (idNumLabel.text == nil) {
        return;
    }
    NSString *fileName = [ZFQGeneralService avatarPathWithName:idNumLabel.text];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //从文件夹中把图片搞出来
        UIImage *img = [ZFQGeneralService avatarFileWithName:idNum];
        if (img != nil) {
            avatar.image = img;
            avatarIsNil = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"下载失败"];
    }];
    [operation start];

}

- (void)addSubViewWithTeacher:(Teacher *)teacher
{
    CGRect originFrame = CGRectZero;
    CGFloat SCWidth = ZFQ_ScreenWidth;
    //-------个人信息----------
    UILabel *infoLabel = [ZFQGeneralService labelWithTitle:@"个人信息" fontSize:14];
    originFrame = infoLabel.frame;
    originFrame.origin = CGPointMake(20, 10);
    infoLabel.frame = originFrame;
    [_myScrollView addSubview:infoLabel];
    
    UIImage *bcgImg = [UIImage imageNamed:@"header_background"];
    UIImageView *bcgImg1 = [[UIImageView alloc] initWithImage:bcgImg];
    bcgImg1.frame = CGRectMake(CGRectGetMinX(infoLabel.frame), CGRectGetMaxY(infoLabel.frame) - 5, SCWidth - infoLabel.frame.origin.x, bcgImg.size.height);
    [_myScrollView insertSubview:bcgImg1 belowSubview:infoLabel];
    
    //1.头像
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20 + CGRectGetMaxY(infoLabel.frame), 50, 50)];
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
    UIImageView *bcgImg2 = [[UIImageView alloc] initWithImage:bcgImg];
    bcgImg2.frame = CGRectMake(CGRectGetMinX(contactLabel.frame), CGRectGetMaxY(contactLabel.frame) - 5, SCWidth - contactLabel.frame.origin.x, bcgImg.size.height);
    [_myScrollView insertSubview:bcgImg2 belowSubview:contactLabel];
    
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
    UIImageView *bcgImg3 = [[UIImageView alloc] initWithImage:bcgImg];
    bcgImg3.frame = CGRectMake(CGRectGetMinX(jobInfoLabel.frame), CGRectGetMaxY(jobInfoLabel.frame) - 5, SCWidth - jobInfoLabel.frame.origin.x, bcgImg.size.height);
    [_myScrollView insertSubview:bcgImg3 belowSubview:jobInfoLabel];
    
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
    if (avatarIsNil == NO) {
        teacherVC.myAvatar = avatar.image;
    }
    
    teacherVC.completionBlk = ^(NSDictionary *myTeacherInfo,UIImage *avatarImg) {
        //设置信息
        [weakSelf settingTeacherInfo:myTeacherInfo];
        weakSelf.teacherInfo = [myTeacherInfo mutableCopy];
        if (avatarImg != nil) {
            avatar.image = avatarImg;
        }
    };
    teacherVC.cancelBlk = ^(UIImage *avatarImg) {
        if (avatarImg != nil) {
            avatar.image = avatarImg;
        }
        
    };
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:teacherVC];
    [self presentViewController:naVC animated:NO completion:nil];
}

- (void)tapDeleteItemAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否删除该教师信息?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    actionSheet.tag = 456;
    [actionSheet showInView:self.view];
}

- (void)settingTeacherInfo:(NSDictionary *)myTeacherInfo
{
    NSData *avatarData = myTeacherInfo[@"avatar"];
    if ([avatarData isKindOfClass:[NSNull class]] == NO) {
        if (avatarData != nil && avatarData.length > 0) {
            avatar.image = [[UIImage alloc] initWithData:avatarData];
        }
    }
   
    nameLabel.text = myTeacherInfo[@"t_name"];
    genderLabel.text = myTeacherInfo[@"t_gender"];
    idNumLabel.text = myTeacherInfo[@"t_id"];
    
    mobileLabel.text = myTeacherInfo[@"t_mobile"];
    qqLabel.text = myTeacherInfo[@"t_qq"];
    emailLabel.text = myTeacherInfo[@"t_email"];
    
    departmentLabel.text = myTeacherInfo[@"t_faculty"];
    majorLabel.text = myTeacherInfo[@"t_major"];
    jobLabel.text = myTeacherInfo[@"t_job"];
}

#pragma mark - 打电话/发短信
- (void)tapCallBtnAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打电话",@"发短信", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 456) {   //删除
        [SVProgressHUD showWithStatus:@"请稍后..."];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *urlStr = [kHost stringByAppendingString:@"/deleteTeacher"];
        NSDictionary *param = @{@"idNum":idNumLabel.text};
        [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = responseObject;
            NSNumber *status = dic[@"status"];
            if (status.integerValue == 200) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                
                //pop到选择页面
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isMemberOfClass:[ZFQTeachersController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
                
            } else {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        
    } else {
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kZFQDelNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
