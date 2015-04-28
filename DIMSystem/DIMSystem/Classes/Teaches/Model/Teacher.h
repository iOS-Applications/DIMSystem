//
//  Teacher.h
//  DIMSystem
//
//  Created by wecash on 15/4/14.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teacher : NSObject

@property (nonatomic,strong) NSData *avatarData;    //头像
@property (nonatomic,strong) NSString *name;        //姓名
@property (nonatomic,strong) NSString *gender;      //性别
@property (nonatomic,strong) NSString *idNum;       //教工号
@property (nonatomic,strong) NSString *mobile;      //手机号
@property (nonatomic,strong) NSString *qq;          //qq号
@property (nonatomic,strong) NSString *email;       //邮箱
@property (nonatomic,strong) NSString *department;  //学院
@property (nonatomic,strong) NSString *major;       //专业
@property (nonatomic,strong) NSString *job;         //职位

+ (Teacher *)teacherFromInfo:(NSDictionary *)info;
@end
