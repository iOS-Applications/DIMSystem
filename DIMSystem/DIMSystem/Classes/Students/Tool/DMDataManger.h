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

//缓存信息记录
+ (void)saveMessageRecordWithDic:(NSDictionary *)infoDic;

//删除信息记录
+ (void)deleteMessageRecordWithMessageID:(NSString *)messageID;

//从缓存中加载信息记录
+ (NSArray *)checkMessageRecord;

//缓存电话记录
+ (void)savePhoneCallRecordWithDic:(NSDictionary *)phoneRecord;

//删除电话记录
+ (void)deletePhoneCallRecordWithPhoneCallID:(NSString *)phoneCallID;

//从缓存中加载电话记录
+ (NSArray *)checkPhoneCallRecord;

//从缓存中加载学生信息
+ (NSArray *)checkDMStudents;

//从缓存中加载项目信息
+ (NSArray *)checkDMProjects;

//更新新项目信息（添加删除/删除记录）
+ (void)upDataProjectWithDic:(NSDictionary *)stuDic;

//清理缓存
+ (void)clearRecord;
@end
