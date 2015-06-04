//
//  PracMyBiSheDetail.m
//  DIMSystem
//
//  Created by qingyun on 15/4/16.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracMyBiSheDetail.h"
#import "AFNetworking.h"
#import "PracProjectsModel.h"
#import "ZFQGeneralService.h"

@interface PracMyBiSheDetail ()
@property (weak, nonatomic) IBOutlet UITextField *pracName;
@property (weak, nonatomic) IBOutlet UITextField *pracSource;
@property (weak, nonatomic) IBOutlet UITextField *pracType;
@property (weak, nonatomic) IBOutlet UITextField *stuNum;
@property (weak, nonatomic) IBOutlet UITextField *teaName;
@property (weak, nonatomic) IBOutlet UITextField *jobTitle;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UITextView *task;
@property (nonatomic, assign) BOOL btnStatus;
@property (nonatomic,strong) NSString *teaID;
@end

@implementation PracMyBiSheDetail

/*
 @property (nonatomic,assign) NSInteger PraPrj_id;
 @property (nonatomic,strong) NSString *PraPrj_title;
 @property (nonatomic,strong) NSString *PraPrj_source;
 @property (nonatomic,strong) NSString *PraPrj_type;
 @property (nonatomic,strong) NSString *PraPrj_teacher;
 @property (nonatomic,strong) NSString *PraPrj_job;
 @property (nonatomic,strong) NSString *PraPrj_stuNum;
 @property (nonatomic,strong) NSString *PraPrj_descript1;
 @property (nonatomic,strong) NSString *PraPrj_descript2;
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnStatus = YES;
    
    self.pracName.text = self.model.PraPrj_title;
    self.pracSource.text = self.model.PraPrj_source;
    self.pracType.text = self.model.PraPrj_type;
    self.stuNum.text = self.model.PraPrj_stuNum;
    self.teaName.text = self.model.PraPrj_teacher;
    self.jobTitle.text = self.model.PraPrj_job;
    self.content.text = self.model.PraPrj_descript1;
    self.task.text = self.model.PraPrj_descript2;
    
    //获取当天教师ID 假定已经登录
//    self.teaID = [ZFQGeneralService accessId];
    self.teaID = @"40110023";
    
    [self.pracName setEnabled:NO];
    [self.pracSource setEnabled:NO];
    [self.pracType setEnabled:NO];
    [self.stuNum setEnabled:NO];
    [self.teaName setEnabled:NO];
    [self.jobTitle setEnabled:NO];
    [self.content setEditable:NO];
    [self.task setEditable:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)test
{
    NSLog(@"h=huhuh");
}
//编辑工程内容
- (IBAction)edite:(UIBarButtonItem *)sender {
    
    if (self.btnStatus == YES) {
        sender.title = @"完成";
        self.btnStatus = NO;
        [self.pracName setEnabled:YES];
        [self.pracSource setEnabled:YES];
        [self.pracType setEnabled:YES];
        [self.stuNum setEnabled:YES];
        [self.teaName setEnabled:YES];
        [self.jobTitle setEnabled:YES];
        [self.content setEditable:YES];
        [self.task setEditable:YES];
        
        
    } else {
        sender.title = @"编辑";
        self.btnStatus = YES;
        [self.pracName setEnabled:NO];
        [self.pracSource setEnabled:NO];
        [self.pracType setEnabled:NO];
        [self.stuNum setEnabled:NO];
        [self.teaName setEnabled:NO];
        [self.jobTitle setEnabled:NO];
        [self.content setEditable:NO];
        [self.task setEditable:NO];
        [self upDateData];
        
    }
    
}
//更新数据
- (void)upDateData
{
    NSLog(@"点击更新");
    
    NSDictionary *parameter = @{@"praPrj_id":self.model.PraPrj_id, @"praPrj_teaID":self.model.PraPrj_teaID,@"praPrj_title":self.pracName.text,@"praPrj_source":self.pracSource.text,@"praPrj_type":self.pracType.text,@"praPrj_sign":self.model.praPrj_sign,@"praPrj_stuNum":self.stuNum.text,@"praPrj_descript1":self.content.text,@"praPrj_descript2":self.task.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://zzti.sinaapp.com/updateProject" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@">>>>>>%@",responseObject);
        NSDictionary *dic = responseObject;
        NSInteger val = [dic[@"status"] integerValue];
        if (val ==200) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@
             "addNoti"object:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
  

}


- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
