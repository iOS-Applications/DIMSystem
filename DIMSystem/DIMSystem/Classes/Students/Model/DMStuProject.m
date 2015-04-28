//
//  DMStuProject.m
//  DIMSystem
//
//  Created by qingyun on 15/4/13.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "DMStuProject.h"
#import "DMStudent.h"
#import "MJExtension.h"

@implementation DMStuProject

/**
 *  pro_stu 里面放的是一个一个的学生信息 需要表明怎么转化
 */
- (NSDictionary *)objectClassInArray
{
    return @{@"pro_stu":[DMStudent class]};
}
@end
