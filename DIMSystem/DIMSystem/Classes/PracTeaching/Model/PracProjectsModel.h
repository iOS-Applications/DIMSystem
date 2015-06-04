//
//  PracProjectsModel.h
//  DIMSystem
//
//  Created by qingyun on 15/4/14.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PracProjectsModel : NSObject

@property (nonatomic,strong) NSString *PraPrj_id;
@property (nonatomic,strong) NSString *PraPrj_teaID;
@property (nonatomic,strong) NSString *PraPrj_title;
@property (nonatomic,strong) NSString *praPrj_sign;
@property (nonatomic,strong) NSString *PraPrj_source;
@property (nonatomic,strong) NSString *PraPrj_type;
@property (nonatomic,strong) NSString *PraPrj_teacher;
@property (nonatomic,strong) NSString *PraPrj_job;
@property (nonatomic,strong) NSString *PraPrj_stuNum;
@property (nonatomic,strong) NSString *PraPrj_descript1;
@property (nonatomic,strong) NSString *PraPrj_descript2;

- (instancetype)initPracProjectsWithInfo:(NSDictionary *)info;

@end
