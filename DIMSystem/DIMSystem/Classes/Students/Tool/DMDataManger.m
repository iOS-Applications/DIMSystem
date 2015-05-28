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
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS dim_student (id integer PRIMARY KEY,stu_num text,stu_checkString,student blob NOT NULL)"];
    //项目学生表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS dim_pro_stu (id integer PRIMARY KEY,pro_id text,pro_type text,project blob"];
    //通讯记录表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS dim_recordInfo (id integer PRIMARY KEY,rec_messages blob,recordInfo blob,rec_type text)"];
    
}


#pragma mark //缓存学生信息
+ (void)saveDMStudentsWithDicArray:(NSArray *)studentsArray
{
    for (NSDictionary * student in studentsArray) {
        NSData *studentData = [NSKeyedArchiver archivedDataWithRootObject:student];
        
        NSString *checkString = [NSString stringWithFormat:@"%@%@%@",student[@"stu_major"],student[@"stu_sclass"],student[@"stu_post"]];
        
        [_db executeUpdateWithFormat:@"INSERT INTO dim_student(sut_num,stu_checkString,student) VALUES (%@ ,%@ ,%@);",student[@"stu_num"],checkString,studentData];
    }
}

#pragma mark //缓存项目信息
+ (void)saveDMProjectsWithDicArray:(NSArray *)projectsArray
{
    for (NSDictionary *project in projectsArray) {
        
        NSData *projectData = [NSKeyedArchiver archivedDataWithRootObject:project];
        
        [_db executeUpdateWithFormat:@"INSERT INTO dim_pro_stu(pro_id,pro_type,project) VALUES (%@ ,%@ ,%@);",project[@"pro_id"],project[@"type"],projectData];
    }
}

#pragma mark //缓存通讯记录
+ (void)saveRecordInfoWithDic:(NSDictionary *)infoDic
{
        NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:infoDic];
        NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:infoDic[@"rec_messages"]];
    
        [_db executeUpdateWithFormat:@"INSERT INTO dim_recordInfo(rec_time,rec_messages,recordInfo,rec_type) VALUES (%@ ,%@ ,%@, %@);",infoDic[@"rec_time"],messageData, infoData,infoDic[@"rec_type"]];
    
}

#pragma mark //删除信息记录
+ (void)deleteRecordInfoWithRecID:(NSString *)recID
{
    if ([_db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"DELETE FROM dim_recordInfo WHERE rec_id = %@ ;",recID];
        BOOL res = [_db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
        [_db close];
        
    }
}

#pragma mark //从缓存中加载信息记录
+ (NSArray *)checkRecordInfo
{
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM dim_recordInfo ORDER BY id DESC  "];
    
    //执行SQL语句
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *statusArray = [NSMutableArray array];
    while (set.next) {
        
        NSData *infoData = [set objectForColumnName:@"rec_info"];
        NSDictionary *rec_info = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
        [statusArray addObject:rec_info];
    }
    return statusArray;
}

#pragma mark //加载记录的消息
+ (NSArray *)checkMessagesWithRecID:(NSString *)recID
{
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT rec_messages FROM dim_recordInfo where id = %@",recID];
    
    //执行SQL语句
    FMResultSet *set = [_db executeQuery:sql];
        
    NSData *messagesData = [set objectForColumnName:@"rec_messages"];
    NSArray *messages = [NSKeyedUnarchiver unarchiveObjectWithData:messagesData];

    return messages;
}

#pragma mark //从缓存中加载学生信息
+ (NSArray *)checkDMStudents
{
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM dim_student ORDER BY id DESC LIMIT 60"];
    
    //执行SQL语句
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *studentsArray = [NSMutableArray array];
    while (set.next) {
        
        NSData *studentData = [set objectForColumnName:@"student"];
        NSDictionary *student = [NSKeyedUnarchiver unarchiveObjectWithData:studentData];
        [studentsArray addObject:student];
    }
    return studentsArray;
}

+ (NSArray *)checkDMProjectsWithCheckString:(NSString *)checkStr
{
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM dim_student where checkString like '%%%@%%' ORDER BY id DESC LIMIT 60",checkStr];
    
    //执行SQL语句
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *studentsArray = [NSMutableArray array];
    while (set.next) {
        
        NSData *studentData = [set objectForColumnName:@"student"];
        NSDictionary *student = [NSKeyedUnarchiver unarchiveObjectWithData:studentData];
        [studentsArray addObject:student];
    }
    return studentsArray;
}
#pragma mark //从缓存中加载项目信息
+ (NSArray *)checkDMProjects
{
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM dim_pro_stu ORDER BY id DESC "];
    
    //执行SQL语句
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *projectArray = [NSMutableArray array];
    while (set.next) {
        
        NSData *projectData = [set objectForColumnName:@"rec_info"];
        NSDictionary *project = [NSKeyedUnarchiver unarchiveObjectWithData:projectData];
        [projectArray addObject:project];
    }
    return projectArray;
}

#pragma mark //更新新项目信息（添加删除/删除记录）
+ (void)upDataProjectWithProject:(NSDictionary *)project;
{
    NSData *projectData = [NSKeyedArchiver archivedDataWithRootObject:project];
    NSString *proID = project[@"pro_id"];
    
    if ([_db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE dim_pro_stu set project = %@ where pro_id = %@",projectData,proID];
        
        BOOL res = [_db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
        [_db close];
        
    }
}

#pragma mark //清理缓存
+ (void)clearRecord
{
    NSString *sql = @"DROP TABLE dim_student;DROP TABLE dim_pro_stu;DROP TABLE dim_recordInfo";
    [_db executeUpdate:sql];
}
@end
