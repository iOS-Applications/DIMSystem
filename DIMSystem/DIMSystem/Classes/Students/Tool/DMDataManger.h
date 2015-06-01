//
//  DMDataManger.h
//  DIMSystem
//
//  Created by 刘少毅 on 15/5/20.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMDataManger : NSObject

//缓存学生信息
+ (void)saveDMStudentsWithDicArray:(NSArray *)studentsArray;

//缓存项目信息
+ (void)saveDMProjectsWithDicArray:(NSArray *)projectsArray;

//缓存通讯记录
+ (void)saveRecordInfoWithDic:(NSDictionary *)infoDic;

//删除通讯记录
+ (void)deleteRecordInfoWithRecID:(NSString *)recID;

//从缓存中加载通讯记录
+ (NSArray *)checkRecordInfo;

//从缓存中加载学生信息
+ (NSArray *)checkDMStudents;

#pragma mark //快速查询学生
+ (NSArray *)checkDMProjectsWithCheckString:(NSString *)checkStr;

//从缓存中加载项目信息
+ (NSArray *)checkDMProjects;

//更新新项目信息（添加删除/删除记录）
+ (void)upDataProjectWithProject:(NSDictionary *)project;
//清理缓存
+ (void)clearRecord;
@end
