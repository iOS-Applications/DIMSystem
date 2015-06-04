//
//  QYStatusTool.h
//  Sina
//
//  Created by Qingyun on 15/3/22.
//  Copyright (c) 2015年 RenCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface symposiaTool : NSObject
+ (instancetype)sharedsymposiaTool;
- (NSArray *)symposiaWithParams:(NSDictionary *)params;
- (void)saveSymposia:(NSDictionary *)symposia;
- (void)deletSymosia:(NSInteger )id;

@end
