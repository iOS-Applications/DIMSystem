//
//  UIImage+CropPortraint.m
//  WecashWallet
//
//  Created by wecash on 14/12/31.
//  Copyright (c) 2014年 wecash. All rights reserved.
//

#import "UIImage+CropPortraint.h"

@implementation UIImage (CropPortraint)

- (UIImage *)portraintWithSize:(CGSize)size
{
    //先剪切出个正方形,这里的frame是正方形
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat cropWidth = 0.0f;
    
    CGRect cropRect = CGRectZero;
    
    if (imageWidth > imageHeight) {
        cropWidth = imageHeight;
        cropRect = CGRectMake((imageWidth - cropWidth)/2.0f, 0, cropWidth, cropWidth);
    } else if (imageWidth < imageHeight) {
        cropWidth = imageWidth;
        cropRect = CGRectMake(0, (imageHeight - cropWidth)/2.0f, cropWidth, cropWidth);
    } else {
        cropRect = CGRectMake(0, 0, imageWidth, imageHeight);
    }
    
    //剪切出image
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    //将cropImage绘制到frame中
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    [cropImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)arrowImgWithSize:(CGSize)size lineColor:(UIColor *)lineColor
{
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    CGFloat marginH = 3;
    CGFloat marginV = 5;
    CGFloat lineWidth = 1;
    CGFloat padding = 5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(padding, padding * 1.5, size.width - 2 * padding, size.height - 3 * padding) cornerRadius:3];
    CGFloat y = (size.height - lineWidth)/2;
    [path moveToPoint:CGPointMake(marginH + padding, y)];
    [path addLineToPoint:CGPointMake(size.width - marginH - padding, y)];
    
    CGFloat arrowWidth = 5;
    [path moveToPoint:CGPointMake(size.width - arrowWidth - marginH - 2 * padding, marginV + padding)];
    [path addLineToPoint:CGPointMake(size.width - marginH - padding, y)];
    [path moveToPoint:CGPointMake(size.width - arrowWidth - marginH - 2 * padding, size.height - marginV - padding)];
    [path addLineToPoint:CGPointMake(size.width - marginH - padding, y)];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineWidth:lineWidth];
    [lineColor setStroke];
    [path stroke];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)emailImgWithSize:(CGSize)size lineColor:(UIColor *)lineColor
{
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    CGFloat marginV = 5;
    CGFloat lineWidth = 1;
    CGFloat padding = 5;
    CGRect rect = CGRectMake(padding, padding * 1.5, size.width - 2 * padding, size.height - 3 * padding);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:3];
    
    [path moveToPoint:CGPointMake(rect.origin.x + 2, rect.origin.y + 2)];
    [path addLineToPoint:CGPointMake(rect.size.height, CGRectGetMaxY(rect) - marginV)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - 2, rect.origin.y + 2)];
    
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:lineWidth];
    [lineColor setStroke];
    [path stroke];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end



