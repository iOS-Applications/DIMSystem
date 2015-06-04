//
//  symposiaModel.h
//  DIMSystem
//
//  Created by YaqiXu on 15/5/31.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface symposiaModel : NSObject

@property (nonatomic,strong)NSString  *idstr;
@property (nonatomic,strong)NSString  * semester;
@property (nonatomic,strong)NSString * grade;
@property (nonatomic,strong)NSString * time ;
@property (nonatomic,strong)NSString * address ;
@property (nonatomic,strong)NSString * peoples;
@property (nonatomic,strong)NSString * course;
@property (nonatomic,strong)NSString * idea;
@property (nonatomic,strong)NSString * summarize ;

- (instancetype)initPracProjectsWithInfo:(NSDictionary *)info;

@end
