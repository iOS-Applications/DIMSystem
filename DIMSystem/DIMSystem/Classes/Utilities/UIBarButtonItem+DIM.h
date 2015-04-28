//
//  UIBarButtonItem+DIM.h
//  DIMSystem
//
//  Created by qingyun on 15/4/5.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DIM)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon HighegIcon:(NSString *)highIcon Target:(id)target action:(SEL)action;
@end
