//
//  UIImage+CropPortraint.h
//  WecashWallet
//
//  Created by wecash on 14/12/31.
//  Copyright (c) 2014年 wecash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CropPortraint)

- (UIImage *)portraintWithSize:(CGSize)size;

+ (UIImage *)arrowImgWithSize:(CGSize)size lineColor:(UIColor *)lineColor;
+ (UIImage *)emailImgWithSize:(CGSize)size lineColor:(UIColor *)lineColor;

@end
