//
//  UIBarButtonItem+DIM.m
//  DIMSystem
//
//  Created by qingyun on 15/4/5.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#import "UIBarButtonItem+DIM.h"

@implementation UIBarButtonItem (DIM)


+(UIBarButtonItem *)itemWithIcon:(NSString *)icon HighegIcon:(NSString *)highIcon Target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

@end
