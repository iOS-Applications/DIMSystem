//
//  DIMRecordInfo.h
//  DIMSystem
//
//  Created by 刘少毅 on 15/5/25.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMStudent;
@interface DIMRecordInfo : NSObject

//记录id
@property (nonatomic, assign) NSInteger rec_id;

//记录时间
@property (nonatomic, copy) NSString *rec_time;

//记录学生
@property (nonatomic, strong) NSArray *rec_students;

//信息记录
@property (nonatomic, strong) NSArray *rec_messages;

//记录类型
@property (nonatomic, assign)NSInteger rec_type;
@end
