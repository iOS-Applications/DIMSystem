//
//  defines.h
//  DIMSystem
//
//  Created by 麒涵 on 15/6/3.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#ifndef DIMSystem_defines_h
#define DIMSystem_defines_h
#define HMSingletonM(name) \
static id _instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

#endif
