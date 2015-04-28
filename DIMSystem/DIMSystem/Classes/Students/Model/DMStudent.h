//
//  DMStudent.h
//  DIMSystem
//
//  Created by qingyun on 15/4/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMStudent : NSObject

/**
 *  学号
 */
@property (nonatomic , copy) NSString *stu_num;

/**
 *  姓名
 */
@property (nonatomic , copy) NSString *stu_name;

/**
 *  年龄
 */
@property (nonatomic , copy) NSString *stu_age;

/**
 *  性别
 */
@property (nonatomic , copy) NSString *stu_sex;

/**
 *  学院
 */
@property (nonatomic , copy) NSString *stu_depart;

/**
 *  专业
 */
@property (nonatomic , copy) NSString *stu_major;

/**
 *  班级
 */
@property (nonatomic , copy) NSString *stu_class;

/**
 *  职务
 */
@property (nonatomic , copy) NSString *stu_post;

/**
 *  籍贯
 */
@property (nonatomic , copy) NSString *stu_address;

/**
 *  电话
 */
@property (nonatomic , copy) NSString *stu_phone;

/**
 *  邮箱
 */
@property (nonatomic , copy) NSString *stu_email;

/**
 *  备注
 */
@property (nonatomic , copy) NSString *stu_remarks;

@end
