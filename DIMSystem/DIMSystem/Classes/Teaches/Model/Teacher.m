//
//  Teacher.m
//  DIMSystem
//
//  Created by wecash on 15/4/14.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//
#import "Teacher.h"
#import <UIKit/UIKit.h>

@implementation Teacher

+ (Teacher *)teacherFromInfo:(NSDictionary *)info
{
    Teacher *teacher = [[Teacher alloc] init];
    NSDictionary *dataDic = [info objectForKey:@"data"];
    
//    UIImage *avatarImg = [info objectForKey:@"avatar"];
//    teacher.avatarData = UIImagePNGRepresentation(avatarImg);
    teacher.name = [dataDic objectForKey:@"t_name"];
    teacher.gender = [dataDic objectForKey:@"t_gender"];
    teacher.idNum = [dataDic objectForKey:@"t_id"];
    
    teacher.mobile = [dataDic objectForKey:@"t_mobile"];
    teacher.qq = [dataDic objectForKey:@"t_qq"];
    teacher.email = [dataDic objectForKey:@"t_email"];
    
    teacher.department = [dataDic objectForKey:@"t_faculty"];
    teacher.major = [dataDic objectForKey:@"t_major"];
    teacher.job = [dataDic objectForKey:@"t_job"];
    
    return teacher;
}


@end
