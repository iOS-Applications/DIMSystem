//
//  DMStuProject.h
//  DIMSystem
//
//  Created by qingyun on 15/4/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//  项目列表

#import <Foundation/Foundation.h>
@class DMStudent;

@interface DMStuProject : NSObject

/**
 *  项目id
 */
@property (nonatomic , copy) NSString *pro_id;

/**
 *  项目名称
 */
@property (nonatomic , copy) NSString *pro_title;

/**
 *  项目状态
 */
@property (nonatomic , copy) NSString *pro_state;

/**
 *  项目时间段
 */
@property (nonatomic , copy) NSString *pro_timeLimit;

/**
 *  项目类型
 */
@property (nonatomic , copy) NSString *pro_type;

/**
 *  项目参与学生
 */
@property (nonatomic , strong) NSArray *pro_stu;

@end
