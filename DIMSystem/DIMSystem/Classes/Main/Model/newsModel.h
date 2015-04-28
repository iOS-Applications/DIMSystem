//
//  newsModel.h
//  DIMSystem
//
//  Created by qingyun on 15/4/8.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newsModel : NSObject
@property (nonatomic,assign) NSInteger news_id;
@property (nonatomic,strong) NSString *newsicon_url;
@property (nonatomic,strong) NSString *news_title;
@property (nonatomic,strong) NSString *news_createtime;
@property (nonatomic,strong) NSString *news_description;

- (instancetype)initNewsModel:(NSDictionary *)info;
@end

