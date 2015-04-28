//
//  ZFQMecroDefine.h
//  DIMSystem
//
//  Created by wecash on 15/4/9.
//  Copyright (c) 2015年 zhongyuan. All rights reserved.
//

#ifndef DIMSystem_ZFQMecroDefine_h
#define DIMSystem_ZFQMecroDefine_h

//------------debug---------------
#define ZFQ_Debug 1
#ifdef ZFQ_Debug
#define ZFQ_LOG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ZFQ_LOG(xx, ...)  ((void)0)
#endif

//-----------RGB颜色---------------
#define ZFQ_RGB(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]

//----------按钮字体颜色-------------
#define ZFQ_LinkColorNormal ZFQ_RGB(59, 165, 249, 1)
#define ZFQ_LinkColorPressed ZFQ_RGB(59, 165, 249, 0.5)

#define ZFQ_BorderColor  [UIColor lightGrayColor]
#define ZFQ_BorderWidth   1.f
#define ZFQ_CornerRadius   4.f


//------------屏幕宽高-----------
#define ZFQ_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZFQ_ScreenHeight  [UIScreen mainScreen].bounds.size.height

#endif
