//
//  symposiaModel.m
//  DIMSystem
//
//  Created by YaqiXu on 15/5/31.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "symposiaModel.h"

@implementation symposiaModel

- (instancetype)initPracProjectsWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.idstr = info[@"idStr"];
        self.semester = info[@"semester"];
        self.grade = info[@"grade"];
        self.time = info[@"time"];
        self.address = info[@"address"];
        self.peoples = info[@"peoples"];
        self.course = info[@"course"];
        self.idea = info[@"idea"];
        self.summarize = info[@"summarize"];
        
    }
    return self;
}
@end
