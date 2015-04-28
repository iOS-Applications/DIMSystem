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
    
    UIImage *avatarImg = [info objectForKey:@"avatar"];
    teacher.avatarData = UIImagePNGRepresentation(avatarImg);
    teacher.name = [dataDic objectForKey:@"name"];
    teacher.gender = [dataDic objectForKey:@"gender"];
    teacher.idNum = [dataDic objectForKey:@"idNum"];
    
    teacher.mobile = [dataDic objectForKey:@"mobile"];
    teacher.qq = [dataDic objectForKey:@"qq"];
    teacher.email = [dataDic objectForKey:@"email"];
    
    teacher.department = [dataDic objectForKey:@"department"];
    teacher.major = [dataDic objectForKey:@"major"];
    teacher.job = [dataDic objectForKey:@"job"];
    
    return teacher;
}


@end
