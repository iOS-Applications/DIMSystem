//
//  PracProjectsModel.m
//  DIMSystem
//
//  Created by qingyun on 15/4/14.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "PracProjectsModel.h"

@implementation PracProjectsModel

- (instancetype)initPracProjectsWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.PraPrj_id = info[@"PraPrj_id"];
        self.PraPrj_teaID = info[@"PraPrj_teaID"];
        self.praPrj_sign = info[@"PraPrj_sign"];//类型
        self.PraPrj_title = info[@"PraPrj_title"];
        self.PraPrj_source = info[@"PraPrj_source"];
        self.PraPrj_type = info[@"PraPrj_type"];
        self.PraPrj_teacher = info [@"PraPrj_teacher"];
        self.PraPrj_job = info[@"PraPrj_job"];
        self.PraPrj_stuNum = info[@"PraPrj_stuNum"];
        self.PraPrj_descript1 = info [@"PraPrj_descript1"];
        self.PraPrj_descript2 = info[@"PraPrj_descript2"];
    }
    return self;
}
@end
