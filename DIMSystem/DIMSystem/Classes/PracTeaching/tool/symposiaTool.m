//
//  QYStatusTool.m
//  Sina
//
//  Created by Qingyun on 15/3/22.
//  Copyright (c) 2015年 RenCH. All rights reserved.
//

#import "symposiaTool.h"
#import "FMDB.h"
#import "symposiaModel.h"
#import "defines.h"
@interface symposiaTool ()
@property (nonatomic,strong) FMDatabase *db;
@end

@implementation symposiaTool
HMSingletonM(symposiaTool)

static symposiaModel *model;



- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"symposia.db"];
        
       _db = [FMDatabase databaseWithPath:path ];
        
                NSLog(@"db>>path:%@",path);
        [_db open];
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_symposia (id integer PRIMARY KEY AUTOINCREMENT, symposia blob NOT NULL);"];
    }
    return self;
}
- (NSArray *)symposiaWithParams:(NSDictionary *)params
{
    NSString *sql = nil;
    sql = @"SELECT * FROM t_symposia;";
    
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *symposiaArray = [NSMutableArray array];
    while (set.next)
    {
        NSData *syposiaData = [set objectForColumnName:@"symposia"];
        NSString *idStr = [NSString stringWithFormat:@"%@",[set objectForColumnName:@"id"]];
        
        NSDictionary *symposia = [NSKeyedUnarchiver unarchiveObjectWithData:syposiaData];
        NSMutableDictionary *mutiDic = [NSMutableDictionary dictionaryWithDictionary:symposia];
        [mutiDic setValue:idStr forKey:@"idStr"];
        [symposiaArray addObject:mutiDic];
    }
    return symposiaArray;
}

- (void)deletSymosia:(NSInteger )id
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_symposia WHERE id = %ld,",(long)id];
    [_db executeUpdate:sql];
    [_db close];
}

- (void)saveSymposia:(NSDictionary *)symposia
{
   
        // NSDictionary --> NSData
        NSData *syposiaData = [NSKeyedArchiver archivedDataWithRootObject:symposia];
        [_db executeUpdateWithFormat:@"INSERT INTO t_symposia(symposia) VALUES (%@);", syposiaData];
   
}
@end
