//
//  newsModel.m
//  DIMSystem
//
//  Created by qingyun on 15/4/8.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "newsModel.h"

@implementation newsModel
- (instancetype)initNewsModel:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.news_id = [info[@"news_id"] integerValue];
        self.newsicon_url = info[@"newsicon_url"];
        self.news_title = info[@"news_title"];
        self.news_createtime = info[@"news_createtime"];
        self.news_description = info [@"news_description"];
    }
    return self;
}
@end
