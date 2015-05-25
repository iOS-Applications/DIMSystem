#pragma mark //
//  DMDataManger.m
 //  DIMSystem
//
//  Created by 刘少毅 on 15/5/20.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "DMDataManger.h"
#import "FMDB.h"

@implementation DMDataManger

static FMDatabase *_db;

#pragma mark //创建表
+ (void)initialize
{
    //1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"dimData.sqlite"];
    NSLog(@"sqlite's path>>>>%@",path);
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //2.创建表
    //学生信息表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS dim_student (id integer PRIMARY KEY,stu_num text,stu_major text,stu_sclass text,stu_post text,student blob NOT NULL)"];
    //项目学生表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS dim_pro_stu (id integer PRIMARY KEY,pro_id text,pro_name text,pro_student blob,pro_info blob)"];
    //通讯记录表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS dim_recordInfo (id integer PRIMARY KEY,rec_time text,rec_students blob,rec_type integer)"];
}


#pragma mark //缓存学生信息
+ (void)saveDMStudentsWithDicArray:(NSArray *)studentsArray
{
    
}

#pragma mark //缓存项目信息
+ (void)saveDMProjectsWithDicArray:(NSArray *)projectsArray
{
    
}

#pragma mark //缓存信息记录
+ (void)saveMessageRecordWithDic:(NSDictionary *)infoDic
{
    
}

#pragma mark //删除信息记录
+ (void)deleteMessageRecordWithMessageID:(NSString *)messageID
{
    
}

#pragma mark //从缓存中加载信息记录
+ (NSArray *)checkMessageRecord
{
    return nil;
}

#pragma mark //缓存电话记录
+ (void)savePhoneCallRecordWithDic:(NSDictionary *)phoneRecord
{
    
}

#pragma mark //删除电话记录
+ (void)deletePhoneCallRecordWithPhoneCallID:(NSString *)phoneCallID
{
    
}

#pragma mark //从缓存中加载电话记录
+ (NSArray *)checkPhoneCallRecord
{
    return nil;
}

#pragma mark //从缓存中加载学生信息
+ (NSArray *)checkDMStudents
{
    return nil;
}

#pragma mark //从缓存中加载项目信息
+ (NSArray *)checkDMProjects
{
    return nil;
}

#pragma mark //更新新项目信息（添加删除/删除记录）
+ (void)upDataProjectWithDic:(NSDictionary *)stuDic
{
    
}

#pragma mark //清理缓存
+ (void)clearRecord
{
    
}
@end
